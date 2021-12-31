// SPDX-License-Identifier: MIT
// FOR DEMONSTRATION ONLY, unaudited, not recommended to be used for any purpose, carries absolutely no warranty of any kind
/// @dev ERC20 holder-gated access to an IPFS link 
// future features could include other token standards, threshold amounts, privacy solutions, staked tokens (to permit governance staker-gated access), accessing something other than a string (since mintgate addresses gated links)

pragma solidity ^0.8.6;

interface IERC20 { 
    function balanceOf(address account) external view returns (uint256); 
}

contract AccessByERC20 {

    address owner;
    string private IPFShash;
    IERC20 public ierc20; 
    mapping(address => uint256) tokenBalance;
    
    event HashChanged();
    
    /// @notice deployer sets token address necessary to access IPFS info
    /// @param _token: token address for ERC20 used to gate access
    constructor(address _token) { 
        ierc20 = IERC20(_token);
        owner = msg.sender;
    }
    
    // owner sets IPFS hash (and is able to update/change it)
    // @param _IPFShash: IPFS hash of information to be revealed only to ERC20 holder
    function setIPFShash(string calldata _IPFShash) external {
        require(msg.sender == owner, "Only_Owner");
        IPFShash = _IPFShash;
        emit HashChanged();
    }
    
    //check msg.sender's token balance and assign mapping in order to accessLink()
    function setBalance() external {
        tokenBalance[msg.sender] = ierc20.balanceOf(msg.sender);
    }
    
    function accessLink() external view returns(string memory) {
        require(tokenBalance[msg.sender] > 0, "Only_Tokenholders. Call setBalance() first.");
        return(IPFShash);
    } 
}
