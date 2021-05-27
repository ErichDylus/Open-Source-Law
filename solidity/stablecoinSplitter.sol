// SPDX-License-Identifier: MIT
// ******** IN PROCESS ********

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol";

//FOR DEMONSTRATION ONLY, not recommended to be used for any purpose and carries no warranty of any kind
//@dev create a stablecoin splitter to avoid $10,000 reporting threshold other than initial transaction to splitterAddress
//consider wrapping splitterAddress in an on-chain LLC (perhaps series/Ricardian, see: https://github.com/lexDAO/Ricardian/blob/main/contracts/RicardianLLC.sol)

contract stableSplitter {
    
  //escrow struct to contain basic description of underlying asset/deal, purchase price, ultimate recipient of funds, whether complete, number of parties
  struct NewSplit {
      address stablecoin;
      uint256 amount;
      address payable recipient;
  }
  
  NewSplit[] public splits;
  address splitterAddress = address(this);
  address payable sender;
  address payable recipient; // ultimate destination for lump sump
  address stablecoin;
  uint256 amount;
  mapping(address => bool) registeredAddresses;
  
  event FundsSent();
  
  //restricts to owner or internal calls
  modifier restricted() {
    require(registeredAddresses[msg.sender] == true, "This may only be called by the owner or the splitter contract itself");
    _;
  }
  
  //sender inputs token address of stablecoin, lump sum amount, ultimate destination recipient address
  constructor(address _stablecoin, uint256 _amount, address payable _recipient) public payable {
      sender = msg.sender;
      amount = _amount;
      stablecoin = _stablecoin;
      recipient = _recipient;
      registeredAddresses[sender] = true;
      registeredAddresses[splitterAddress] = true;
      ERC20(stablecoin).approve(sender, amount); 
      ERC20(stablecoin).approve(splitterAddress, amount);
      ERC20(stablecoin).transferFrom(sender, splitterAddress, amount); // transfer lump sum from sender to splitter
  }
  
  //for a new transfer, owner may change recipient address and/or stablecoin address to use this splitter for different tokens
  function newTransfer(address _stablecoin, uint256 _amount, address payable _recipient) public restricted {
      stablecoin = _stablecoin;
      amount = _amount;
      recipient = _recipient;
      ERC20(stablecoin).approve(sender, amount); 
      ERC20(stablecoin).approve(splitterAddress, amount);
      NewSplit(_stablecoin, _amount, _recipient);
      emit FundsSent();
  }
  
  //a manual return mechanism in case contract runs out of gas, etc.
  function returnFunds() public payable restricted {
      ERC20(stablecoin).transferFrom(splitterAddress, sender, ERC20(stablecoin).balanceOf(splitterAddress));
      emit FundsSent();
  }
  
  //send funds in batches less than 10k until balance of splitterAddress is 0 
  function sendFunds() public payable restricted {
      // TODO: insert loop that transfers an amount less than 10000 to recipient until balance of splitterAddress is 0
      emit FundsSent();
  }
  
}
