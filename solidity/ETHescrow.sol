//SPDX-License-Identifier: MIT

pragma solidity >=0.8.12;

/// unaudited and for demonstration only, provided as-is without any guarantees or warranties
/// @title ETH Escrow
/// @notice bilateral smart escrow contract, with ETH as payment, expiration denominated in seconds, deposit refunded if contract expires before closeDeal() called
/// @dev intended to be deployed by buyer - may be altered for separation of deposit from purchase price, deposit non-refundability, additional conditions, etc.

/// @notice Solbase SafeTransferLib's 'SafeTransferETH()'. Pasted for convenience and transparency
/// @author Solbase (https://github.com/Sol-DAO/solbase/blob/main/src/utils/SafeTransferLib.sol)
library SafeTransferLib {
    /// @dev The ETH transfer has failed.
    error ETHTransferFailed();

    /// @dev Sends `amount` (in wei) ETH to `to`.
    /// Reverts upon failure.
    function safeTransferETH(address to, uint256 amount) internal {
        /// @solidity memory-safe-assembly
        assembly {
            // Transfer the ETH and check if it succeeded or not.
            if iszero(call(gas(), to, amount, 0, 0, 0, 0)) {
                // Store the function selector of `ETHTransferFailed()`.
                mstore(0x00, 0xb12d13eb)
                // Revert with (offset, size).
                revert(0x1c, 0x04)
            }
        }
    }
}

contract EscrowETH {
    using SafeTransferLib for address payable;

    address payable public immutable buyer;
    address payable public seller;

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
    error IncorrectMsgValue();
    error NotReadyToClose();
    error NotSeller();
    error PriceAlreadyInEscrow();

    /// @notice deployer (buyer) initiates escrow with description, price in wei, seconds until expiry, and designate recipient seller
    /// @param _description: brief identifier of the deal in question - perhaps as to parties/underlying asset/documentation reference/hash
    /// @param _price: purchase price in wei which will be deposited in the smart escrow contract
    /// @param _secsUntilExpiration: number of seconds until the deal expires. input type(uint256).max for no expiry
    /// @param _seller: the seller's address, recipient of the purchase price if the deal closes
    constructor(
        string memory _description,
        uint256 _price,
        uint256 _secsUntilExpiration,
        address payable _seller
    ) payable {
        buyer = payable(msg.sender);
        price = _price;
        description = _description;
        seller = _seller;
        expirationTime = block.timestamp + _secsUntilExpiration;
    }

    /// @notice for the current seller to designate a new recipient address
    /// @param _seller: new recipient address of seller
    function updateSeller(address payable _seller) external {
        if (msg.sender != seller) revert NotSeller();
        if (_seller == buyer) revert BuyerAddrSameAsSellerAddr();
        if (!checkIfExpired()) {
            seller = _seller;
            emit SellerUpdated(_seller);
        }
    }

    /// @notice deposits 'price' in address(this) via msg.value from caller, presumably buyer.
    function depositInEscrow() external payable {
        if (expirationTime <= block.timestamp) revert Expired();
        if (msg.value != price) revert IncorrectMsgValue();
        // prevent multiple transfers of 'price' from buyer, as this method is callable by any address
        if (checkEscrow() >= price) revert PriceAlreadyInEscrow();
    }

    /// @notice seller and buyer each call this when ready to close; returns approval status of each party
    /// @dev no need for a 'checkEscrow()' call because a reasonable seller will only pass 'true' if escrow is in place
    function readyToClose() external {
        if (msg.sender == seller) sellerApproved = true;
        else if (msg.sender == buyer) buyerApproved = true;
    }

    /** @notice callable by any external address: checks if both buyer and seller are ready to close and expiration has not been met;
     *** if so, this contract closes deal and pays seller; if not, price deposit returned to buyer **/
    /// @dev if properly closes, pays seller and emits event with effective time of closing
    function closeDeal() external {
        if (!sellerApproved || !buyerApproved) revert NotReadyToClose();

        // delete approvals to prevent re-entrance
        delete sellerApproved;
        delete buyerApproved;

        if (!checkIfExpired()) {
            seller.safeTransferETH(price);

            // effective time of closing is block.timestamp upon payment to seller
            emit DealClosed(block.timestamp);
        }
    }

    /// @notice check if expired, and if expired, return balance to buyer
    function checkIfExpired() public returns (bool) {
        if (expirationTime <= block.timestamp) {
            isExpired = true;
            buyer.safeTransferETH(price);
            emit DepositReturned();
            emit DealExpired();
        }
        return (isExpired);
    }

    /// @notice checks address(this)'s balance to see if 'price' is in escrow
    function checkEscrow() public view returns (uint256) {
        return address(this).balance;
    }
}
