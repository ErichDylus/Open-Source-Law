//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

/// @notice import DSTest
import {DSTest} from "ds-test/test.sol";

/// @dev import OpenOffer.sol
import {OpenOffer} from "src/OpenOffer.sol";

/// @title OpenOfferTest
contract TestOpenOffer is DSTest {
    OpenOffer public instance;

    address public instanceAddr;
    string input = "input";

    function setUp() external {
        instance = new OpenOffer("input");
        instanceAddr = address(instance);
    }

    function testOfferOpen() external {
        return assertTrue(instance.offerOpen());
    }

    function testVerifyOfferText() external {
        return assertTrue(instance.verifyOfferText(input));
    }

    function testAcceptOffer() external {
        assertTrue(instance.offerOpen());
        (bool success, ) = instanceAddr.delegatecall(
            abi.encodeWithSignature("acceptOffer()")
        );
        return assertEq(success, instance.signedAndOfferAccepted());
    }
}
