//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

/// @notice import Test
import "forge-std/test.sol";

/// @dev import OpenOffer.sol
import "src/OpenOffer.sol";

/// @title OpenOfferTest
contract TestOpenOffer is Test {
    OpenOffer public instance;

    // 'setUp()' does not accept params
    string input = "input text";

    function setUp() public {
        instance = new OpenOffer(input);
    }

    function testOfferOpen() external {
        return assertTrue(instance.offerOpen());
    }

    function testVerifyOfferText() external {
        return assertTrue(instance.verifyOfferText(input));
    }

    /// @param _offeree: address accepting the open offer
    function testAcceptOffer(address _offeree) external {
        assertTrue(instance.offerOpen(), "offer not open");
        // offeree calls 'acceptOffer()'
        vm.prank(_offeree);
        instance.acceptOffer();
        assertTrue(instance.signedAndOfferAccepted(), "offer not accepted");
    }
}
