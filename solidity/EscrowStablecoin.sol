//SPDX-License-Identifier: MIT

pragma solidity 0.7.5;

/*unaudited and for demonstration only, subject to all disclosures, licenses, and caveats of the open-source-law repo
**@dev create a simple smart escrow contract, with an ERC20 stablecoin as payment, expiration denominated in seconds, NON-REFUNDED DEPOSIT except if both parties are ready to close but contract expires before closeDeal() called
**intended to be deployed by buyer (as funds are placed in escrow upon deployment, and returned to deployer if expired)*/

interface IERC20 { 
    function approve(address spender, uint256 amount) external returns (bool); 
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
  uint256 effectiveTime;
  uint256 expirationTime;
  bool sellerApproved;
  bool buyerApproved;
  bool isExpired;
  bool isClosed;
  IERC20 public ierc20;
  string description;
  mapping(address => bool) public parties; //map whether an address is a party to the transaction for restricted() modifier 
  
  event DealExpired(bool isExpired);
  event DealClosed(bool isClosed, uint256 effectiveTime); //event provides exact blockstamp time of closing 
  
  modifier restricted() { 
    require(parties[msg.sender], "This may only be called by a party to the deal or the by escrow contract");
    _;
  }
  
  //deployer (buyer) initiates escrow with description, deposit amount in USD, address of stablecoin, seconds until expiry, and designate recipient seller
  //DEPLOYER MUST SEPARATELY APPROVE (by interacting with the ERC20 contract in question's approve()) this contract address for the deposit amount (keep decimals in mind)
  // @param: _description should be a brief identifier of the deal in question - perhaps as to parties/underlying asset/documentation reference/hash 
  // @param: _deposit is the purchase price which will be deposited in the smart escrow contract
  // @param: _seller is the seller's address, who will receive the purchase price if the deal closes
  // @param: _stablecoin is the token contract address for the stablecoin to be sent as deposit
  // @param: _secsUntilExpiration is the number of seconds until the deal expires, which can be converted to days for front end input or the code can be adapted accordingly
  constructor(string memory _description, uint256 _deposit, address payable _seller, address _stablecoin, uint256 _secsUntilExpiration) payable {
      require(_seller != msg.sender, "Designate different party as seller");
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
  
  // buyer may confirm seller's recipient address as extra security measure or change seller address
  function designateSeller(address payable _seller) public restricted {
      require(_seller != seller, "Party already designated as seller");
      require(_seller != buyer, "Buyer cannot also be seller");
      require(!isExpired, "Too late to change seller");
      parties[_seller] = true;
      seller = _seller;
  }
  
  //buyer deposits in escrowAddress
  function sendDeposit() public restricted returns(bool, uint256) {
      require(buyerApproved, "Buyer should call readyToClose() before sending funds"); // safety mechanism to prevent instance where seller (but not buyer) is ready to close and funds are in escrow, which would send funds to seller upon expiry if isExpired == true
      ierc20.transferFrom(buyer, escrowAddress, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
      
  }
  
  //escrowAddress returns deposit to buyer
  function returnDeposit() internal returns(bool, uint256) {
      ierc20.transfer(buyer, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
  }
  
  //escrowAddress sends deposit to seller
  function paySeller() internal returns(bool, uint256) {
      ierc20.transfer(seller, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
  } 
  
  //check if expired, and if so, return balance to buyer only if seller is not ready to close, otherwise non-refundable to buyer if buyer fails to approve closing after sending funds
  //but, see sendDeposit()'s require statement safety mechanism requiring buyer to approve closing before sending funds via this contract)
  function checkIfExpired() public returns(bool){
        if (expirationTime <= uint256(block.timestamp) && !sellerApproved) {
            isExpired = true;
            returnDeposit(); 
            emit DealExpired(isExpired);
        } else if (expirationTime <= uint256(block.timestamp) && sellerApproved == true) {
            ierc20.transfer(seller, deposit);
            isExpired = true;
            emit DealExpired(isExpired);
        } else {
            isExpired = false;
        }
        return(isExpired);
    }
    
  // for seller to check if deposit is in escrowAddress
  function checkEscrow() public restricted view returns(uint256) {
      return ierc20.balanceOf(escrowAddress);
  }

  // if buyer wishes to initiate dispute over seller breach of off chain agreement or repudiate, simply may wait for expiration without sending deposit nor calling this function
  function readyToClose() public restricted returns(string memory){
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
    
  // checks if both buyer and seller are ready to close and expiration has not been met; if so, escrowAddress closes deal and pays seller
  // if properly closes, emits event with effective time of closing
  function closeDeal() public returns(bool){
      require(sellerApproved && buyerApproved, "Parties are not ready to close.");
      if (expirationTime <= uint256(block.timestamp)) {
            isExpired = true;
            returnDeposit(); 
            emit DealExpired(isExpired);
        } else {
            isClosed = true;
            paySeller();
            effectiveTime = uint256(block.timestamp); // effective time of closing upon payment to seller
            emit DealClosed(isClosed, effectiveTime);
        }
        return(isClosed);
  }
}
