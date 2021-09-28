//SPDX-License-Identifier: MIT
//INCOMPLETE

pragma solidity 0.8.6;

/*unaudited and for demonstration only, subject to all disclosures, licenses, and caveats of the open-source-law repo
**@dev create a simple smart escrow contract for retainer/escrowed atty-client (or other consultant) representation, with an ERC20 stablecoin as payment, expiration denominated in seconds
**NON-REFUNDED DEPOSIT except if both parties are ready to close but contract expires before closeRepresentation() called
**intended to be deployed by client (as funds are placed in escrow upon deployment, and returned to deployer if expired but mutually ready to close)
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
  address payable attorney;
  address stablecoin;
  uint256 retainer;
  uint256 effectiveTime;
  uint256 expirationTime;
  bool attorneyApproved;
  bool clientApproved;
  bool attorneyApproved2;
  bool clientApproved2;
  bool attorneyApproved3;
  bool clientApproved3;
  bool isExpired;
  bool isClosed;
  IERC20 public ierc20;
  string description;
  mapping(address => bool) public parties; //map whether an address is a party for restricted() modifier 
  
  event Expired(bool isExpired);
  event Closed(bool isClosed, uint256 effectiveTime); //event provides exact blockstamp time of payment 
  
  modifier restricted() { 
    require(parties[msg.sender], "This may only be called by a party or the by escrow contract");
    _;
  }
  
  //deployer (client) initiates escrow with description, retainer amount in USD, address of stablecoin, seconds until expiry, and designate recipient attorney
  //DEPLOYER MUST SEPARATELY APPROVE (by interacting with the ERC20 contract in question's approve()) this contract address for the retainer amount (keep decimals in mind)
  // @param: _description should be a brief identifier - perhaps as to parties/underlying asset/documentation reference/hash 
  // @param: _retainer is the total retainer amount which will be deposited in the smart escrow contract
  // @param: _seller is the attorney's address, who will receive the retainer in installments
  // @param: _stablecoin is the token contract address for the stablecoin to be sent as retainer
  // @param: _secsUntilExpiration is the number of seconds until expiry, which can be converted to days for front end input or the code can be adapted accordingly
  constructor(string memory _description, uint256 _retainer, address payable _attorney, address _stablecoin, uint256 _secsUntilExpiration) payable {
      require(_attorney != msg.sender, "Designate different party as attorney");
      client = payable(address(msg.sender));
      retainer = _retainer;
      escrowAddress = address(this);
      stablecoin = _stablecoin;
      ierc20 = IERC20(stablecoin);
      description = _description;
      attorney = _attorney;
      parties[msg.sender] = true;
      parties[_attorney] = true;
      parties[escrowAddress] = true;
      expirationTime = block.timestamp + _secsUntilExpiration;
  }
  
  // client may confirm recipient address as extra security measure or change address
  function designateAttorney(address payable _attorney) public restricted {
      require(_attorney != attorney, "Address already designated as attorney");
      require(_attorney != client, "Client cannot also be attorney");
      require(!isExpired, "Too late to change attorney");
      parties[_attorney] = true;
      attorney = _attorney;
  }
  
  // client deposits in escrowAddress
  function sendRetainer() public restricted returns(bool, uint256) {
      require(clientApproved, "Client should call the applicable installmentComplete() before sending funds"); // safety mechanism to prevent instance where attorney (but not client) is ready to close and funds are in escrow, which would send funds to attorney upon expiry if isExpired == true
      ierc20.transferFrom(client, escrowAddress, retainer);
      return (true, ierc20.balanceOf(escrowAddress));
      
  }
  
  //escrowAddress returns retainer to client
  function returnRetainer() internal returns(bool, uint256) {
      ierc20.transfer(client, retainer);
      return (true, ierc20.balanceOf(escrowAddress));
  }
  
  //escrowAddress sends retainer to attorney
  function payAttorney() internal returns(bool, uint256) {
      ierc20.transfer(attorney, retainer);
      return (true, ierc20.balanceOf(escrowAddress));
  } 
  
  //check if expired, and if so, return balance to client only if attorney is not ready to close, otherwise non-refundable if client fails to approve closing after sending funds
  //but, see sendDeposit()'s require statement safety mechanism requiring client to approve closing before sending funds via this contract)
  function checkIfExpired() public returns(bool){
        if (expirationTime <= uint256(block.timestamp) && !attorneyApproved) {
            isExpired = true;
            returnRetainer(); 
            emit Expired(isExpired);
        } else if (expirationTime <= uint256(block.timestamp) && attorneyApproved == true) {
            ierc20.transfer(attorney, retainer);
            isExpired = true;
            emit Expired(isExpired);
        } else {
            isExpired = false;
        }
        return(isExpired);
    }
    
  // for attorney to easily check if retainer is in escrowAddress
  function checkEscrow() public restricted view returns(uint256) {
      return ierc20.balanceOf(escrowAddress);
  }

  // if client wishes to initiate dispute over attorney breach of off chain agreement or repudiate, simply may wait for expiration without sending deposit nor calling this function
  // for attorney and client to call when first deliverable/milestone/hour threshold is complete
  function FirstInstallmentComplete() external restricted returns(string memory){
         if (msg.sender == attorney) {
            attorneyApproved = true;
            return("Attorney is ready to close.");
        } else if (msg.sender == client) {
            clientApproved = true;
            return("Client is ready to close.");
        } else {
            return("You are neither client nor attorney.");
        }
  }
  
  function SecondInstallmentComplete() external restricted returns(string memory){
         if (msg.sender == attorney) {
            attorneyApproved2 = true;
            return("Attorney is ready to close.");
        } else if (msg.sender == client) {
            clientApproved2 = true;
            return("Client is ready to close.");
        } else {
            return("You are neither client nor attorney.");
        }
  }
  
  function ThirdInstallmentComplete() external restricted returns(string memory){
         if (msg.sender == attorney) {
            attorneyApproved3 = true;
            return("Attorney is ready to close.");
        } else if (msg.sender == client) {
            clientApproved3 = true;
            return("Client is ready to close.");
        } else {
            return("You are neither client nor seller.");
        }
  }
    
  // checks if both client and attorney are ready to close and expiration has not been met; if so, escrowAddress pays out retainer to attorney
  // if properly closes, emits event with effective time of closing
  function closeRepresentation() public returns(bool){
      require(attorneyApproved && clientApproved, "Parties are not ready to close.");
      if (expirationTime <= uint256(block.timestamp)) {
            isExpired = true;
            returnRetainer(); // see comment above as to deposit refund for accidental expiration, optional/subject to negotiation of parties
            emit Expired(isExpired);
        } else {
            isClosed = true;
            payAttorney();
            effectiveTime = uint256(block.timestamp); // effective time of closing upon payment to attorney
            emit Closed(isClosed, effectiveTime);
        }
        return(isClosed);
  }
}
