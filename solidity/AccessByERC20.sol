// SPDX-License-Identifier: MIT
// FOR DEMONSTRATION ONLY, unaudited, not recommended to be used for any purpose, carries absolutely no warranty of any kind
/// @dev ERC20 holder-gated access to hashed information
// future features could include other token standards such as NFTs, threshold amounts, privacy solutions, staked tokens (to permit governance staker-gated access), permit a function call instead of just view

pragma solidity ^0.8.6;

interface IERC20 { 
    function balanceOf(address account) external view returns (uint256); 
}

contract AccessByERC20 {

    address owner;
    string private infoHash; // this is not concealed, just unable to be changed by inheriting contracts
    IERC20 public ierc20; 
    
    error NotOwner();
    error NotTokenHolder();

    event HashChanged();
    
    /// @notice deployer sets token address necessary to access hash, and initial hash info
    /// @param _token token address for ERC20 used to gate access
    /// @param _infoHash hash of information to be revealed only to applicable token holder
    constructor(address _token, string memory _infoHash) { 
        ierc20 = IERC20(_token);
        infoHash = _infoHash;
        owner = msg.sender;
    }
    
    /// @notice owner can update hash info
    /// @param _infoHash hash of information to be revealed only to applicable token holder
    function setHash(string calldata _infoHash) external {
        if (msg.sender != owner) revert NotOwner();
        infoHash = _infoHash;
        emit HashChanged();
    }

    /// @notice check msg.sender's token balance and return hash if > 0 
    /// may introduce view threshold amount such as if (ierc20.balanceOf(msg.sender) <= _thresholdAmount), or permit a function call
    function accessHash() external view returns(string memory) {
        if (ierc20.balanceOf(msg.sender) == 0) revert NotTokenHolder();
        return(infoHash);
    } 
}
