//SPDX-License-Identifier: MIT
/****
 ***** this code and any deployments of this code are strictly provided as-is; no guarantee, representation or warranty is being made, express or implied, as to the safety or correctness of the code
 ***** or any smart contracts or other software deployed from these files, in accordance with the disclosures and licenses found here: https://github.com/V4R14/firm_utils/blob/main/LICENSE
 ***** this code is not audited, and users, developers, or adapters of these files should proceed with caution and use at their own risk.
 *****
 ****/

pragma solidity >=0.8.16;

/// @title Token Converter
/// @dev uses Uniswap router to swap incoming ERC20 tokens for receiver's chosen ERC20 tokens, then sends to receiver address (initially, the deployer)
/// @notice permits payment for services in any token payor chooses (provided there is a Uniswap router path, but does not check liquidity) and receiving tokens of choice by receiver

interface IUniswapV2Router02 {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

contract TokenConverter {
    address constant UNI_ROUTER_ADDR =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap v2 router contract address
    address receiver;
    address receiverToken;

    IUniswapV2Router02 uniRouter;

    error CallerNotCurrentReceiver();
    error TokenAmountNotSentToThisAddress();

    constructor(address _token) payable {
        uniRouter = IUniswapV2Router02(UNI_ROUTER_ADDR);
        receiver = msg.sender;
        receiverToken = _token;
    }

    /// @notice swaps payor token to receiver_token via Uniswap router, which is then sent to receiver
    /// @dev currently coded such that payor must first transfer _amount of _token to this contract address
    /// @param _token the token contract address of payor's tokens
    /// @param _amount the amount of tokens being paid by payor
    function completePayment(address _token, uint256 _amount) external {
        if (IERC20(_token).balanceOf(address(this)) < _amount)
            revert TokenAmountNotSentToThisAddress();
        IERC20(_token).approve(UNI_ROUTER_ADDR, _amount); // allow the unirouter to swap _token held by this address
        uniRouter.swapExactTokensForTokens(
            _amount,
            0,
            _getPath(_token),
            receiver,
            block.timestamp
        );
    }

    /// @notice allows current receiver address to change the receiver token contract address
    /// @param _newReceiverToken new token address for receiver_token
    /// @return the receiver token address
    function changeReceiverToken(address _newReceiverToken)
        external
        returns (address)
    {
        if (msg.sender != receiver) revert CallerNotCurrentReceiver();
        receiverToken = _newReceiverToken;
        return (receiverToken);
    }

    /// @notice allows current receiver address to change the receiver address for payments
    /// @param _newReceiver new address to receive receiverTokens
    /// @return the receiver address
    function changeReceiver(address _newReceiver) external returns (address) {
        if (msg.sender != receiver) revert CallerNotCurrentReceiver();
        receiver = _newReceiver;
        return (receiver);
    }

    /// @param _amount the amount of tokens to be paid by payor
    /// @param _payorToken the token contract address of payor's token
    /// @return amounts out for the applicable swap from _payorToken to receiverToken
    /// @notice convenience function to ensure liquid swap available before sending tokens to this contract
    function checkAmountsOut(uint256 _amount, address _payorToken)
        external
        view
        returns (uint256[] memory)
    {
        address[] memory path = new address[](2);
        path = _getPath(_payorToken);
        return uniRouter.getAmountsOut(_amount, path);
    }

    /// @param _payorToken the token contract address of payor's tokens, inputted by completePayment()
    /// @return the router path for the unirouter
    function _getPath(address _payorToken)
        internal
        view
        returns (address[] memory)
    {
        address[] memory path = new address[](2);
        path[0] = _payorToken;
        path[1] = receiverToken;
        return path;
    }
}
