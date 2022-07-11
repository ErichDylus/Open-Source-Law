//SPDX-License-Identifier: MIT
/****
 ***** this code and any deployments of this code are strictly provided as-is;
 ***** no guarantee, representation or warranty is being made,
 ***** express or implied, as to the safety or correctness of the code
 ***** or any smart contracts or other software deployed from these files,
 ***** in accordance with the disclosures and licenses
 ***** found here: https://github.com/ErichDylus/Open-Source-Law/tree/main/solidity#readme
 ***** this code is not audited, and users, developers, or adapters of these files
 ***** should proceed with caution and use at their own risk.
 ****/
pragma solidity >=0.8.14;

import "https://github.com/api3dao/airnode/blob/master/packages/airnode-protocol/contracts/rrp/requesters/RrpRequesterV0.sol";
import "https://github.com/kalidao/kali-contracts/blob/main/contracts/tokens/erc721/ERC721.sol";

/// @title NFTicket
/** @notice QRNG-powered transferable NFT ticket minter with random ID number;
 ** random tokenID may be used as a lottery or special privilege mechanism for NFTicket holder */
/// @dev uses API3/ANU QRNG, KaliDAO ERC721 implementation
/// for more NFT QRNG uses, see this walkthrough: https://medium.com/@ashar2shahid/building-quantumon-part-1-smart-contract-integration-with-qrng-714cfecf336c

contract NFTicket is ERC721, RrpRequesterV0 {
    uint256 public immutable TICKET_CAP;
    uint256 public immutable TICKET_PRICE;

    address public airnode;
    address payable sponsorWallet;
    bytes32 public endpointId;
    uint256 public ticketCount;

    mapping(bytes32 => address) requestIdToBuyer;
    mapping(bytes32 => bool) public expectingRequestWithIdToBeFulfilled;

    error SubmitTicketPrice();
    error TicketCapReached();
    error TransferToSponsorWalletFailed();

    event ReceivedTicket(address indexed buyer, uint256 ticketID);

    /** SPONSOR WALLET MUST BE DERIVED FROM ADDRESS(THIS) AFTER DEPLOYMENT 
        npx @api3/airnode-admin derive-sponsor-wallet-address --airnode-xpub 
        xpub6DXSDTZBd4aPVXnv6Q3SmnGUweFv6j24SK77W4qrSFuhGgi666awUiXakjXruUSCDQhhctVG7AQt67gMdaRAsDnDXv23bBRKsMWvRzo6kbf 
        --airnode-address 0x9d3C147cA16DB954873A498e0af5852AB39139f2 --sponsor-address address(this) */
    /// @param _airnodeRrp: Airnode RRP contract address
    /// @param _airnode: ANU airnode contract address
    /// @param _sponsorWallet: derived sponsor wallet address
    /// @param _endpointId: endpointID for the QRNG, see https://docs.api3.org/qrng/providers.html
    /// @param _ticketPrice: price of a NFTicket in wei
    /// @param _ticketCap: maximum number of mintable NFTickets
    /// @notice derive sponsorWallet via https://docs.api3.org/airnode/v0.6/concepts/sponsor.html#derive-a-sponsor-wallet
    /// @dev set parameters for airnodeRrp.makeFullRequest; https://docs.api3.org/qrng/chains.html
    constructor(
        string memory _name,
        string memory _symbol,
        address _airnode,
        bytes32 _endpointId,
        address payable _sponsorWallet,
        uint256 _ticketPrice,
        uint256 _ticketCap
    ) payable ERC721(_name, _symbol) RrpRequesterV0(_airnodeRrp) {
        airnode = _airnode;
        endpointId = _endpointId;
        sponsorWallet = _sponsorWallet;
        TICKET_PRICE = _ticketPrice;
        TICKET_CAP = _ticketCap;
    }

    /// @notice submit TICKET_PRICE in msg.value to mint an NFTicket with random tokenID
    function buyTicket() external payable {
        if (msg.value != TICKET_PRICE) revert SubmitTicketPrice();
        if (ticketCount >= TICKET_CAP) revert TicketCapReached();

        bytes32 requestId = airnodeRrp.makeFullRequest(
            airnode,
            endpointId,
            address(this),
            sponsorWallet,
            address(this),
            this.fulfillUint256.selector,
            ""
        );
        expectingRequestWithIdToBeFulfilled[requestId] = true;
        requestIdToBuyer[requestId] = msg.sender;
    }

    /// @dev AirnodeRrp will call back here with a response
    function fulfillUint256(bytes32 requestId, bytes calldata data)
        external
        onlyAirnodeRrp
    {
        require(
            expectingRequestWithIdToBeFulfilled[requestId],
            "Request ID not known"
        );
        expectingRequestWithIdToBeFulfilled[requestId] = false;
        uint256 _ticketID = abi.decode(data, (uint256));
        address buyer = requestIdToBuyer[requestId];
        _mint(buyer, _ticketID);

        unchecked {
            ++ticketCount;
        }

        emit ReceivedTicket(buyer, _ticketID);
    }

    /// @notice sends msg.value to sponsorWallet to ensure Airnode continues responses
    function topUpSponsorWallet() external payable {
        require(msg.value != 0, "msg.value == 0");
        (bool sent, ) = sponsorWallet.call{value: msg.value}("");
        if (!sent) revert TransferToSponsorWalletFailed();
    }

    /// @notice allows an NFTicket holder to burn NFTicket
    /// @param tokenID: token ID of NFTicket to be burned
    function burn(uint256 tokenId) public virtual {
        if (msg.sender != ownerOf[tokenId]) revert NotOwner();
        _burn(tokenId);
    }
}
