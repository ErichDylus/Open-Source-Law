//SPDX-License-Identifier: MIT

pragma solidity 0.8.6;

// unaudited and subject to all disclosures, licenses, and caveats of the open-source-law repo
// create an on-chain record of a deal's parties, decentralized doc storage ref (which would presumably carry an additional hash layer/other security mechanism for access), and time of closing
// adaptations/forks might include a record of oracle information used in an on-chain closing, gasless sig verification, dispute resolution details, etc.

contract DealStamp {
    
  uint256 dealNumber; // ID number for stamped deals
  DealInformation[] deals; // array of deal info structs
  mapping(address => uint256 /*dealNumber*/) dealParty; // map whether an address is a party to the enumerated deal
  mapping(uint256 /*dealNumber*/ => string) documentsLocation; // deal doc storage location - may be encrypted on the client side and decrypted after retrieval, or otherwise protected
 
  struct DealInformation {
      uint256 dealNumber;
      uint256 effectiveTime;
      string documentsLocation; 
      address party1;
      address party2;
  }
  
  event DealStamped(uint256 dealNumber, uint256 effectiveTime, string documentsLocation, address party1, address party2);  
  
  constructor() {
      dealNumber = 0;
      deals.push(DealInformation(dealNumber,0,"constructor",address(this),address(this)));
  }
  
  // @param _documentsLocationHash: IPFS or other decentralized storage location hash of deal documents
  // @param _effectiveTime: unix time of closing, such as the block.timestamp of a stablecoin transfer or smart escrow contract closing
  // @param _party1: address of a party to the deal
  // @param _party2: address of a party to the deal
  function newDealStamp(string calldata _documentsLocationHash, uint256 _effectiveTime, address _party1, address _party2) external returns (uint256) {
      dealNumber++;
      documentsLocation[dealNumber] = _documentsLocationHash;
      deals.push(DealInformation(dealNumber, _effectiveTime, documentsLocation[dealNumber], _party1, _party2));
      emit DealStamped(dealNumber, _effectiveTime, documentsLocation[dealNumber], _party1, _party2);
      return(dealNumber); // DealStamper should keep a record of the dealNumber and provide to relevant parties
  }
  
  // @param _dealNumber: enter dealNumber to view corresponding stamped deal information
  function viewDeal(uint256 _dealNumber) external view returns (uint256, uint256, string memory, address, address) {
      return (deals[_dealNumber].dealNumber, deals[_dealNumber].effectiveTime, deals[_dealNumber].documentsLocation, deals[_dealNumber].party1, deals[_dealNumber].party2);
  }
}
