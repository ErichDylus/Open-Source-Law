//SPDX-License-Identifier: MIT

pragma solidity >=0.8.16;

/// unaudited and subject to all disclosures, licenses, and caveats set forth at https://github.com/ErichDylus/Open-Source-Law/blob/main/solidity/README.md

interface IVoteCounter {

function newVote(
        uint256 voteNumber,
        uint256 voterId,
        address voter
    ) external;
    
}
