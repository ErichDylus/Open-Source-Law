//SPDX-License-Identifier: MIT
/*****
 ***** this code and any deployments of this code are strictly provided as-is;
 ***** no guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the code
 ***** or any smart contracts or other software deployed from these files,
 ***** in accordance with the disclosures and licenses found here: https://github.com/ErichDylus/Open-Source-Law/blob/main/LICENSE
 ***** this code is not audited, and users, developers, or adapters of these files should proceed with caution and use at their own risk.
 ****/

pragma solidity >=0.8.16;

import "https://github.com/ErichDylus/Open-Source-Law/blob/main/solidity/OpenOffer.sol";
import {
    PRBTest
} from "https://github.com/paulrberg/prb-test/blob/main/src/PRBTest.sol";

/// @title Open Offer Test

contract OpenOfferTest is PRBTest {
    bytes32 public testHash;

    OpenOffer public contracttest;

    function beforeEach(string calldata _documentText) external {
        contracttest = new OpenOffer(_documentText);
        testHash = keccak256(abi.encode(_documentText));
        return assertEq(contracttest.offerOpen(), true, "offer didn't open");
    }

    function checkDocHash() external {
        return
            assertEq(
                testHash,
                contracttest.documentHash(),
                "hash doesn't match"
            );
    }

    function checkRevokeOffer() external {
        (bool success, ) = address(contracttest).delegatecall(
            abi.encodeWithSignature("revokeOffer()")
        );
        require(success, "call failed");
        assertEq(contracttest.signedAndOfferAccepted(), true, "accept failed");
        assertEq(contracttest.offerOpen(), false, "offer did not close");
    }

    function checkVerifyOfferText(string calldata _documentText) external {
        (bool success, ) = address(contracttest).delegatecall(
            abi.encodeWithSignature("verifyOfferText()", _documentText)
        );
        require(success, "call failed");
    }
}
