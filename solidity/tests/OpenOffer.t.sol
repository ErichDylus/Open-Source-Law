//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

/// @notice import DSTest
import {DSTest} from "ds-test/test.sol";

/// @dev import OpenOffer.sol
import {OpenOffer} from "src/OpenOffer.sol";

/// @title OpenOfferTest
contract OpenOfferTest is DSTest {
    OpenOffer public testInstance;

    string input;

    constructor(string memory _input) {
        testInstance = new OpenOffer(_input);
        input = _input;
    }

    function setUp() external {}

    function testOfferOpen() public {
        return assertTrue(testInstance.offerOpen());
    }

    function testVerifyOfferText() public {
        return assertTrue(testInstance.verifyOfferText(input));
    }

    function testAcceptOffer() public {
        testInstance.acceptOffer();
        return assertTrue(testInstance.signedAndOfferAccepted());
    }
}
