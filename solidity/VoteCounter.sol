//SPDX-License-Identifier: MIT

pragma solidity >=0.8.16;

/// unaudited and subject to all disclosures, licenses, and caveats set forth at https://github.com/ErichDylus/Open-Source-Law/blob/main/solidity/README.md
/// @title VoteCounter
/// @notice Counts votes for a given address, with timestamp;
/// intended as part of a governance contract which tallies ERC1155-gated votes for patronage calculations

interface IERC1155 {
    function balanceOf(address account, uint256 id)
        external
        view
        returns (uint256);
}

contract VoteCounter {
    IERC1155 public ierc1155;

    mapping(address => bool) public isVoter;
    mapping(address => uint256) public voteIndex;
    mapping(uint256 => bool) public isValidVote;

    event Voted(
        uint256 indexed voteTime,
        uint256 voteNumber,
        uint256 voteIndex,
        address voter
    );

    error InvalidVote();
    error NotVoter();

    /// @param _govToken: address of the ERC1155 governance token used for votes
    constructor(address _govToken) {
        ierc1155 = IERC1155(_govToken);
    }

    /// @param _voteNumber: vote index for the applicable governance contract
    /// @param _voterId: id for the voter's ERC1155 token
    /// @param _voter: address of the voter
    /** @dev intended to be called as part of a vote cast function, 
    /// otherwise add a _voteTime method input of the unix time (block.timestamp) of the applicable vote */
    function newVote(
        uint256 _voteNumber,
        uint256 _voterId,
        address _voter
    ) external {
        if (ierc1155.balanceOf(_voter, _voterId) == 0) revert NotVoter();
        if (!isValidVote[_voteNumber]) revert InvalidVote();
        unchecked {
            ++voteIndex[_voter];
        } // increment voteIndex, will not overflow on human timelines
        emit Voted(block.timestamp, _voteNumber, voteIndex[_voter], _voter);
    }
}
