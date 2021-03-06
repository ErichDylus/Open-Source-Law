//SPDX-License-Identifier: MIT
//********* IN PROCESS *****************

pragma solidity ^0.8.6;

// unaudited and for demonstration only, subject to all disclosures, licenses, and caveats of the open-source-law repo
/// @dev smart escrow contract for retainer/escrowed service work or client representation, with an ERC20 stablecoin as payment, expiration denominated in seconds
/* three milestones, with equal installment payments per milestone
** remainder of retainer amount is refunded to client if milestone(s) not accomplished by expiry
** intended to be deployed by client (as funds are placed in escrow upon deployment, and returned to deployer if expired but mutually ready to close). Three equal installment amounts.
** may be forked/altered for number of installments and breakdown of each amount, retainer refundability, etc. */

interface IERC20 { 
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract InstallmentEscrow {
    
  address escrowAddress;
  address client;
  address servicer;
  uint256 retainer;
  uint256 expirationTime;
  bool servicerApproved;
  bool clientApproved;
  bool servicerApproved2;
  bool clientApproved2;
  bool servicerApproved3;
  bool clientApproved3;
  bool isExpired;
  bool isClosed;
  IERC20 public ierc20;
  string description;
  mapping(address => bool) public parties; //map whether an address is a party for restricted() modifier 
  
  enum Installment {
        Unpaid,
        FirstPaid,
        SecondPaid,
        ThirdPaid
    }
  Installment public installment;

  error AlreadyPaid();
  error Expired();
  error NotApproved();
  error NotClient();
  error PriorMilestoneIncomplete();
  error ImproperServicer();

  event firstMilestoneCompleted(uint256 firstMilestoneTime);
  event secondMilestoneCompleted(uint256 secondMilestoneTime);
  event hasExpired(bool isExpired);
  event Closed(bool isClosed, uint256 effectiveTime); //event provides exact blockstamp time of payment 
  
  modifier restricted() { 
    require(parties[msg.sender], "NOT_PARTY");
    _;
  }
  
  /// @dev deployer (client) initiates escrow with description, retainer amount in USD, address of stablecoin, seconds until expiry, and designate recipient servicer
  /// @param _description should be a brief identifier - perhaps as to parties/underlying asset/documentation reference/hash 
  /// @param _retainer the total retainer amount which will be deposited in the smart escrow contract assuming 18 decimals
  /// @param _servicer the servicer's address, who will receive the retainer in installments; in practice this could be a consultant or attorney
  /// @param _stablecoin the token contract address for the stablecoin to be sent as retainer
  /// @param _secsUntilExpiration the number of seconds until expiry, which can be converted to days for front end input or the code can be adapted accordingly
  constructor(string memory _description, uint256 _retainer, address payable _servicer, address _stablecoin, uint256 _secsUntilExpiration) payable {
      if (_servicer == msg.sender) revert ImproperServicer();
      client = msg.sender;
      retainer = _retainer;
      escrowAddress = address(this);
      ierc20 = IERC20(_stablecoin);
      description = _description;
      servicer = _servicer;
      parties[msg.sender] = true;
      parties[_servicer] = true;
      parties[escrowAddress] = true;
      expirationTime = block.timestamp + _secsUntilExpiration;
  }
  
  /// @param _servicer address of new servicer
  function designateServiceProvider(address payable _servicer) public restricted {
      if (_servicer == client) revert ImproperServicer();
      if (isExpired) revert Expired();
      parties[_servicer] = true;
      servicer = _servicer;
  }
  
  // ********** DEPLOYER MUST SEPARATELY APPROVE (by interacting with the ERC20 contract in question's approve()) this contract address for the retainer amount (keep decimals in mind) ************
  // client deposits in escrowAddress
  function sendRetainer() external returns(bool, uint256) {
      if (msg.sender != client) revert NotClient(); 
      ierc20.transferFrom(client, escrowAddress, retainer);
      return (true, ierc20.balanceOf(escrowAddress));
      
  }
  
  //escrowAddress returns remainder of retainer to client
  function returnToClient() internal returns(bool, uint256) {
      ierc20.transfer(client, ierc20.balanceOf(escrowAddress));
      return (true, ierc20.balanceOf(escrowAddress));
  }
  
  //check if expired, and if so, return balance to client only if servicer is not ready to close, otherwise non-refundable if client fails to approve closing after sending funds
  //but, see sendDeposit()'s require statement safety mechanism requiring client to approve closing before sending funds via this contract)
  function checkIfExpired() external returns(bool){
        if (expirationTime <= uint256(block.timestamp)) {
            isExpired = true;
            returnToClient(); 
            emit hasExpired(isExpired);
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
      if (installment != Installment.Unpaid) revert AlreadyPaid();
      if (!servicerApproved || !clientApproved) revert NotApproved();
      ierc20.transfer(servicer, retainer/3);
      installment = Installment.FirstPaid;
      emit firstMilestoneCompleted(block.timestamp);
      return (true, ierc20.balanceOf(escrowAddress));
  } 
  
  function secondMilestoneComplete() external restricted returns(string memory){
        if (!servicerApproved || !clientApproved) revert PriorMilestoneIncomplete();
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
      if (installment == Installment.SecondPaid) revert AlreadyPaid();
      if (!servicerApproved2 || !clientApproved2) revert NotApproved();
      ierc20.transfer(servicer, retainer/3);
      installment = Installment.SecondPaid;
      emit secondMilestoneCompleted(block.timestamp);
      return (true, ierc20.balanceOf(escrowAddress));
  } 
  
  function thirdMilestoneComplete() external restricted returns(string memory){
        if (!servicerApproved2 || !clientApproved2) revert PriorMilestoneIncomplete();
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
      if (installment == Installment.ThirdPaid) revert AlreadyPaid();
      if (!servicerApproved3 || !clientApproved3) revert NotApproved();
      if (expirationTime <= uint256(block.timestamp)) {
            isExpired = true;
            returnToClient(); // see comment above as to deposit refund for accidental expiration, optional/subject to negotiation of parties
            emit hasExpired(isExpired);
        } else {
            ierc20.transfer(servicer, ierc20.balanceOf(escrowAddress));
            installment = Installment.ThirdPaid;
            isClosed = true;
            emit Closed(isClosed, block.timestamp); // effective time of closing upon payment to servicer
        }
        return(isClosed);
  }
}
