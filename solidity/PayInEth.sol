//SPDX-License-Identifier: MIT

/**** 
***** this code and any deployments of this code are strictly provided as-is; no guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the code 
***** or any smart contracts or other software deployed from these files, in accordance with the disclosures and licenses found here: https://github.com/ErichDylus/Open-Source-Law/tree/main/solidity#readme
***** this code is not audited, and users, developers, or adapters of these files should proceed with caution and at their own risk.
****/

pragma solidity ^0.8.0;

/// @title Pay In ETH
/// @dev uses Sushiswap router to swap incoming ETH for USDC tokens, then sends to receiver address (initially, the deployer)
/// @notice permits payment for services denominated in ETH but receiving stablecoins without undertaking the swap themselves, avoiding additional unnecessary de minimus taxable events in some jurisdictions.
/// may be easily forked to instead accept DAI, RAI, or any other token with a swap pair - USDC merely used as an example

interface IUniswapV2Router02 {
    function swapExactETHForTokens(uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external payable returns (uint256[] memory amounts);
    function WETH() external pure returns (address);
}

interface IUSDC  { 
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract PayInETH {

    address constant USDC_TOKEN_ADDR = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // USDC mainnet token contract address, change this for desired token to be received
    address constant SUSHI_ROUTER_ADDR = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F; // Sushiswap router contract address
    address immutable deployer;
    address receiver; 

    IUniswapV2Router02 public sushiRouter;
    IUSDC public iUSDCToken;

    error NoUSDC();
    error ZeroMsgValue();

    constructor() payable {
        sushiRouter = IUniswapV2Router02(SUSHI_ROUTER_ADDR);
        iUSDCToken = IUSDC(USDC_TOKEN_ADDR);
        receiver = msg.sender;
        deployer = msg.sender;
    }

    /// @notice receives ETH payment and swaps to USDC via Sushiswap router, which is then sent to receiver.
    /// @dev here, minimum amount set as 0 and deadline set to 100 seconds after call as initial options to avoid failure, but can be altered
    function payInETH() public payable {
        if (msg.value == 0) revert ZeroMsgValue();
        sushiRouter.swapExactETHForTokens{ value: msg.value }(0, _getPathForETHtoUSDC(), address(this), block.timestamp+100);
        _sendUSDC();
    }

    /// @notice allows current receiver address to change the receiver address for payments
    /// @param _newReceiver new address to receive ultimate stablecoin payment
    /// @return the receiver address
    function changeReceiver(address _newReceiver) external returns (address) {
        // necessary in case receiver is ever changed to a contract address. require() used instead of custom error because of two address possibilities
        require (msg.sender == receiver || msg.sender == deployer, "ONLY_DEPLOYER_OR_CURRENT_RECEIVER");
        receiver = _newReceiver;
        return (receiver);
    }

    function _sendUSDC() internal {
        if (iUSDCToken.balanceOf(address(this)) == 0) revert NoUSDC();
        iUSDCToken.transfer(receiver, iUSDCToken.balanceOf(address(this)));
    }
    
    /// @return the router path for ETH/USDC swap for the payInETH() function
    function _getPathForETHtoUSDC() internal view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = sushiRouter.WETH(); //0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2
        path[1] = USDC_TOKEN_ADDR;
        return path;
    }

    receive() payable external {}
}
