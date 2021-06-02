// SPDX-License-Identifier: MIT
// ******** IN PROCESS ********

pragma solidity ^0.6.0;

//FOR DEMONSTRATION ONLY, not recommended to be used for any purpose and carries absolutely no warranty of any kind
//@dev create an ERC20 stablecoin transfer splitter in amounts less than $10,000 

interface ERC20 { //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol
    function approve(address spender, uint256 amount) external returns (bool); 
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract stableSplitter {
  
  address payable sender;
  address payable recipient; 
  address stablecoin; // ERC20 stablecoin token address
  uint256 amount;
  uint256 batches;
  uint256 remainder;
  uint256 i;
  mapping(address => bool) whitelist;
  ERC20 public erc20;
  
  event FundsSent();
  
  //restricts to owner or internal calls
  modifier restricted() {
    require(whitelist[msg.sender] == true, "This may only be called by the owner or the splitter contract itself");
    _;
  }
  
  //sender inputs ERC20 token address of stablecoin, total amount to be transferred in USD, recipient address
  constructor(address _stablecoin, uint256 _amount, address payable _recipient) public payable {
      require(msg.value > 0, "Need some gas for execution"); // send some gwei to pay for splitting function
      sender = msg.sender;
      amount = _amount * 10e18;
      stablecoin = _stablecoin;
      erc20 = ERC20(stablecoin);
      recipient = _recipient;
      batches = (_amount / 10000) - 1; 
      remainder = (_amount % 9999) * 10e18; // amount of tokens which will remain after batches of $9999 are sent
      i = 0;
      whitelist[sender] = true;
      erc20.approve(sender, amount); 
  }
  
  function sendFunds() public restricted {
      while (i < batches) {
        erc20.transferFrom(sender, recipient, 9999*10e18); //send funds to recipient in batches less than $10,000
        i++;
        }
      erc20.transferFrom(sender, recipient, remainder); 
      emit FundsSent();
  } 
  
  function viewDetails() public view restricted returns (uint256, uint256, uint256) {
      return (amount, batches, remainder);
  }
  
  //for a new transfer, owner may change recipient address and/or ERC20 stablecoin address to use this splitter for different tokens
  function newTransfer(address _stablecoin, uint256 _amount, address payable _recipient) public restricted {
      stablecoin = _stablecoin;
      erc20 = ERC20(stablecoin);
      amount = _amount * 10e18;
      batches = _amount / 10000;
      recipient = _recipient;
      remainder = (_amount % 9999) * 10e18;
      erc20.approve(sender, amount); 
  }
} 

/***** version which contemplates an initial lump sum to contract address, which then sends split amounts
//consider wrapping splitterAddress in an LLC or other vehicle for reporting purposes (perhaps series/Ricardian, see: https://github.com/lexDAO/Ricardian/blob/main/contracts/RicardianLLC.sol)

contract stableSplitter {
  
  address splitterAddress = address(this);
  address payable sender;
  address payable recipient; // ultimate destination for lump sum
  address stablecoin; // ERC20 stablecoin token address
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
      require(msg.value > 0, "Need some gas for execution"); // send some gas along with constructor to pay for splitting function
      sender = msg.sender;
      amount = _amount * 10e18;
      stablecoin = _stablecoin;
      erc20 = ERC20(stablecoin);
      recipient = _recipient;
      batches = _amount / 10000; // batches of 10000
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
      for (uint16 i = 0; i < batches; i++) { //send funds to recipient in batches less than 10,000 to recipient until balance of splitterAddress is 0
            if (erc20.balanceOf(splitterAddress) >= 10e22) {
                erc20.transferFrom(splitterAddress, recipient, 9999*10e18);
            }
            else { erc20.transferFrom(splitterAddress, recipient, erc20.balanceOf(splitterAddress)); }
        }
      emit FundsSent();
  } 
  
  //for a new transfer, owner may change recipient address and/or ERC20 stablecoin address to use this splitter for different tokens
  function newTransfer(address _stablecoin, uint256 _amount, address payable _recipient) public restricted {
      stablecoin = _stablecoin;
      erc20 = ERC20(stablecoin);
      amount = _amount * 10e18;
      batches = _amount / 10000;
      recipient = _recipient;
      erc20.approve(sender, amount); 
      erc20.approve(splitterAddress, amount);
  }
} *****/
