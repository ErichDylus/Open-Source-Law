//SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

/// unaudited and subject to all disclosures, licenses, and caveats of the open-source-law repo
/// @title DealStamp
/// @author Erich Dylus
/// @notice An on-chain record of a deal's parties, decentralized doc room storage ref (presumably carrying an additional hash layer/other security mechanism for access), and time of closing
/// adaptations/forks might include a record of oracle information used in an on-chain closing, gasless sig verification, removal of parties from array, dispute resolution details, etc.

contract DealStamp {
    
  uint256 dealNumber; // ID number for stamped deals
  DealInformation[] deals; // array of deal info structs
  mapping(uint256 /*dealNumber*/ => string) docsLocation; // deal doc storage location - may be encrypted on the client side and decrypted after retrieval, or otherwise protected
  mapping(address => bool) isParty;
  mapping(uint256 => mapping(address => bool)) isPartyToDeal;
 
  struct DealInformation {
      uint256 dealNumber;
      uint256 effectiveTime;
      string docsLocation; 
      address[] parties;
  }
  
  event DealStamped(uint256 indexed dealNumber, uint256 effectiveTime, string docsLocation, address[] parties);  
  event PartyAdded(uint256 indexed dealNumber, address newParty);
  
  constructor() {}
  
  /// @param _docsLocationHash IPFS or other decentralized storage location hash of deal documents
  /// @param _effectiveTime unix time of closing, such as the block.timestamp of a stablecoin transfer or smart escrow contract closing
  /// @param _party1 address of first party to the deal
  /// @param _party2 address of second party to the deal
  /// @return the dealNumber of the newly stamped deal
  /// @notice intended to be called by authorized party, escrow or other closing smart contracts, by interface or arbitrary call. Additional parties may be added by _party1 or _party2 via addPartyToDeal()
  function newDealStamp(string calldata _docsLocationHash, uint256 _effectiveTime, address _party1, address _party2) external returns (uint256) {
      dealNumber++;
      docsLocation[dealNumber] = _docsLocationHash;
      address[] memory parties = new address[](2);
      parties[0] = _party1;
      parties[1] = _party2;
      deals.push(DealInformation(dealNumber, _effectiveTime, docsLocation[dealNumber], parties));
      emit DealStamped(dealNumber, _effectiveTime, docsLocation[dealNumber], parties);
      isPartyToDeal[dealNumber][_party1] = true;
      isPartyToDeal[dealNumber][_party2] = true;
      return(dealNumber); // DealStamper should keep a record of the dealNumber and provide to relevant parties; also emitted in the DealStamped event 
  }
  
  /// @param _dealNumber enter dealNumber to view corresponding stamped deal information
  /// @return the struct information for the inputted dealNumber
  function viewDeal(uint256 _dealNumber) external view returns (uint256, uint256, string memory, address[] memory) {
      return (deals[_dealNumber].dealNumber, deals[_dealNumber].effectiveTime, deals[_dealNumber].docsLocation, deals[_dealNumber].parties);
  }
  
  /// @param _dealNumber deal number of deal for which the new party will be added
  /// @param _newParty address of the new party to be added to the deal corresponding to _dealNumber
  function addPartyToDeal(uint256 _dealNumber, address _newParty) external returns (bool success) {
      require(isPartyToDeal[_dealNumber][msg.sender] == true, "Must be a party to this deal in order to add a party");
      isPartyToDeal[_dealNumber][_newParty] = true;
      deals[_dealNumber].parties.push(_newParty);
      emit PartyAdded(_dealNumber, _newParty);
      return (true);
  }
}
