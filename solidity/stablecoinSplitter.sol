// SPDX-License-Identifier: MIT
// ******** IN PROCESS ********
// TODO: check math, sendFunds() still failing

pragma solidity ^0.6.0;

//FOR DEMONSTRATION ONLY, not recommended to be used for any purpose and carries no warranty of any kind
//@dev create an ERC20 stablecoin splitter to avoid $10,000 reporting threshold other than initial transaction to splitterAddress
//consider wrapping splitterAddress in an on-chain LLC or other vehicle for reporting purposes (perhaps series/Ricardian, see: https://github.com/lexDAO/Ricardian/blob/main/contracts/RicardianLLC.sol)

interface ERC20 { //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol
    function approve(address spender, uint256 amount) external returns (bool); 
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract stableSplitter {
  
  address splitterAddress = address(this);
  address payable sender;
  address payable recipient; // ultimate destination for lump sump
  address stablecoin;
  uint256 amount;
  uint256 batches;
  mapping(address => bool) whitelist;
  ERC20 public erc20;
  
  event FundsSent();
  
  //restricts to owner or internal calls
  modifier restricted() {
    require(whitelist[msg.sender] == true, "This may only be called by the owner or the splitter contract itself");
    _;
  }
  
  //sender inputs ERC20 token address of stablecoin, lump sum amount, ultimate destination recipient address
  constructor(address _stablecoin, uint256 _amount, address payable _recipient) public payable {
      sender = msg.sender;
      amount = _amount * 10e18;
      stablecoin = _stablecoin;
      erc20 = ERC20(stablecoin);
      recipient = _recipient;
      batches = amount / 10e22;
      whitelist[sender] = true;
      whitelist[splitterAddress] = true;
      erc20.approve(sender, amount); 
      erc20.approve(splitterAddress, amount);
  }
  
  // manual return mechanism in case of error
  function returnFunds() public restricted {
      erc20.transferFrom(splitterAddress, sender, erc20.balanceOf(splitterAddress));
  }
  
  function sendFunds() public restricted {
      erc20.transferFrom(sender, splitterAddress, amount); // transfer lump sum from sender to splitter
      for (uint256 i = 0; i < batches; i++) { //send funds to recipient in batches less than 10,000 to recipient until balance of splitterAddress is 0
            if (erc20.balanceOf(splitterAddress) >= 10e22) {
                erc20.transferFrom(splitterAddress, recipient, 9999*10e18);
            }
            else if (erc20.balanceOf(splitterAddress) < 10e22 && erc20.balanceOf(splitterAddress) > 0) {
                erc20.transferFrom(splitterAddress, recipient, erc20.balanceOf(splitterAddress));
            }
            else { break; }
        }
      emit FundsSent();
  } 
  
  //for a new transfer, owner may change recipient address and/or ERC20 stablecoin address to use this splitter for different tokens
  function newTransfer(address _stablecoin, uint256 _amount, address payable _recipient) public restricted {
      stablecoin = _stablecoin;
      erc20 = ERC20(stablecoin);
      amount = _amount * 10e18;
      batches = amount / 10e22;
      recipient = _recipient;
  }
}
