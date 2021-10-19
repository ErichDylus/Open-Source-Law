//SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

/* unaudited and for demonstration only, subject to all disclosures, licenses, and caveats of the open-source-law repo
** create an on-chain record of a deal's public terms, decentralized doc storage (which would presumably carry an additional hash layer/other security mechanism for access), and closing details
*/

contract DealStamp {
    
  uint256 dealNumber;
  DealInformation[] public deals; //array of deal info structs
  mapping(address => uint256 /*dealNumber*/) public dealParty; //map whether an address is a party to the indexed deal
  mapping(uint256 /*dealNumber*/ => string) documentsLocation; //deal doc storage location - may be encrypted on the client side and decrypted after retrieval, or otherwise protected
 
  struct DealInformation {
      uint256 dealNumber;
      uint256 effectiveTime;
      string documentsLocation; 
      address party1;
      address party2;
  }
  
  event DealAdded(uint256 dealNumber, uint256 effectiveTime, string documentsLocation, address party1, address party2);  
  
  modifier restricted() { 
    require(dealParty[msg.sender] == dealNumber, "This may only be called by a party to a deal");
    _;
  }
  
  constructor() {
      dealNumber = 0;
      deals.push(DealInformation(dealNumber,0,"constructor",address(this),address(this)));
  }
  
  function newDealStamp(string calldata _documentsLocationHash, uint256 effectiveTime, address _party1, address _party2) external returns (uint256){
      dealNumber++;
      documentsLocation[dealNumber] = _documentsLocationHash;
      deals.push(DealInformation(dealNumber, effectiveTime, documentsLocation[dealNumber], _party1, _party2));
      emit DealAdded(dealNumber, effectiveTime, documentsLocation[dealNumber], _party1, _party2);
      return(dealNumber);
  }
  
  function viewDeal(uint256 _dealNumber) external view returns (uint256, uint256, string memory, address, address) {
      return (deals[_dealNumber].dealNumber, deals[_dealNumber].effectiveTime, deals[_dealNumber].documentsLocation, deals[_dealNumber].party1, deals[_dealNumber].party2);
  }
  
  function addPartyAccess(uint256 _dealNumber, address _newParty) external restricted {
      require(dealParty[msg.sender] == _dealNumber, "Must be a party to the deal to add another party.");
      require(dealParty[_newParty] > 0, "Please submit a new address");
      dealParty[_newParty] = _dealNumber;
  }
}
