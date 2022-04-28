//SPDX-License-Identifier: MIT
/**** 
***** this code and any deployments of this code are strictly provided as-is; no guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the code 
***** or any smart contracts or other software deployed from these files, in accordance with the disclosures and licenses found here: https://github.com/ErichDylus/Open-Source-Law/tree/main/solidity#readme
***** this code is not audited, and users, developers, or adapters of these files should proceed with caution and use at their own risk.
****/

pragma solidity >=0.8.4;

import "https://github.com/ErichDylus/Open-Source-Law/blob/main/solidity/PayInEth.sol";
import "https://github.com/dapphub/ds-test/blob/master/src/test.sol";

/// @title Pay In ETH Test

contract PayInETH_test is PayInETH, DSTest {

    address tester;
    PayInETH paytest;

    function beforeEach() public {
        paytest = new PayInETH();
        tester = msg.sender;
    }

    function checkInitialReceiver() public {
        return assertEq(receiver, tester, "initial receiver should be tester");
    }

    function checkNewReceiver(address _addr) public {
        (bool success, ) = address(paytest).delegatecall(abi.encodeWithSignature("changeReceiver(address)", _addr));
        require(success, "call failed");
        return assertEq(receiver, _addr, "receiver not changed");
    }
    
    function checkRouter() public {
        return assertEq(SUSHI_ROUTER_ADDR, 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F, "router address constant");
    }

    function checkUSDCpath() public {
        address[] memory testpath = new address[](2);
        testpath = _getPathForETHtoUSDC();
        assertEq(testpath[0], 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2, "path incorrect");
        assertEq(testpath[1], 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, "path incorrect");
    }
}
