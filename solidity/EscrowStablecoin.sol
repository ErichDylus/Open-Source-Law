//SPDX-License-Identifier: MIT

pragma solidity >=0.8.12;

/// unaudited and for demonstration only, provided as-is without any guarantees or warranties
/// @title Stablecoin Escrow
/// @notice bilateral smart escrow contract, with an ERC20 stablecoin as payment, expiration denominated in seconds, deposit refunded if contract expires before closeDeal() called
/// @dev intended to be deployed by buyer - may be altered for separation of deposit from purchase price, deposit non-refundability, different token standard, additional conditions, etc.

/// @notice Solbase SafeTransferLib's 'SafeTransfer()' and 'SafeTransferFrom()'
/// @author Solbase (https://github.com/Sol-DAO/solbase/blob/main/src/utils/SafeTransferLib.sol)
library SafeTransferLib {
    /// @dev The ERC20 `transfer` has failed.
    error TransferFailed();

    /// @dev The ERC20 `transferFrom` has failed.
    error TransferFromFailed();

    /// @dev Sends `amount` of ERC20 `token` from the current contract to `to`.
    /// Reverts upon failure.
    function safeTransfer(
        address token,
        address to,
        uint256 amount
    ) internal {
        /// @solidity memory-safe-assembly
        assembly {
            // We'll write our calldata to this slot below, but restore it later.
            let memPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(0x00, 0xa9059cbb)
            mstore(0x20, to) // Append the "to" argument.
            mstore(0x40, amount) // Append the "amount" argument.

            if iszero(
                and(
                    // Set success to whether the call reverted, if not we check it either
                    // returned exactly 1 (can't just be non-zero data), or had no return data.
                    or(eq(mload(0x00), 1), iszero(returndatasize())),
                    // We use 0x44 because that's the total length of our calldata (0x04 + 0x20 * 2)
                    // Counterintuitively, this call() must be positioned after the or() in the
                    // surrounding and() because and() evaluates its arguments from right to left.
                    call(gas(), token, 0, 0x1c, 0x44, 0x00, 0x20)
                )
            ) {
                // Store the function selector of `TransferFailed()`.
                mstore(0x00, 0x90b8ec18)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }

            mstore(0x40, memPointer) // Restore the memPointer.
        }
    }

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

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract EscrowStablecoin {
    using SafeTransferLib for address;

    address public immutable buyer;
    address public seller;
    address public immutable stablecoin;

    uint256 public immutable price;
    uint256 public immutable expirationTime;

    bool public sellerApproved;
    bool public buyerApproved;
    bool public isExpired;

    string public description;

    event DealExpired();
    event DealClosed(uint256 effectiveTime); //event provides exact blockstamp Unix time of closing
    event DepositReturned();
    event SellerUpdated(address newSeller);

    error BuyerAddrSameAsSellerAddr();
    error Expired();
    error NotBuyer();
    error NotReadyToClose();
    error NotSeller();
    error PriceAlreadyInEscrow();

    /// @notice deployer (buyer) initiates escrow with description, price in tokens, address of stablecoin, seconds until expiry, and designate recipient seller
    /// @param _description: brief identifier of the deal in question - perhaps as to parties/underlying asset/documentation reference/hash
    /// @param _price: purchase price number of tokens which will be deposited in the smart escrow contract
    /// @param _secsUntilExpiration: number of seconds until the deal expires. input type(uint256).max for no expiry
    /// @param _seller: the seller's address, recipient of the purchase price if the deal closes
    /// @param _stablecoin: token contract address of the stablecoin to be used in this transaction
    constructor(
        string memory _description,
        uint256 _price,
        uint256 _secsUntilExpiration,
        address _seller,
        address _stablecoin
    ) payable {
        buyer = msg.sender;
        price = _price;
        stablecoin = _stablecoin;
        description = _description;
        seller = _seller;
        expirationTime = block.timestamp + _secsUntilExpiration;
    }

    /// @notice for the current seller to designate a new recipient address
    /// @param _seller: new recipient address of seller
    function updateSeller(address _seller) external {
        if (msg.sender != seller) revert NotSeller();
        if (_seller == buyer) revert BuyerAddrSameAsSellerAddr();
        if (isExpired) revert Expired();

        seller = _seller;

        emit SellerUpdated(_seller);
    }

    /** @notice buyer call this function to deposit 'price' in address(this) *** after separately ERC20-approving address(this) for price***
     *** OR anyone (for example a different buyer address) can directly transfer 'price' to address(this) **/
    function depositInEscrow() external {
        if (msg.sender != buyer) revert NotBuyer();
        if (checkEscrow() >= price) revert PriceAlreadyInEscrow();

        stablecoin.safeTransferFrom(buyer, address(this), price);
    }

    /// @notice check if expired, and if expired, return balance to buyer
    function checkIfExpired() external returns (bool) {
        if (expirationTime <= block.timestamp) {
            isExpired = true;
            _returnDeposit();

            emit DealExpired();
        }
        return (isExpired);
    }

    /// @notice seller and buyer each call this when ready to close; returns approval status of each party
    function readyToClose() external returns (bool, bool) {
        if (msg.sender == seller) sellerApproved = true;
        else if (msg.sender == buyer) buyerApproved = true;

        return (sellerApproved, buyerApproved);
    }

    /** @notice callable by any external address: checks if both buyer and seller are ready to close and expiration has not been met;
     *** if so, this contract closes deal and pays seller; if not, price deposit returned to buyer **/
    /// @dev if properly closes, pays seller and emits event with effective time of closing
    function closeDeal() external {
        if (!sellerApproved || !buyerApproved) revert NotReadyToClose();

        // delete approvals to prevent re-entrance
        delete sellerApproved;
        delete buyerApproved;

        if (expirationTime < block.timestamp) {
            isExpired = true;
            _returnDeposit();

            emit DealExpired();
        } else {
            stablecoin.safeTransfer(seller, price);

            // effective time of closing is block.timestamp upon payment to seller
            emit DealClosed(block.timestamp);
        }
    }

    /// @notice checks address(this)'s balance to see if 'price' is in escrow
    function checkEscrow() public view returns (uint256) {
        return IERC20(stablecoin).balanceOf(address(this));
    }

    /// @notice returns price deposit to buyer
    function _returnDeposit() internal {
        stablecoin.safeTransfer(buyer, price);

        emit DepositReturned();
    }
}
