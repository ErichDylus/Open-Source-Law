// SPDX-License-Identifier: MIT
// FOR DEMONSTRATION ONLY, unaudited, not recommended to be used for any purpose, carries absolutely no warranty of any kind
// @dev ERC20 holder-gated access to an IPFS link, for example a governance "stake token"
// future features could include other token standards (such as NFTs), threshold amounts, privacy solutions, staked tokens (to permit governance staker-gated access), accessing something other than a string (since mintgate addresses gated links)

pragma solidity ^0.8.6;

interface ERC20 { 
    function balanceOf(address account) external view returns (uint256); 
}

contract AccessByERC20 {

    address token;
    address owner;
    string IPFShash;
    ERC20 public ierc20; 
    
    event IPFSChanged();
    
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
        emit IPFSChanged();
    }
    
    function accessIPFShash() external view returns(string memory) {
        require(ierc20.balanceOf(msg.sender) > 0, "Only tokenholders may access.");
        return(IPFShash);
    } 
}
