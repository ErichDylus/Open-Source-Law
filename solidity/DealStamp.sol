//SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

/// unaudited and subject to all disclosures, licenses, and caveats set forth at https://github.com/ErichDylus/Open-Source-Law/blob/main/solidity/README.md
/// @title DealStamp
/// @notice An on-chain record of a deal's parties, decentralized doc room storage ref (presumably carrying an additional hash layer/other security mechanism for access), and time of closing
/// adaptations/forks might include a record of oracle information used in an on-chain closing, gasless sig verification, removal of parties from array, dispute resolution details, etc.

contract DealStamp {
    struct DealInfo {
        uint256 dealNumber;
        uint256 effectiveTime;
        string docsLocation;
        address[] parties;
    }

    DealInfo[] internal deals; // array of deal info structs, viewable via 'viewDeal()'

    uint256 internal dealNumber; // counter for stamped deals

    mapping(uint256 => string) public docsLocation; /*dealNumber => deal doc storage location ref */
    mapping(uint256 => mapping(address => bool)) /*dealNumber => whether address is a party to corresponding deal*/
        internal isPartyToDeal;

    event DealStamped(
        uint256 indexed dealNumber,
        uint256 effectiveTime,
        string docsLocation,
        address[] parties
    );
    event PartyAdded(uint256 indexed dealNumber, address newParty);

    error NotPartyToDeal();

    constructor() {}

    /// @param _docsLocationHash IPFS or other decentralized storage location hash of deal documents
    /// @param _effectiveTime unix time of closing, ex. block.timestamp of a stablecoin transfer or smart escrow contract closing
    /// @param _party1 address of first party to the deal
    /// @param _party2 address of second party to the deal
    /// @return the dealNumber of the newly stamped deal - make sure to keep record of this identifier.
    /// @notice intended to be called by authorized party, escrow or other closing smart contracts, by interface or arbitrary call. Record the dealNumber. Additional parties may be added by _party1 or _party2 via addPartyToDeal().
    function newDealStamp(
        string calldata _docsLocationHash,
        uint256 _effectiveTime,
        address _party1,
        address _party2
    ) external returns (uint256) {
        uint256 _currentDealNumber = dealNumber;
        address[] memory _parties = new address[](2);
        _parties[0] = _party1;
        _parties[1] = _party2;
        deals.push(
            DealInfo(
                _currentDealNumber,
                _effectiveTime,
                _docsLocationHash,
                _parties
            )
        );

        docsLocation[_currentDealNumber] = _docsLocationHash;
        isPartyToDeal[_currentDealNumber][_party1] = true;
        isPartyToDeal[_currentDealNumber][_party2] = true;
        unchecked {
            ++dealNumber;
        } // increment for next newDealStamp, will not overflow on human timelines

        emit DealStamped(
            _currentDealNumber,
            _effectiveTime,
            _docsLocationHash,
            _parties
        );

        return (_currentDealNumber); // DealStamper should record the dealNumber for this function call for relevant parties
    }

    /// @param _dealNumber enter dealNumber to view corresponding stamped deal information
    /// @return the DealInfo struct for the inputted dealNumber
    function viewDeal(uint256 _dealNumber)
        external
        view
        returns (DealInfo memory)
    {
        return (deals[_dealNumber]);
    }

    /// @param _dealNumber deal number of deal for which the new party will be added
    /// @param _newParty address of the new party to be added to the deal corresponding to _dealNumber
    function addPartyToDeal(uint256 _dealNumber, address _newParty) external {
        if (!isPartyToDeal[_dealNumber][msg.sender]) revert NotPartyToDeal();
        isPartyToDeal[_dealNumber][_newParty] = true;
        deals[_dealNumber].parties.push(_newParty);
        emit PartyAdded(_dealNumber, _newParty);
    }
}
