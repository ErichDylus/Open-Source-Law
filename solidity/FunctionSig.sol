//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

contract FunctionSig {
    constructor() {}

    /// @param _input the method call (function and any arguments), note that remix requires encapsulating in quotes
    /// @return 4 byte function signature
    function seeHex(string calldata _input) external pure returns (bytes4) {
        return(bytes4(keccak256(bytes(_input))));
    }
}
