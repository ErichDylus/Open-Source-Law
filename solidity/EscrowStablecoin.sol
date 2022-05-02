//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

/// unaudited and for demonstration only, subject to all disclosures, licenses, and caveats of the open-source-law repo
/// @title Stablecoin Escrow
/// @notice bilateral smart escrow contract, with an ERC20 stablecoin as payment, expiration denominated in seconds, deposit refunded if contract expires before closeDeal() called 
/// @dev intended to be deployed by buyer - may be altered for separation of deposit from purchase price, deposit non-refundability, different token standard, etc.

interface IERC20 { 
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract EscrowStablecoin {
    
  address escrowAddress;
  address buyer;
  address seller;
  address stablecoin;
  uint256 deposit;
  uint256 expirationTime;
  bool sellerApproved;
  bool buyerApproved;
  bool isExpired;
  IERC20 public ierc20;
  string description;
  mapping(address => bool) public parties; //map whether an address is a party to the transaction for restricted() modifier 
  
  event DealExpired();
  event DealClosed(uint256 effectiveTime); //event provides exact blockstamp Unix ime of closing 

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
  constructor(string memory _description, uint256 _deposit, address _seller, address _stablecoin, uint256 _secsUntilExpiration) payable {
      if (_seller == msg.sender) revert BuyerAddrSameAsSellerAddr();
      buyer = msg.sender;
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
  function designateSeller(address _seller) external restricted {
      if (_seller == buyer) revert BuyerAddrSameAsSellerAddr();
      if (isExpired) revert Expired();
      parties[_seller] = true;
      seller = _seller;
  }
  
  /// @notice buyer deposits in escrowAddress ****** after separately ERC20-approving escrowAddress ****** by calling this function OR simply directly transfers the deposit to escrowAddress
  function depositInEscrow() external returns(bool, uint256) {
      if (msg.sender != buyer) revert NotBuyer();
      ierc20.transferFrom(buyer, escrowAddress, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
      
  }
  
  /// @notice escrowAddress returns deposit to buyer
  function _returnDeposit() internal returns(bool, uint256) {
      ierc20.transfer(buyer, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
  }
  
  /// @notice escrowAddress sends deposit to seller
  function _paySeller() internal returns(bool, uint256) {
      ierc20.transfer(seller, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
  } 
  
  /// @notice check if expired, and if so, return balance to buyer 
  function checkIfExpired() external returns(bool) {
        if (expirationTime <= block.timestamp) {
            isExpired = true;
            _returnDeposit(); 
            emit DealExpired();
        } else {
            isExpired = false;
        }
        return(isExpired);
    }
    
  /// @notice to check if deposit is in escrowAddress
  function checkEscrow() external view returns(uint256) {
      return ierc20.balanceOf(escrowAddress);
  }

  /// if buyer wishes to initiate dispute over seller breach of off chain agreement or repudiate, simply may wait for expiration without sending deposit nor calling this function
  /// @notice seller and buyer each call this when ready to close
  function readyToClose() external restricted returns(string memory) {
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
  function closeDeal() external {
      if (!sellerApproved || !buyerApproved) revert NotReadyToClose();
      if (expirationTime <= block.timestamp) {
            isExpired = true;
            _returnDeposit();
            emit DealExpired();
        } else {
            _paySeller();
            emit DealClosed(block.timestamp); // effective time of closing is block.timestamp upon payment to seller
        }
  }
}
