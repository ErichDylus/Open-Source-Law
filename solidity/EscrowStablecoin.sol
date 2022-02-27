//SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;

/// unaudited and for demonstration only, subject to all disclosures, licenses, and caveats of the open-source-law repo
/// @title Stablecoin Escrow
/// @notice bilateral smart escrow contract, with an ERC20 stablecoin as payment, expiration denominated in seconds, deposit refunded if contract expires before closeDeal() called
/// @notice intended to be deployed by buyer (who must separately approve() the contract address for the deposited funds, and deposit is returned to deployer if expired)
/// @dev may be altered for separation of deposit from purchase price, deposit non-refundability, different token standard, etc.

interface IERC20 { 
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract EscrowStablecoin {
    
  address escrowAddress;
  address payable buyer;
  address payable seller;
  address stablecoin;
  uint256 deposit;
  uint256 expirationTime;
  bool sellerApproved;
  bool buyerApproved;
  bool isExpired;
  IERC20 public ierc20;
  string description;
  mapping(address => bool) public parties; //map whether an address is a party to the transaction for restricted() modifier 
  
  event DealExpired(bool isExpired);
  event DealClosed(bool isClosed, uint256 effectiveTime); //event provides exact blockstamp Unix ime of closing 

  error Expired();
  error NotBuyer();
  error NotReadyToClose();
  error BuyerAddrSameAsSellerAddr();
  
  modifier restricted() { 
    require(parties[msg.sender], "Not a Party");
    _;
  }
  
  /// @notice deployer (buyer) initiates escrow with description, deposit amount in USD, address of stablecoin, seconds until expiry, and designate recipient seller
  /// @param _description should be a brief identifier of the deal in question - perhaps as to parties/underlying asset/documentation reference/hash 
  /// @param _deposit is the purchase price which will be deposited in the smart escrow contract
  /// @param _seller is the seller's address, who will receive the purchase price if the deal closes
  /// @param _stablecoin is the token contract address for the stablecoin to be sent as deposit
  /// @param _secsUntilExpiration is the number of seconds until the deal expires, which can be converted to days for front end input or the code can be adapted accordingly
  constructor(string memory _description, uint256 _deposit, address payable _seller, address _stablecoin, uint256 _secsUntilExpiration) payable {
      if (_seller == msg.sender) revert BuyerAddrSameAsSellerAddr();
      buyer = payable(address(msg.sender));
      deposit = _deposit;
      escrowAddress = address(this);
      stablecoin = _stablecoin;
      ierc20 = IERC20(stablecoin);
      description = _description;
      seller = _seller;
      parties[msg.sender] = true;
      parties[_seller] = true;
      parties[escrowAddress] = true;
      expirationTime = block.timestamp + _secsUntilExpiration;
  }
  
  /// @notice buyer may confirm seller's recipient address as extra security measure or change seller address
  /// @param _seller is the new recipient address of seller
  function designateSeller(address payable _seller) external restricted {
      if (_seller == buyer) revert BuyerAddrSameAsSellerAddr();
      if (isExpired) revert Expired();
      parties[_seller] = true;
      seller = _seller;
  }
  
  /// ********* DEPLOYER MUST SEPARATELY APPROVE (by interacting with the ERC20 contract in question's approve()) this contract address for the deposit amount (keep decimals in mind) ********
  /// @notice buyer deposits in escrowAddress after separately ERC20-approving escrowAddress
  function depositInEscrow() external returns(bool, uint256) {
      if (msg.sender != buyer) revert NotBuyer();
      ierc20.transferFrom(buyer, escrowAddress, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
      
  }
  
  /// @notice escrowAddress returns deposit to buyer
  function returnDeposit() internal returns(bool, uint256) {
      ierc20.transfer(buyer, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
  }
  
  /// @notice escrowAddress sends deposit to seller
  function paySeller() internal returns(bool, uint256) {
      ierc20.transfer(seller, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
  } 
  
  /// @notice check if expired, and if so, return balance to buyer 
  function checkIfExpired() external returns(bool){
        if (expirationTime <= block.timestamp) {
            isExpired = true;
            returnDeposit(); 
            emit DealExpired(true);
        } else {
            isExpired = false;
        }
        return(isExpired);
    }
    
  /// @notice for seller to check if deposit is in escrowAddress
  function checkEscrow() external restricted view returns(uint256) {
      return ierc20.balanceOf(escrowAddress);
  }

  /// if buyer wishes to initiate dispute over seller breach of off chain agreement or repudiate, simply may wait for expiration without sending deposit nor calling this function
  function readyToClose() external restricted returns(string memory){
         if (msg.sender == seller) {
            sellerApproved = true;
            return("Seller is ready to close.");
        } else if (msg.sender == buyer) {
            buyerApproved = true;
            return("Buyer is ready to close.");
        } else {
            return("You are neither buyer nor seller.");
        }
  }
    
  /// @notice checks if both buyer and seller are ready to close and expiration has not been met; if so, escrowAddress closes deal and pays seller; if not, deposit returned to buyer
  /// @dev if properly closes, emits event with effective time of closing
  function closeDeal() public returns(bool isClosed){
      if (!sellerApproved || !buyerApproved) revert NotReadyToClose();
      if (expirationTime <= block.timestamp) {
            isExpired = true;
            returnDeposit();
            emit DealExpired(true);
        } else {
            paySeller();
            emit DealClosed(true, block.timestamp); // effective time of closing is block.timestamp upon payment to seller
        }
        return(true);
  }
}
