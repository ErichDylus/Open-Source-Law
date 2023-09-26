//SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

/// FOR DEMONSTRATION ONLY, unaudited, not recommended to be used for any purpose and provided with no warranty whatsoever, see https://github.com/ErichDylus/Open-Source-Law/blob/main/LICENSE

/// @notice Solbase / Solady's SafeTransferLib 'SafeTransferFrom()'.  Extracted from library and pasted for convenience, transparency, and size minimization.
/// @author Solbase / Solady (https://github.com/Sol-DAO/solbase/blob/main/src/utils/SafeTransferLib.sol / https://github.com/Vectorized/solady/blob/main/src/utils/SafeTransferLib.sol)
/// @dev implemented as abstract contract rather than library for size/gas reasons
abstract contract SafeTransferLib {
    /// @dev The ERC20 `transferFrom` has failed.
    error TransferFromFailed();

    /// @dev Sends `amount` of ERC20 `token` from `from` to `to`.
    /// Reverts upon failure.
    ///
    /// The `from` account must have at least `amount` approved for
    /// the current contract to manage.
    function safeTransferFrom(
        address token,
        address from,
        address to,
        uint256 amount
    ) internal {
        /// @solidity memory-safe-assembly
        assembly {
            // We'll write our calldata to this slot below, but restore it later.
            let memPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(0x00, 0x23b872dd)
            mstore(0x20, from) // Append the "from" argument.
            mstore(0x40, to) // Append the "to" argument.
            mstore(0x60, amount) // Append the "amount" argument.

            if iszero(
                and(
                    // Set success to whether the call reverted, if not we check it either
                    // returned exactly 1 (can't just be non-zero data), or had no return data.
                    or(eq(mload(0x00), 1), iszero(returndatasize())),
                    // We use 0x64 because that's the total length of our calldata (0x04 + 0x20 * 3)
                    // Counterintuitively, this call() must be positioned after the or() in the
                    // surrounding and() because and() evaluates its arguments from right to left.
                    call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
                )
            ) {
                // Store the function selector of `TransferFromFailed()`.
                mstore(0x00, 0x7939f424)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            mstore(0x60, 0) // Restore the zero slot to zero.
            mstore(0x40, memPointer) // Restore the memPointer.
        }
    }
}

interface IERC20Permit {
    function decimals() external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

/// @notice non-custodial tax withholding contract for ERC20 tokens to separate withheld estimated tax, etc.; contingent on factors such as jurisdiction and status of each msg.sender, but initially whole-number flat rate for demonstration
/// @dev address(this) never receives tokens, but is programmatically enabled to safeTransferFrom the msg.sender to the designated 'taxAddress' (which can in practice be a separated wallet for account or a tax authority's recipient wallet)
contract TaxWithholding is SafeTransferLib {
    uint256 constant DECIMALS = 18;

    address public immutable taxAddress;
    uint256 public immutable taxRate;

    // numbered tax withholding for each msg.sender
    mapping(address => uint256) public taxWithholdingNumber;
    // tax amount for a given msg.sender's taxWithholdingNumber
    mapping(uint256 => mapping(address => uint256))
        public withholdingNumberToAmount;

    error InvalidRate();

    event TaxWithheld(
        address indexed payor,
        uint256 indexed withholdingNumber,
        uint256 time,
        uint256 amount,
        address tokenContract
    );

    /// @param _taxAddress designated recipient address to receive withheld amount
    /// @param _taxRate using 18 decimals for calculations, percentage tax rate as a nonzero uint < 1e18 (which corresponds to 100%). Ex., 1e16 == 1%, 1e17 == 10%, etc.
    constructor(address _taxAddress, uint256 _taxRate) payable {
        if (_taxRate == 0 || _taxRate >= DECIMALS) revert InvalidRate();
        taxAddress = _taxAddress;
        taxRate = _taxRate;
    }

    /// @dev msg.sender must first separately approve address(this) for _tokenAddress for at least _taxes amount so it may initiate the safeTransferFrom to the 'taxAddress'
    /// @param _income gross amount by msg.sender in the applicable token corresponding to _tokenAddress
    /// @param _tokenAddress contract address of ERC20 token received
    /// @return taxes paid, tax withholding number for this msg.sender
    function payTax(
        uint256 _income,
        address _tokenAddress
    ) external returns (uint256, uint256) {
        uint256 _taxes = (_income * taxRate) / DECIMALS;
        // adjust for decimal amount other than 18
        uint256 _decimals = IERC20Permit(_tokenAddress).decimals();
        // if more than 18 decimals, divide the total amount by the excess decimal places; subtraction will not underflow due to condition check
        if (_decimals > DECIMALS) {
            unchecked {
                _taxes = (_taxes / 10 ** (_decimals - 18));
            }
        }
        // if less than 18 decimals, multiple the total amount by the difference in decimal places
        else if (_decimals < DECIMALS) {
            _taxes = _taxes * (10 ** (18 - _decimals));
        }

        unchecked {
            ++taxWithholdingNumber[msg.sender]; // will not overflow on human timelines
        }
        uint256 _number = taxWithholdingNumber[msg.sender];
        withholdingNumberToAmount[_number][msg.sender] = _taxes;

        safeTransferFrom(_tokenAddress, msg.sender, taxAddress, _taxes);

        emit TaxWithheld(
            msg.sender,
            _number,
            block.timestamp,
            _taxes,
            _tokenAddress
        );

        return (_taxes, _number);
    }

    /// @notice tax withholding via EIP712 permit for compliant tokens
    /// @param _income gross amount by msg.sender in the applicable token corresponding to _tokenAddress
    /// @param _deadline: deadline for permit approval usage
    /// @param _tokenAddress contract address of ERC20 token received
    /// @param _v: ECDSA sig param
    /// @param _r: ECDSA sig param
    /// @param _s: ECDSA sig param
    /// @return taxes paid, tax withholding number for this msg.sender
    function payTaxViaPermit(
        uint256 _income,
        uint256 _deadline,
        address _tokenAddress,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external returns (uint256, uint256) {
        uint256 _taxes = (_income * taxRate) / DECIMALS;
        // adjust for decimal amount other than 18
        uint256 _decimals = IERC20Permit(_tokenAddress).decimals();
        // if more than 18 decimals, divide the total amount by the excess decimal places; subtraction will not underflow due to condition check
        if (_decimals > DECIMALS) {
            unchecked {
                _taxes = (_taxes / 10 ** (_decimals - 18));
            }
        }
        // if less than 18 decimals, multiple the total amount by the difference in decimal places
        else if (_decimals < DECIMALS) {
            _taxes = _taxes * (10 ** (18 - _decimals));
        }

        unchecked {
            ++taxWithholdingNumber[msg.sender]; // will not overflow on human timelines
        }
        uint256 _number = taxWithholdingNumber[msg.sender];
        withholdingNumberToAmount[_number][msg.sender] = _taxes;

        IERC20Permit(_tokenAddress).permit(
            msg.sender,
            address(this),
            _taxes,
            _deadline,
            _v,
            _r,
            _s
        );

        safeTransferFrom(_tokenAddress, msg.sender, taxAddress, _taxes);

        emit TaxWithheld(
            msg.sender,
            _number,
            block.timestamp,
            _taxes,
            _tokenAddress
        );

        return (_taxes, _number);
    }
}
