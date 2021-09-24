// SPDX-License-Identifier: MIT
// FOR DEMONSTRATION ONLY, unaudited, not recommended to be used for any purpose, carries absolutely no warranty of any kind
// @dev ERC20 holder-gated access to an IPFS link 
// future features could include other token standards, threshold amounts, privacy solutions, staked tokens (to permit governance staker-gated access), accessing something other than a string (since mintgate addresses gated links)

pragma solidity ^0.8.6;

interface ERC20 { 
    function balanceOf(address account) external view returns (uint256); 
}

contract AccessByERC20 {

    address token;
    address owner;
    string IPFShash;
    ERC20 public ierc20; 
    mapping(address => uint256) tokenBalance;
    
    event HashChanged();
    
    // deployer sets token address necessary to access IPFS info
    // @param _token: token address for ERC20 used to gate access
    constructor(address _token) { 
        token = _token;
        ierc20 = ERC20(token);
        owner = msg.sender;
    }
    
    // owner sets IPFS hash (and is able to update/change it)
    // @param _IPFShash: IPFS hash of information to be revealed only to ERC20 holder
    function setIPFShash(string memory _IPFShash) external {
        require(msg.sender == owner, "Not authorized to change IPFS hash.");
        IPFShash = _IPFShash;
        emit HashChanged();
    }
    
    //check msg.sender's token balance and assign mapping in order to accessLink()
    function setBalance() external {
        uint256 _balance = _checkBalance(msg.sender);
        tokenBalance[msg.sender] = _balance;
    }
    
    function _checkBalance(address _caller) internal view returns(uint256) {
        return(ierc20.balanceOf(_caller));
    }
    
    function accessLink() external view returns(string memory) {
        require(tokenBalance[msg.sender] > 0, "Only tokenholders may access. Call setBalance() before trying to access.");
        return(IPFShash);
    } 
}
