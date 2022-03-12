//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

// unaudited and subject to all disclosures, licenses, and caveats set forth at https://github.com/ErichDylus/Open-Source-Law/blob/main/solidity/README.md
// interface to DealStamp.sol, to create an on-chain record of a deal's parties, decentralized doc storage ref (which would presumably carry an additional hash layer/other security mechanism for access), and time of closing

interface IDealStamp {

  function newDealStamp(string calldata docsLocationHash, uint256 effectiveTime, address party1, address party2) external returns (uint256);
  function addPartyToDeal(uint256 dealNumber, address newParty) external returns (bool);
  function viewDeal(uint256 dealNumber) external view returns (uint256, uint256, string memory, address[] memory);
  
}
