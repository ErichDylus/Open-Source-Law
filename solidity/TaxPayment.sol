//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

/// FOR DEMONSTRATION ONLY, incomplete, unaudited, not recommended to be used for any purpose and
/// provided with no warranty whatsoever, see https://github.com/ErichDylus/Open-Source-Law/blob/main/LICENSE
/// @notice simple tax remitting contract to give IRS estimated tax, etc.; sends to immutable IRS wallet address

// SolDAO SafeTransferLib, https://github.com/Sol-DAO/solbase/blob/main/src/utils/SafeTransferLib.sol
import {SafeTransferLib} from "lib/SafeTransferLib.sol";

interface IERC20Permit {
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    // DAI pattern permit
    function permit(
        address holder,
        address spender,
        uint256 nonce,
        uint256 expiry,
        bool allowed,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

/// @notice contingent on factors such as jurisdiction and status of each msg.sender, but initially whole-number flat rate federal tax demonstration
/// @dev could be used directly via EOA, or as an add-on to another contract which results in income taxable event when a dApp makes a transaction
contract TaxPayment {
    using SafeTransferLib for address;

    /// @dev Ethereum mainnet DAI address
    address internal constant DAI_ADDR =
        0x6B175474E89094C44Da98b954EedeAC495271d0F;
    uint256 internal constant DECIMALS = 1e18;

    address payable public immutable irsAddress;
    uint256 public immutable taxRate;

    // numbered tax payment for each msg.sender
    mapping(address => uint256) public taxPaymentNumber;
    // tax amount for a given msg.sender's taxPaymentNumber
    mapping(uint256 => mapping(address => uint256))
        public taxPaymentNumberAmount;

    error InvalidRate();

    event TaxPaid(
        address indexed taxpayer,
        uint256 indexed taxPaymentNumber,
        uint256 timeOfPayment,
        uint256 taxPaymentAmount,
        address tokenContract
    );

    /// @param _irsAddress IRS's designated address to receive taxes
    /// @param _taxRate percentage tax rate as a nonzero uint < 1e18 (which corresponds to 100%). Ex., 1e16 == 1%, 1e17 == 10%, etc.
    constructor(address payable _irsAddress, uint256 _taxRate) payable {
        if (_taxRate == 0 || _taxRate >= DECIMALS) revert InvalidRate();
        irsAddress = _irsAddress;
        taxRate = _taxRate;
    }

    /// @notice msg.sender must first separately approve address(this) for _tokenAddress for at least _taxes amount
    /// @param _income received income amount by msg.sender in the applicable token corresponding to _tokenAddress, assuming 18 decimals
    /// @param _tokenAddress contract address of ERC20 token received
    /// @return taxes paid, tax payment number for this msg.sender
    function payTax(uint256 _income, address _tokenAddress)
        external
        returns (uint256, uint256)
    {
        uint256 _taxes = (_income * taxRate) / DECIMALS;

        unchecked {
            ++taxPaymentNumber[msg.sender]; // will not overflow on human timelines
        }
        uint256 _paymentNumber = taxPaymentNumber[msg.sender];
        taxPaymentNumberAmount[_paymentNumber][msg.sender] = _taxes;

        _tokenAddress.safeTransferFrom(msg.sender, irsAddress, _taxes);

        emit TaxPaid(
            msg.sender,
            _paymentNumber,
            block.timestamp,
            _taxes,
            _tokenAddress
        );

        return (_taxes, _paymentNumber);
    }

    /// @notice tax payment via EIP712 permit for compliant tokens
    /// @param _income received income amount by msg.sender in the applicable token corresponding to _tokenAddress, assuming 18 decimals
    /// @param _nonce: user's nonce on the erc20 contract, for replay protection
    /// @param _deadline: deadline for permit approval usage
    /// @param _tokenAddress contract address of ERC20 token received
    /// @param _v: ECDSA sig param
    /// @param _r: ECDSA sig param
    /// @param _s: ECDSA sig param
    /// @return taxes paid, tax payment number for this msg.sender
    function payTaxViaPermit(
        uint256 _income,
        uint256 _nonce,
        uint256 _deadline,
        address _tokenAddress,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external returns (uint256, uint256) {
        uint256 _taxes = (_income * taxRate) / DECIMALS;

        if (_tokenAddress == DAI_ADDR) {
            IERC20Permit(_tokenAddress).permit(
                msg.sender,
                irsAddress,
                _nonce,
                _deadline,
                true,
                _v,
                _r,
                _s
            );
        } else {
            IERC20Permit(_tokenAddress).permit(
                msg.sender,
                irsAddress,
                _taxes,
                _deadline,
                _v,
                _r,
                _s
            );
        }

        unchecked {
            ++taxPaymentNumber[msg.sender]; // will not overflow on human timelines
        }
        uint256 _paymentNumber = taxPaymentNumber[msg.sender];
        taxPaymentNumberAmount[_paymentNumber][msg.sender] = _taxes;

        _tokenAddress.safeTransferFrom(msg.sender, irsAddress, _taxes);

        emit TaxPaid(
            msg.sender,
            _paymentNumber,
            block.timestamp,
            _taxes,
            _tokenAddress
        );

        return (_taxes, _paymentNumber);
    }
}
