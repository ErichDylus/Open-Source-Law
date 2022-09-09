//SPDX-License-Identifier: MIT

/// @dev convenience getter for function selector, for example to use with abi.encodeWithSelector

pragma solidity >=0.8.0;

contract FunctionSelector {
    constructor() {}

    /// @param _input the method call (function and any arguments, without spaces), for example "inputInfo(address,uint256)"
    /// @return bytes4 function selector
    function getSelector(string calldata _input)
        external
        pure
        returns (bytes4)
    {
        return (bytes4(keccak256(bytes(_input))));
    }
}
