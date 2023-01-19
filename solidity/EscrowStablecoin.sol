//SPDX-License-Identifier: MIT

pragma solidity >=0.8.17;

/// unaudited and for demonstration only, provided as-is without any guarantees or warranties
/// @title Stablecoin Escrow
/// @notice bilateral smart escrow contract, with an ERC20 stablecoin as payment, expiration denominated in seconds, deposit refunded if contract expires before closeDeal() called
/// @dev intended to be deployed by buyer - may be altered for separation of deposit from purchase price, deposit non-refundability, different token standard, additional conditions, etc.

// SolDAO SafeTransferLib
import {
    SafeTransferLib
} from "https://github.com/Sol-DAO/solbase/blob/main/src/utils/SafeTransferLib.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract EscrowStablecoin {
    using SafeTransferLib for address;

    address public immutable buyer;
    address public seller;
    address public immutable stablecoin;

    uint256 public price;
    uint256 public expirationTime;

    bool public sellerApproved;
    bool public buyerApproved;
    bool public isExpired;

    string public description;

    event DealExpired();
    event DealClosed(uint256 effectiveTime); //event provides exact blockstamp Unix time of closing
    event DepositReturned();

    error Expired();
    error NotBuyer();
    error NotParty();
    error NotReadyToClose();
    error NotSeller();
    error BuyerAddrSameAsSellerAddr();

    /// @notice deployer (buyer) initiates escrow with description, price in tokens, address of stablecoin, seconds until expiry, and designate recipient seller
    /// @param _description: brief identifier of the deal in question - perhaps as to parties/underlying asset/documentation reference/hash
    /// @param _price: purchase price number of tokens which will be deposited in the smart escrow contract
    /// @param _seller: the seller's address, recipient of the purchase price if the deal closes
    /// @param _stablecoin: token contract address of the stablecoin to be used in this transaction
    /// @param _secsUntilExpiration: number of seconds until the deal expires
    constructor(
        string memory _description,
        uint256 _price,
        address _seller,
        address _stablecoin,
        uint256 _secsUntilExpiration
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
    }

    /** @notice buyer deposits in address(this) *** after separately ERC20-approving address(this) for price***
     *** OR separately directly transfers the deposit to address(this) **/
    function depositInEscrow() external returns (bool, uint256) {
        if (msg.sender != buyer) revert NotBuyer();
        stablecoin.safeTransferFrom(buyer, address(this), price);
        return (true, IERC20(stablecoin).balanceOf(address(this)));
    }

    /// @notice check if expired, and if expired, return balance to buyer
    function checkIfExpired() external returns (bool) {
        if (expirationTime <= block.timestamp) {
            isExpired = true;
            _returnDeposit();
            emit DealExpired();
        } else {
            isExpired = false;
        }
        return (isExpired);
    }

    /// @notice convenience function to check if price is in address(this)
    function checkEscrow() external view returns (uint256) {
        return IERC20(stablecoin).balanceOf(address(this));
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
            _paySeller();

            // effective time of closing is block.timestamp upon payment to seller
            emit DealClosed(block.timestamp);
        }
    }

    /// @notice returns price deposit to buyer
    function _returnDeposit() internal {
        stablecoin.safeTransfer(buyer, price);

        emit DepositReturned();
    }

    /// @notice sends deposited purchase price to seller
    function _paySeller() internal {
        stablecoin.safeTransfer(seller, price);
    }
}
