// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.12;

import "forge-std/Test.sol";
import "src/EscrowETH.sol";

/// @notice foundry framework testing of EscrowETH.sol

/// @notice test contract for EscrowETH using Foundry
contract EscrowETHTest is Test {
    EscrowETH public escrowTest;

    address payable seller = payable(address(1));
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
        vm.deal(address(this), price);
    }

    receive() external payable {}

    function testConstructor() public {
        assertEq(
            escrowTest.expirationTime(),
            deployTime + secsUntilExpiration,
            "Expiry time mismatch"
        );
    }

    function testUpdateSeller(address payable _addr) public {
        if (escrowTest.checkIfExpired()) vm.expectRevert();

        vm.prank(escrowTest.seller());
        escrowTest.updateSeller(_addr);
        assertEq(escrowTest.seller(), _addr, "seller address did not update");
    }

    function testDepositInEscrow() public payable {
        if (msg.value != price || escrowTest.expirationTime() > block.timestamp)
            vm.expectRevert();
        escrowTest.depositInEscrow();
    }

    function testReadyToClose(address _caller) external {
        // if caller isn't seller or buyer and the sellerApproved and buyerApproved bools haven't already been change, any other address
        // calling this function should do nothing and the bools should not update
        if (
            _caller != escrowTest.seller() &&
            _caller != escrowTest.buyer() &&
            !escrowTest.sellerApproved() &&
            !escrowTest.buyerApproved()
        ) {
            vm.startPrank(_caller);
            escrowTest.readyToClose();
            assertTrue(!escrowTest.sellerApproved());
            assertTrue(!escrowTest.buyerApproved());
            vm.stopPrank();
        }

        //ensure seller and buyer can update their approved booleans
        vm.startPrank(escrowTest.seller());
        escrowTest.readyToClose();
        assertTrue(escrowTest.sellerApproved());
        vm.stopPrank();
        vm.startPrank(escrowTest.buyer());
        escrowTest.readyToClose();
        assertTrue(escrowTest.buyerApproved());
        vm.stopPrank();
    }

    function testCheckEscrow() external {
        assertEq(
            escrowTest.checkEscrow(),
            address(escrowTest).balance,
            "checkEscrow not returning contract balance"
        );
    }

    // fuzz test for different timestamps
    // balance checks assume no other msg.value transfers during testing
    function testCheckIfExpired(uint256 timestamp) external {
        // assume 'price' is in escrow, so escrowTest can transfer 'price' back to buyer if expired
        vm.deal(address(escrowTest), escrowTest.price());

        uint256 _preBalance = address(escrowTest).balance;
        uint256 _preBuyerBalance = escrowTest.buyer().balance;
        vm.warp(timestamp);
        escrowTest.checkIfExpired();
        // ensure, if timestamp is past expiration time and thus escrow is expired, boolean is updated and price is returned to buyer
        // else, isExpired() should be false and escrow's and buyer's balances should be unchanged
        if (escrowTest.expirationTime() <= timestamp) {
            assertTrue(escrowTest.isExpired());
            assertGt(
                _preBalance,
                address(escrowTest).balance,
                "escrow's balance should have been reduced by 'price'"
            );
            assertGt(
                escrowTest.buyer().balance,
                _preBuyerBalance,
                "buyer's balance should have been increased by 'price'"
            );
        } else {
            assertTrue(!escrowTest.isExpired());
            assertEq(
                _preBalance,
                address(escrowTest).balance,
                "escrow's balance should be unchanged"
            );
            assertEq(
                escrowTest.buyer().balance,
                _preBuyerBalance,
                "buyer's balance should be unchanged"
            );
        }
    }

    function testCloseDeal() external {
        // assume 'price' is in escrow, or sellerApproval() will be false (which is captured by this test anyway)
        vm.deal(address(escrowTest), escrowTest.price());

        uint256 _preBalance = address(escrowTest).balance;
        uint256 _preBuyerBalance = escrowTest.buyer().balance;
        uint256 _preSellerBalance = escrowTest.seller().balance;
        bool _approved;

        if (!escrowTest.sellerApproved() || !escrowTest.buyerApproved())
            vm.expectRevert();
        else _approved = true;

        escrowTest.closeDeal();

        // both approval booleans should have been deleted regardless of whether the escrow expired
        assertTrue(!escrowTest.sellerApproved());
        assertTrue(!escrowTest.buyerApproved());

        // if both seller and buyer approved closing before the closeDeal() call, proceed
        if (_approved) {
            // if the expiration time has been met or surpassed, check the same things as in 'testCheckIfExpired()' and that both approval booleans were deleted
            // else, seller should have received price
            if (escrowTest.isExpired()) {
                assertGt(
                    _preBalance,
                    address(escrowTest).balance,
                    "escrow's balance should have been reduced by 'price'"
                );
                assertGt(
                    escrowTest.buyer().balance,
                    _preBuyerBalance,
                    "buyer's balance should have been increased by 'price'"
                );
            } else {
                assertGt(
                    _preBalance,
                    address(escrowTest).balance,
                    "escrow's balance should have been reduced by 'price'"
                );
                assertGt(
                    escrowTest.seller().balance,
                    _preSellerBalance,
                    "seller's balance should have been increased by 'price'"
                );
            }
        }
    }
}
