//SPDX-License-Identifier: MIT

pragma solidity 0.7.5;

/// unaudited and for demonstration only, subject to all disclosures, licenses, and caveats of the open-source-law repo
/// @author Erich Dylus
/// @title Escrow ETH
/// @notice a simple smart escrow contract, with ETH as payment, expiration denominated in seconds, and option for dispute resolution with LexLocker
/// @dev intended to be deployed by buyer (as funds are placed in escrow upon deployment, and returned to deployer if expired)
/// consider hardcoding reference or pointer to LexDAO resolver terms of use https://github.com/lexDAO/Arbitration/blob/master/rules/ToU.md
/// included in LexDAO's LexCorpus at: https://github.com/lexDAO/LexCorpus/blob/master/contracts/lexdao/lexlocker/extensions/EscrowETH.sol*/

interface LexLocker {
    function requestLockerResolution(address counterparty, address resolver, address token, uint256 sum, string calldata details, bool swiftResolver) external payable returns (uint256);
}

contract EscrowEth {
    
  //escrow struct to contain basic description of underlying deal, purchase price, ultimate recipient of funds
  struct InEscrow {
      string description;
      uint256 deposit;
      address payable buyer;
      address payable seller;
  }
  
  InEscrow[] public escrows;
  address escrowAddress = address(this);
  address payable immutable lexlocker = payable(0xD476595aa1737F5FdBfE9C8FEa17737679D9f89a); //LexLocker ETH mainnet contract address
  address payable immutable lexDAO = payable(0x01B92E2C0D06325089c6Fd53C98a214f5C75B2aC); //lexDAO ETH mainnet address, used below as resolver 
  address payable buyer;
  address payable seller;
  uint256 deposit;
  uint256 expirationTime;
  bool sellerApproved;
  bool buyerApproved;
  bool isDisputed;
  bool isExpired;
  bool isClosed;
  string description;
  mapping(address => bool) public parties; //map whether an address is a party to the transaction for restricted() modifier 
  
  event EscrowInPlace(address indexed buyer, uint256 deposit);
  event DealDisputed(address indexed sender, bool isDisputed);
  event DealExpired(bool isExpired);
  event DealClosed(bool isClosed);
  
  modifier restricted() { 
    require(parties[msg.sender], "This may only be called by a party to the deal or the escrow contract itself");
    _;
  }
  
  /// @notice creator contributes deposit and initiates escrow with description, deposit amount, seconds until expiry, and designate recipient seller
  /// @param _description string to identify deal, or IPFS hash of documentation, etc.
  /// @param _deposit deposit amount in wei
  /// @param _seller payment address of recipient seller
  /// @param _secsUntilExpiration seconds until expiry of escrow, for simplicity in calculation of Unix time w/ block.timestamp
  constructor(string memory _description, uint256 _deposit, address payable _seller, uint256 _secsUntilExpiration) payable {
      require(msg.value >= deposit, "Submit deposit amount");
      require(_seller != msg.sender, "Designate different party as seller");
      buyer = payable(address(msg.sender));
      deposit = _deposit;
      description = _description;
      seller = _seller;
      parties[msg.sender] = true;
      parties[_seller] = true;
      parties[escrowAddress] = true;
      expirationTime = block.timestamp + _secsUntilExpiration;
      sendEscrow(description, deposit, buyer, seller);
  }
  
  /// @notice buyer may confirm seller's recipient address as extra security measure
  /// @param _seller new seller's public key address
  function designateSeller(address payable _seller) external restricted {
      require(_seller != seller, "Party already designated as seller");
      require(_seller != buyer, "Buyer cannot also be seller");
      require(!isExpired, "Deal expired, too late to change seller");
      parties[_seller] = true;
      seller = _seller;
  }
  
  /// @notice send escrow, create InEscrow struct and emit event showing the deposit is in place
  function sendEscrow(string memory _description, uint256 _deposit, address payable _buyer, address payable _seller) private restricted {
      InEscrow memory newRequest = InEscrow({
         description: _description,
         deposit: _deposit,
         buyer: _buyer,
         seller: _seller
      });
      escrows.push(newRequest);
      emit EscrowInPlace(_buyer, _deposit);
  }
  
  /// @notice check if expired, and if so, return balance to buyer
  function checkIfExpired() external returns(bool){
        if (expirationTime <= block.timestamp) {
            isExpired = true;
            buyer.transfer(escrowAddress.balance);
            emit DealExpired(isExpired);
        } else {
            isExpired = false;
        }
        return(isExpired);
    }
    
  /// @notice for early termination by either buyer or seller due to claimed breach of the other party, claiming party requests LexLocker resolution. deposit either returned to buyer or remitted to seller as liquidated damages
  function disputeDeal(address _token, string calldata _details, bool _singleArbiter) external restricted returns(string memory){
      require(!isClosed && !isExpired, "Too late for early termination");
      if (msg.sender == seller) {
            LexLocker(lexlocker).requestLockerResolution(buyer, lexDAO, _token, deposit, _details, _singleArbiter);
            lexlocker.transfer(escrowAddress.balance);
            isDisputed = true;
            emit DealDisputed(seller, isDisputed);
            return("Seller has initiated LexLocker dispute resolution.");
        } else if (msg.sender == buyer) {
            LexLocker(lexlocker).requestLockerResolution(seller, lexDAO, _token, deposit, _details, _singleArbiter);
            lexlocker.transfer(escrowAddress.balance); //  presumably balance only holds the deposit amount if buyer is initiating dispute
            isDisputed = true;
            emit DealDisputed(buyer, isDisputed);
            return("Buyer has initiated Lexlocker dispute resolution.");
        } else {
            return("You are neither buyer nor seller.");
        }
  }

  /// @notice seller and buyer each call when ready to close
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
    
  /// @notice checks if both buyer and seller are ready to close and expiration has not been met; if so, closes deal and pay seller
  function closeDeal() public returns(bool){
      require(sellerApproved && buyerApproved, "Parties are not ready to close.");
      if (expirationTime <= block.timestamp) {
            isExpired = true;
            buyer.transfer(escrowAddress.balance);
            emit DealExpired(isExpired);
        } else {
            isClosed = true;
            seller.transfer(escrowAddress.balance);
            emit DealClosed(isClosed);
        }
        return(isClosed);
  }
}
