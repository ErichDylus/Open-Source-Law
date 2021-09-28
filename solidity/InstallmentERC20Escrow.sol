//SPDX-License-Identifier: MIT
//INCOMPLETE
pragma solidity 0.8.6;

/*unaudited and for demonstration only, subject to all disclosures, licenses, and caveats of the open-source-law repo
**@dev create a simple smart escrow contract for retainer/escrowed service work or client representation, with an ERC20 stablecoin as payment, expiration denominated in seconds
**NON-REFUNDED DEPOSIT except if both parties are ready to disburse installment but contract expires before closeRepresentation() called
**intended to be deployed by client (as funds are placed in escrow upon deployment, and returned to deployer if expired but mutually ready to close). Three equal installment amounts.
**may be forked/altered for number of installments and breakdown of each amount, retainer refundability, etc. */

interface IERC20 { 
    function approve(address spender, uint256 amount) external returns (bool); 
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract InstallmentEscrow {
    
  address escrowAddress;
  address payable client;
  address payable servicer;
  address stablecoin;
  uint256 retainer;
  uint256 effectiveTime;
  uint256 expirationTime;
  bool servicerApproved;
  bool clientApproved;
  bool firstInstallmentPaid;
  bool servicerApproved2;
  bool clientApproved2;
  bool secondInstallmentPaid;
  bool servicerApproved3;
  bool clientApproved3;
  bool isExpired;
  bool isClosed;
  IERC20 public ierc20;
  string description;
  mapping(address => bool) public parties; //map whether an address is a party for restricted() modifier 
  
  event firstMilestoneCompleted(uint256 firstMilestoneTime);
  event secondMilestoneCompleted(uint256 secondMilestoneTime);
  event Expired(bool isExpired);
  event Closed(bool isClosed, uint256 effectiveTime); //event provides exact blockstamp time of payment 
  
  modifier restricted() { 
    require(parties[msg.sender], "This may only be called by a party or the by escrow contract");
    _;
  }
  
  //deployer (client) initiates escrow with description, retainer amount in USD, address of stablecoin, seconds until expiry, and designate recipient servicer
  // @param: _description should be a brief identifier - perhaps as to parties/underlying asset/documentation reference/hash 
  // @param: _retainer is the total retainer amount which will be deposited in the smart escrow contract
  // @param: _servicer is the servicer's address, who will receive the retainer in installments; in practice this could be a consultant or attorney
  // @param: _stablecoin is the token contract address for the stablecoin to be sent as retainer
  // @param: _secsUntilExpiration is the number of seconds until expiry, which can be converted to days for front end input or the code can be adapted accordingly
  constructor(string memory _description, uint256 _retainer, address payable _servicer, address _stablecoin, uint256 _secsUntilExpiration) payable {
      require(_servicer != msg.sender, "Designate different party as servicer/service provider");
      client = payable(address(msg.sender));
      retainer = _retainer;
      escrowAddress = address(this);
      stablecoin = _stablecoin;
      ierc20 = IERC20(stablecoin);
      description = _description;
      servicer = _servicer;
      parties[msg.sender] = true;
      parties[_servicer] = true;
      parties[escrowAddress] = true;
      expirationTime = block.timestamp + _secsUntilExpiration;
  }
  
  // ********** DEPLOYER MUST SEPARATELY APPROVE (by interacting with the ERC20 contract in question's approve()) this contract address for the retainer amount (keep decimals in mind) ************
  
  // client may confirm recipient address as extra security measure or change address
  function designateAttorney(address payable _servicer) public restricted {
      require(_servicer != servicer, "Address already designated as servicer");
      require(_servicer != client, "Client cannot also be servicer");
      require(!isExpired, "Too late to change servicer");
      parties[_servicer] = true;
      servicer = _servicer;
  }
  
  // client deposits in escrowAddress
  function sendRetainer() public restricted returns(bool, uint256) {
      require(clientApproved, "Client should call the applicable installmentComplete() before sending funds"); // safety mechanism to prevent instance where servicer (but not client) is ready to close and funds are in escrow, which would send funds to servicer upon expiry if isExpired == true
      ierc20.transferFrom(client, escrowAddress, retainer);
      return (true, ierc20.balanceOf(escrowAddress));
      
  }
  
  //escrowAddress returns retainer to client
  function returnRetainer() internal returns(bool, uint256) {
      ierc20.transfer(client, retainer);
      return (true, ierc20.balanceOf(escrowAddress));
  }
  
  //check if expired, and if so, return balance to client only if servicer is not ready to close, otherwise non-refundable if client fails to approve closing after sending funds
  //but, see sendDeposit()'s require statement safety mechanism requiring client to approve closing before sending funds via this contract)
  function checkIfExpired() public returns(bool){
        if (expirationTime <= uint256(block.timestamp) && !servicerApproved) {
            isExpired = true;
            returnRetainer(); 
            emit Expired(isExpired);
        } else if (expirationTime <= uint256(block.timestamp) && servicerApproved == true) {
            ierc20.transfer(servicer, retainer);
            isExpired = true;
            emit Expired(isExpired);
        } else {
            isExpired = false;
        }
        return(isExpired);
    }
    
  // for servicer to easily check if retainer is in escrowAddress
  function checkEscrow() public restricted view returns(uint256) {
      return ierc20.balanceOf(escrowAddress);
  }

  // if client wishes to initiate dispute over servicer breach of off chain agreement or repudiate, simply may wait for expiration without sending deposit nor calling this function
  // for servicer and client to call when first deliverable/milestone/hour threshold is complete
  function firstMilestoneComplete() external restricted returns(string memory){
         if (msg.sender == servicer) {
            servicerApproved = true;
            return("Servicer confirms first milestone is complete.");
        } else if (msg.sender == client) {
            clientApproved = true;
            return("Client confirms first milestone is complete.");
        } else {
            return("You are neither client nor servicer.");
        }
  }
  
  //escrowAddress sends first installment to servicer
  function payFirstInstallment() external restricted returns(bool, uint256) {
      require(!firstInstallmentPaid, "Already paid first installment.");
      require (servicerApproved && clientApproved, "Servicer and client must call FirstMilestoneComplete().");
      ierc20.transfer(servicer, retainer/3);
      firstInstallmentPaid = true;
      emit firstMilestoneCompleted(block.timestamp);
      return (true, ierc20.balanceOf(escrowAddress));
  } 
  
  function secondMilestoneComplete() external restricted returns(string memory){
        require(servicerApproved && clientApproved, "First Milestone is not complete.");
        if (msg.sender == servicer) {
            servicerApproved2 = true;
            return("Servicer confirms second milestone is complete.");
        } else if (msg.sender == client) {
            clientApproved2 = true;
            return("Client confirms second milestone is complete.");
        } else {
            return("You are neither client nor servicer.");
        }
  }
  
  //escrowAddress sends second installment to servicer
  function paySecondInstallment() external restricted returns(bool, uint256) {
      require(!secondInstallmentPaid, "Already paid second installment.");
      require (servicerApproved2 && clientApproved2, "Servicer and client must call SecondMilestoneComplete().");
      ierc20.transfer(servicer, retainer/3);
      secondInstallmentPaid = true;
      emit secondMilestoneCompleted(block.timestamp);
      return (true, ierc20.balanceOf(escrowAddress));
  } 
  
  function thirdMilestoneComplete() external restricted returns(string memory){
        require(servicerApproved2 && clientApproved2, "Second Milestone is not complete.");
        if (msg.sender == servicer) {
            servicerApproved3 = true;
            return("Servicer confirms third milestone is complete.");
        } else if (msg.sender == client) {
            clientApproved3 = true;
            return("Client confirms third milestone is complete.");
        } else {
            return("You are neither client nor servicer.");
        }
  }
    
  // checks if both client and servicer are ready to close representation and expiration has not been met; if so, escrowAddress pays out remainder of retainer to servicer
  // if properly closes, emits event with effective time of closing
  function closeRepresentation() public returns(bool){
      require(servicerApproved3 && clientApproved3, "Third Milestone is not complete.");
      if (expirationTime <= uint256(block.timestamp)) {
            isExpired = true;
            returnRetainer(); // see comment above as to deposit refund for accidental expiration, optional/subject to negotiation of parties
            emit Expired(isExpired);
        } else {
            ierc20.transfer(servicer, ierc20.balanceOf(escrowAddress));
            isClosed = true;
            effectiveTime = uint256(block.timestamp); // effective time of closing upon payment to servicer
            emit Closed(isClosed, effectiveTime);
        }
        return(isClosed);
  }
}
