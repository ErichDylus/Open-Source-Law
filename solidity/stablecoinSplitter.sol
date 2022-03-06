// SPDX-License-Identifier: MIT
// ******** IN PROCESS, FOR DEMONSTRATION ONLY, not recommended to be used for any purpose ********

pragma solidity >=0.8.0;

//not recommended to be used for any purpose (especially not structuring, twitter warriors) and carries absolutely no warranty of any kind
//@dev create an ERC20 stablecoin transfer splitter in amounts less than $10,000
//consider wrapping splitterAddress in an LLC or other vehicle for reporting purposes (perhaps series/Ricardian, see: https://github.com/lexDAO/Ricardian/blob/main/contracts/RicardianLLC.sol)
//future iterations may pseudo-randomly change amounts and timing

interface IERC20 { //https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/ERC20.sol
    function approve(address spender, uint256 amount) external returns (bool); 
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract stableSplitter {
  
  address sender;
  address recipient; 
  uint256 amount;
  uint256 batches;
  uint256 remainder;
  uint256 i;
  mapping(address => bool) whitelist;
  IERC20 public ierc20;
  
  event FundsSent();
  
  //restricts to owner or internal calls
  modifier restricted() {
    require(whitelist[msg.sender] == true, "ONLY_OWNER_OR_ADDRESS(THIS)");
    _;
  }
  
  //sender inputs ERC20 token address of stablecoin, total amount to be transferred in USD, recipient address
  //sender must separately (via _stablecoin's token contract) approve contract address for amount: approve(sender, amount)
  constructor(address _stablecoin, uint256 _amount, address payable _recipient) {
      sender = msg.sender;
      amount = _amount * 10e18; // assuming 18 decimals, this could be changed to a parameter or moved to front end
      ierc20 = IERC20(_stablecoin);
      recipient = _recipient;
      batches = (_amount / 10000) - 1; // batch amount can be altered, for example limiting how much is sent to any one address, randomness, etc.
      remainder = (_amount % 9999) * 10e18; // amount of tokens which will remain after batches of $9999 are sent
      i = 0;
      whitelist[sender] = true;
  }
  
  function sendFunds() public restricted returns(bool) {
      while (i < batches) {
        ierc20.transferFrom(sender, recipient, 9999*10e18); //send funds to recipient in batches less than $10,000
        unchecked { i++; } // will not overflow on human timeline/in while loop
        }
      ierc20.transferFrom(sender, recipient, remainder); 
      emit FundsSent();
      return(true);
  } 
  
  function viewDetails() public view restricted returns (uint256, uint256, uint256) {
      return (amount, batches, remainder);
  }
  
  //for a new transfer, owner may change recipient address and/or ERC20 stablecoin address to use this splitter for different tokens
  //sender must separately (via _stablecoin's token contract) approve contract address for new amount: approve(sender, _amount)
  function newTransfer(address _stablecoin, uint256 _amount, address payable _recipient) public restricted {
      ierc20 = IERC20(_stablecoin);
      amount = _amount * 10e18;
      batches = (_amount / 10000) - 1;
      recipient = _recipient;
      remainder = (_amount % 9999) * 10e18;
  }
} 
