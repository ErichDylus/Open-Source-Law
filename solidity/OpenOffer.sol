//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/// @title Open Offer
/// @notice revocable on-chain bilateral open offer, which anyone may countersign on-chain to accept
/** @dev deployer submits string text of a open offer which is hashed, and is verifiable by a prospective signer submitting the string text to verifyOfferText().
 ** Only one acceptance permitted. Revocable (but not amendable or replaceable) by offeror. */

contract OpenOffer {
    address public offeror;
    string public documentText;
    bytes32 public documentHash;
    bool public offerOpen;
    bool public signedAndOfferAccepted;

    error HashDoesNotMatch();
    error OfferClosed();
    error OffereeIsSameAddress();
    error OnlyOfferor();

    event OfferAccepted(
        bytes32 docHash,
        address signatory,
        uint256 effectiveTime
    );
    event OfferOpened(bytes32 docHash, uint256 effectiveTime);
    event OfferRevoked(uint256 effectiveTime);

    /// @param _documentText string text of submitted open offer
    constructor(string memory _documentText) {
        offeror = msg.sender;
        offerOpen = true;
        documentHash = keccak256(abi.encode(_documentText));
        emit OfferOpened(documentHash, block.timestamp);
    }

    /// @notice allows anyone except offeror to countersign and accept the open offer
    /// @dev simple function call, but could be modified to have signatory type name or other acknowledgment
    function acceptOffer() external {
        if (!offerOpen || signedAndOfferAccepted) revert OfferClosed();
        if (offeror == msg.sender) revert OffereeIsSameAddress();
        signedAndOfferAccepted = true;
        delete (offerOpen);
        emit OfferAccepted(documentHash, msg.sender, block.timestamp);
    }

    /// @notice allows offeror to revoke offer
    function revokeOffer() external {
        if (msg.sender != offeror) revert OnlyOfferor();
        delete (documentHash);
        delete (offerOpen);
        emit OfferRevoked(block.timestamp);
    }

    /** @notice allows a prospective signatory to ensure their intended document text matches
     ** the text hashed in this contract before signing */
    /// @param _documentText string text of document intended to be signed
    /// @return true if the hashes match, otherwise the transaction will have reverted
    function verifyOfferText(string memory _documentText)
        external
        view
        returns (bool)
    {
        if (keccak256(abi.encode(_documentText)) != documentHash)
            revert HashDoesNotMatch();
        return true;
    }
}
