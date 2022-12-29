// SPDX-License-Identifier: MIT
// FOR DEMONSTRATION ONLY, unaudited, not recommended to be used for any purpose, carries absolutely no warranty of any kind
/// @dev allows a contract owner to set access permission for other addresses without revealing those addresses until they access by passing a secret
/// mappings are public so other contracts can access getters

pragma solidity ^0.8.4;

contract AccessByHash {
    address public immutable owner;

    mapping(address => bool) public accessed; // whether an address has matched an owner-provided hash and accessed
    mapping(bytes32 => bool) public permitted; // hash to permission

    error NotOwner();
    error NotPermitted();

    event HashChanged(bytes32 hash, bool status);

    constructor() payable {
        owner = msg.sender;
    }

    /// @notice owner can update hash info to permitted or not permitted. _infoHash should equal the keccak256(abi.encodePacked(address, salt)),
    /// where address = user's address and salt is random bytes given offchain to the user as a secret
    /// @param _infoHash access key hash; added for each new permitted member without passing address
    /// @param _status status of hash: true = permitted, false = revoked/not permitted
    function updateHashStatus(bytes32 _infoHash, bool _status) external {
        if (msg.sender != owner) revert NotOwner();
        permitted[_infoHash] = _status;

        emit HashChanged(_infoHash, _status);
    }

    /// @notice user passes their secret in order to change access mapping
    /// @param _salt: secret that must be passed for an access token; avoids simple access by calling without params if an account is compromised
    function access(bytes calldata _salt) external {
        if (!permitted[keccak256(abi.encodePacked(msg.sender, _salt))])
            revert NotPermitted();

        accessed[msg.sender] = true;
    }
}
