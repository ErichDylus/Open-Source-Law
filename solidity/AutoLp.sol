//SPDX-License-Identifier: MIT

/**
 ** CAUTION: this code is provided for demonstration purposes only and strictly as-is with no guarantees, representations nor warranties (express or implied) of any kind
 */

pragma solidity ^0.8.17;

///
/// Interfaces
///

interface IUniswapV2Router02 {
    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    /// @dev Returns the address of the pair for tokenA and tokenB, if it has been created, else address(0); tokenA and tokenB are interchangeable
    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);

    /// @dev for iLpToken only
    function token0() external view returns (address);

    function token1() external view returns (address);

    function transfer(address to, uint256 amount) external returns (bool);
}

interface IUniswapV2Pair {
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

/// @title AutoLP
/** @notice this ownerless immutable contract automatically uses any ETH sent to address(this) to LP the selected token's pair with ETH in UniswapV2; each LP is then queued chronologically.
 *** LP position is redeemable to this contract by any caller, which is swapped to the constructor-supplied tokens via UniswapV2 and burned via the null address
 *** for illustrative purposes, though a native burn function in the applicable token contract would be a preferable practice
 ****/
/// @dev be advised there is inherent slippage risk for large amounts, with some protection via '_getTokenMinAmountOut'
contract AutoLP {
    struct Liquidity {
        uint256 withdrawTime;
        uint256 amount;
    }

    /// @notice UniV2 Router Address
    address internal constant UNI_ROUTER_ADDR =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    /// @notice WETH9 used in the UniV2 Router
    address internal constant WETH_TOKEN_ADDR =
        0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IUniswapV2Router02 internal constant router =
        IUniswapV2Router02(UNI_ROUTER_ADDR);

    IERC20 internal immutable iToken;
    IERC20 internal immutable iLpToken;

    address internal immutable tokenAddr;

    uint256 public lpAddIndex;
    uint256 public lpRedeemIndex;

    mapping(uint256 => Liquidity) public liquidityAdds;

    ///
    /// Errors
    ///

    error NoTokens();
    error NoRedeemableLPTokens();
    error PairUpdateDelay();
    error ZeroDivisor();

    ///
    /// Events
    ///

    event LiquidityProvided(
        uint256 liquidityAdded,
        uint256 indexed lpIndex,
        uint256 indexed timestamp
    );
    event LiquidityRemoved(
        uint256 liquidityRemoved,
        uint256 indexed lpIndex,
        uint256 indexed timestamp
    );
    event TokensBurned(uint256 amountBurned);

    ///
    /// Functions
    ///

    /// @notice set interfaces and approve 'router' for address(this) for 'tokenAddress' and 'lpTokenAddress'
    /// @param _tokenContract: the contract address of the applicable ERC20 token which is to be LPed
    constructor(address _tokenContract) payable {
        tokenAddr = _tokenContract;
        iToken = IERC20(_tokenContract);
        iLpToken = IERC20(router.getPair(_tokenContract, WETH_TOKEN_ADDR));
        iToken.approve(UNI_ROUTER_ADDR, type(uint256).max);
        iLpToken.approve(UNI_ROUTER_ADDR, type(uint256).max);
    }

    /// @notice receives ETH sent to address(this), and if msg.sender is not the Uniswap V2 router address, initiates the automatic LP process
    /// small amounts are preferable to avoid sandwich-ing and reversion due to the '_getTokenMinAmountOut' check
    receive() external payable {
        if (msg.sender != UNI_ROUTER_ADDR) {
            uint256 _ethSwapAmount = address(this).balance / 2;

            // swap half of ETH for tokens
            router.swapExactETHForTokens{value: _ethSwapAmount}(
                _getTokenMinAmountOut(_ethSwapAmount),
                _getPath(),
                address(this),
                block.timestamp
            );

            // LP
            _lpTokenEth();
        }
    }

    /** @dev checks earliest Liquidity struct to see if any LP tokens are redeemable,
     ** then redeems that amount of liquidity to this address (which is entirely converted and burned in tokens),
     ** then deletes that mapped struct in 'liquidityAdds' and increments 'lpRedeemIndex' */
    /// @notice redeems the earliest available liquidity; redeemed tokens are burned and redeemed ETH is converted to tokens and burned
    function redeemLP() external {
        if (liquidityAdds[lpRedeemIndex].withdrawTime > block.timestamp)
            revert NoRedeemableLPTokens();
        uint256 _redeemableLpTokens = liquidityAdds[lpRedeemIndex].amount;

        // if 'lpRedeemIndex' returns zero, increment the index; otherwise call '_redeemLP' and then increment
        if (_redeemableLpTokens == 0) {
            delete liquidityAdds[lpRedeemIndex];
        } else {
            _redeemLP(_redeemableLpTokens, lpRedeemIndex);
        }
        unchecked {
            ++lpRedeemIndex;
        }
    }

    /** @dev checks applicable Liquidity struct to see if any LP tokens are redeemable,
     ** then redeems that amount of liquidity to this address (which is entirely converted and burned in tokens),
     ** then deletes that mapped struct in 'liquidityAdds'. Implemented in case of lpAddIndex--lpRedeemIndex mismatch */
    /// @notice redeems specifically indexed liquidity; redeemed tokens are burned and redeemed ETH is converted to tokens and burned
    /// @param _lpRedeemIndex: index of liquidity in 'liquidityAdds' mapping to be redeemed
    function redeemSpecificLP(uint256 _lpRedeemIndex) external {
        if (liquidityAdds[_lpRedeemIndex].withdrawTime > block.timestamp)
            revert NoRedeemableLPTokens();
        uint256 _redeemableLpTokens = liquidityAdds[_lpRedeemIndex].amount;

        // if '_lpRedeemIndex' returns zero, delete mapping; otherwise call '_redeemLP'. Do not increment the global 'lpRedeemIndex'
        if (_redeemableLpTokens == 0) {
            delete liquidityAdds[_lpRedeemIndex];
        } else {
            _redeemLP(_redeemableLpTokens, _lpRedeemIndex);
        }
    }

    /// @notice LPs ETH and tokens to UniswapV2's 'tokenAddr'/ETH pair
    /// @dev LP has 10% slippage buffer. Liquidity is queued chronologically.
    function _lpTokenEth() internal {
        uint256 _tokenBal = iToken.balanceOf(address(this));
        if (_tokenBal == 0) revert NoTokens();
        uint256 _ethBal = address(this).balance;
        (, , uint256 liquidity) = router.addLiquidityETH{value: _ethBal}(
            tokenAddr,
            _tokenBal,
            (_tokenBal * 9) / 10, // 90% of the '_tokenBal'
            (_ethBal * 9) / 10, // 90% of the '_ethBal'
            payable(address(this)),
            block.timestamp
        );
        emit LiquidityProvided(liquidity, lpAddIndex, block.timestamp);
        unchecked {
            liquidityAdds[lpAddIndex] = Liquidity(block.timestamp, liquidity);
            // will not overflow on human timelines
            ++lpAddIndex;
        }
    }

    /// @notice redeems the LP for the corresponding 'lpRedeemIndex', swaps redeemed ETH for tokens, and burns them
    /// @param _redeemableLpTokens: amount of LP tokens available to redeem
    /// @param _lpRedeemIndex: LP index being redeemed
    function _redeemLP(
        uint256 _redeemableLpTokens,
        uint256 _lpRedeemIndex
    ) internal {
        router.removeLiquidityETH(
            tokenAddr,
            _redeemableLpTokens,
            1,
            1,
            payable(address(this)),
            block.timestamp
        );
        delete liquidityAdds[_lpRedeemIndex];
        emit LiquidityRemoved(
            _redeemableLpTokens,
            _lpRedeemIndex,
            block.timestamp
        );

        // removed liquidity is 50/50 ETH and tokens; swap all newly received ETH for tokens
        router.swapExactETHForTokens{value: address(this).balance}(
            _getTokenMinAmountOut(address(this).balance),
            _getPath(),
            address(this),
            block.timestamp
        );
        // burn tokens
        iToken.transfer(address(0), iToken.balanceOf(address(this)));
    }

    /// @notice calculate a minimum amount of tokens out, as 90% of the price in wei as of the last update
    /// @dev exclude pair updates in this block to prevent sandwiching (i.e. that the most recent timestamp returned by 'getReserves()' is not the same timestamp as this attempted swap)
    /// @param _amountIn: amount of wei to be swapped for tokens
    function _getTokenMinAmountOut(
        uint256 _amountIn
    ) internal view returns (uint256) {
        (
            uint112 _token0Reserve,
            uint112 _token1Reserve,
            uint32 _timestamp
        ) = IUniswapV2Pair(address(iLpToken)).getReserves();

        // compare current block timestamp within the range of uint32 to last pair update; must be > 0 in order to prevent sandwiching
        if (block.timestamp - _timestamp == 0) revert PairUpdateDelay();

        // minimum amount of tokens out is 90% of the quoted price
        // the '_amountIn' is wei, so we want 'quote()' to return amount denominated in tokens
        // check whether WETH is 'token0' or 'token1' for the relevant pair in order to return the proper quote
        if (iLpToken.token0() == WETH_TOKEN_ADDR)
            return
                (router.quote(
                    _amountIn,
                    uint256(_token0Reserve),
                    uint256(_token1Reserve)
                ) * 9) / 10;
        else
            return
                (router.quote(
                    _amountIn,
                    uint256(_token1Reserve),
                    uint256(_token0Reserve)
                ) * 9) / 10;
    }

    /// @return path: the router path for ETH/'tokenAddr' swap
    function _getPath() internal view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = WETH_TOKEN_ADDR;
        path[1] = tokenAddr;
        return path;
    }
}
