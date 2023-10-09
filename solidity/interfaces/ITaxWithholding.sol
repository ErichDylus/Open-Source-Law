// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

// unaudited and subject to all disclosures, licenses, and caveats set forth at https://github.com/ErichDylus/Open-Source-Law/blob/main/solidity/README.md

interface ITaxWithholding {
    /// @dev msg.sender must first separately approve the TaxWitholding contract address for _tokenAddress for at least _taxes amount so it may initiate the safeTransferFrom to the 'taxAddress'
    /// @param _amount gross amount by msg.sender in the applicable token corresponding to _tokenAddress
    /// @param _tokenAddress contract address of ERC20 token received
    /// @return taxes paid, tax withholding number for this msg.sender
    function payTax(
        uint256 _amount,
        address _tokenAddress
    ) external returns (uint256, uint256);

    /// @notice tax withholding via EIP712 permit for compliant tokens
    /// @param _amount gross amount by msg.sender in the applicable token corresponding to _tokenAddress
    /// @param _deadline: deadline for permit approval usage
    /// @param _tokenAddress contract address of ERC20 token received
    /// @param _v: ECDSA sig param
    /// @param _r: ECDSA sig param
    /// @param _s: ECDSA sig param
    /// @return taxes paid, tax withholding number for this msg.sender
    function payTaxViaPermit(
        uint256 _amount,
        uint256 _deadline,
        address _tokenAddress,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external returns (uint256, uint256);
}
