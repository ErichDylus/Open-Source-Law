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
    string IPFSlink;
    ERC20 public erc20; 
    mapping(address => uint256) tokenBalance;
    
    event LinkChanged();
    
    // deployer sets token address necessary to access link
    constructor(address _token) { 
        token = _token;
        erc20 = ERC20(token);
        owner = msg.sender;
    }
    
    // owner sets IPFS link (and is able to update/change it)
    function setIPFSLink(string memory _IPFSlink) external {
        require(msg.sender == owner, "Not authorized to change IPFS link.");
        IPFSlink = _IPFSlink;
        emit LinkChanged();
    }
    
    //check msg.sender's token balance and assign mapping in order to accessLink()
    function setBalance() external {
        uint256 _balance = _checkBalance(msg.sender);
        tokenBalance[msg.sender] = _balance;
    }
    
    function _checkBalance(address _caller) internal view returns(uint256) {
        return(erc20.balanceOf(_caller));
    }
    
    function accessLink() external view returns(string memory) {
        require(tokenBalance[msg.sender] > 0, "Only tokenholders may access the link. Call setBalance() before trying to access.");
        return(IPFSlink);
    } 
}
