// SPDX-License-Identifier: MIT
// ******** IN PROCESS ********

pragma solidity ^0.6.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol";

//FOR DEMONSTRATION ONLY, not recommended to be used for any purpose and carries no warranty of any kind
//@dev create a stablecoin splitter to avoid $10,000 reporting threshold other than initial transaction to splitterAddress
//consider wrapping splitterAddress in an on-chain LLC or other vehicle for reporting purposes (perhaps series/Ricardian, see: https://github.com/lexDAO/Ricardian/blob/main/contracts/RicardianLLC.sol)
// TODO: implement ERC20 interface

contract stableSplitter {
  
  address splitterAddress = address(this);
  address payable sender;
  address payable recipient; // ultimate destination for lump sump
  address stablecoin;
  uint256 amount;
  uint256 batches;
  mapping(address => bool) whitelist;
  
  event FundsSent();
  
  //restricts to owner or internal calls
  modifier restricted() {
    require(whitelist[msg.sender] == true, "This may only be called by the owner or the splitter contract itself");
    _;
  }
  
  //sender inputs token address of stablecoin, lump sum amount, ultimate destination recipient address
  constructor(address _stablecoin, uint256 _amount, address payable _recipient) public payable {
      sender = msg.sender;
      amount = _amount * 10e18;
      stablecoin = _stablecoin;
      recipient = _recipient;
      batches = _amount * 10e14;
      whitelist[sender] = true;
      whitelist[splitterAddress] = true;
      ERC20(stablecoin).approve(sender, amount); 
      ERC20(stablecoin).approve(splitterAddress, amount);
      ERC20(stablecoin).transferFrom(sender, splitterAddress, amount); // transfer lump sum from sender to splitter
      sendFunds();
  }
  
  //for a new transfer, owner may change recipient address and/or stablecoin address to use this splitter for different tokens
  function newTransfer(address _stablecoin, uint256 _amount, address payable _recipient) public restricted {
      stablecoin = _stablecoin;
      amount = _amount * 10e18;
      recipient = _recipient;
      ERC20(stablecoin).approve(sender, amount); 
      ERC20(stablecoin).approve(splitterAddress, amount);
      ERC20(stablecoin).transferFrom(sender, splitterAddress, amount);
      sendFunds();
  }
  
  // manual return mechanism in case of error
  function returnFunds() public restricted {
      ERC20(stablecoin).transferFrom(splitterAddress, sender, ERC20(stablecoin).balanceOf(splitterAddress));
  }
  
  //send funds to recipient in batches less than 10,000 until balance of splitterAddress is 0 
  function sendFunds() private restricted {
      // transfer in batches less than 10000 to recipient until balance of splitterAddress is 0
      for (uint256 i = 0; i < batches; i++) {
            if (ERC20(stablecoin).balanceOf(splitterAddress) >= 10000) {
                ERC20(stablecoin).transferFrom(splitterAddress, recipient, 9999);
                continue;
            }
            else if (ERC20(stablecoin).balanceOf(splitterAddress) >= 10000 && ERC20(stablecoin).balanceOf(splitterAddress) > 0) {
                ERC20(stablecoin).transferFrom(splitterAddress, recipient, ERC20(stablecoin).balanceOf(splitterAddress));
                break;
            }
            else { break; }
        }
      emit FundsSent();
  } 
}
