// SPDX-License-Identifier: UNLICENSED
// incomplete
pragma solidity >=0.8.12;

import "forge-std/Test.sol";
import "src/EscrowETH.sol";

/// @notice foundry framework testing of EscrowETH.sol

/// @notice test contract for EscrowETH using Foundry
contract EscrowETHTest is Test {
    EscrowETH public escrowTest;

    address payable seller = payable(address(1));
    bool deposited;
    uint256 deployTime;
    uint256 price = 1e16;
    uint256 secsUntilExpiration = 500;

    string testDescription = "description";

    function setUp() public {
        escrowTest = new EscrowETH(
            testDescription,
            price,
            secsUntilExpiration,
            seller
        );
        deployTime = block.timestamp;
    }

    function testConstructor() public {
        assertEq(
            escrowTest.expirationTime(),
            deployTime + secsUntilExpiration,
            "Expiry time mismatch"
        );
    }

    function testUpdateSeller(address payable _addr) public {
        if (
            msg.sender != seller ||
            msg.sender == address(this) ||
            escrowTest.checkIfExpired()
        ) vm.expectRevert();
        escrowTest.updateSeller(_addr);

        vm.prank(seller);
        escrowTest.updateSeller(_addr);
        assertEq(escrowTest.seller(), _addr, "seller address did not update");
    }
}
