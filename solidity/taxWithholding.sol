//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/* FOR DEMONSTRATION ONLY, not recommended to be used for any purpose and provided with no warranty whatsoever
 * @dev split your own lump sum income payments into withheld tax and net income
 * send portion to tax withholding wallet and remainder to 'checking account wallet'
 * TODO: correct paystubNumber issue, math, introduce multiple usage
 */
 
interface IERC20 {

    //returns the amount of tokens owned by account
    function balanceOf(address account) external view returns (uint256);

    //moves amount tokens from the caller's account to recipient, returns bool of success, emits transfer event
    function transfer(address recipient, uint256 amount) external returns (bool);

    //returns the remaining number of tokens that spender will be allowed to spend on behalf of owner through transferFrom
    function allowance(address owner, address spender) external view returns (uint256);

    //sets amount as the allowance of spender over the caller's tokens, returns bool of success
    /* IMPORTANT: Beware that changing an allowance with this method brings the risk that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. May not be an issue since tax and checking addresses should both be controlled by owner. see: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729 */
    function approve(address spender, uint256 amount) external returns (bool);

    //moves `amount` tokens from `sender` to `recipient` using the allowance mechanism. `amount` is then deducted from the caller's
    //allowance. returns bool of success, emits a {Transfer} event.
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface customDripToken {
    function customDripTKN(uint256[] memory drip, address dripTokenAddress) external;
}

contract TaxWithholding {
    IERC20 public ierc20; 
    address tokenAddress;
    address payable[] payees;
    address payable immutable dripDropFactory = payable(0x7d5943dFb6fF3303728629Cf066B6D7cFb22733B); // LexDAO MemberDripDropFactory contract address
    mapping(address => uint256) payeeNumber;
    mapping(uint256 => mapping(address => uint256)) paystubNumber;
    
    
    constructor() payable {}
    
    //payee submits income, tax rate, token address, tax and checking wallet addresses, and chosen ID number
    function withholdTax(uint256 _income, uint8 _taxRate, address _tokenAddress, address payable _taxWallet, address payable _checkingWallet, uint256 _IDnumber) external returns(uint256, uint256) {
        require(_taxWallet != address(0) && _checkingWallet != address(0), "Submit valid tax and checking wallet addresses");
        require(_taxRate > 0 && _taxRate < 100, "Submit tax rate percentage as whole number, for example 25");
        tokenAddress = _tokenAddress;
        ierc20 = IERC20(tokenAddress);
        ierc20.transfer(address(this), _income); // send gross income to this contract
        uint256 _taxes = (uint256(_income/uint256(_taxRate)));
        uint256 _afterTaxAmount = _income - _taxes;
		ierc20.transferFrom(address(this), _taxWallet, _taxes);
		ierc20.transferFrom(address(this), _checkingWallet, _afterTaxAmount);
		uint256 _taxBalance = ierc20.balanceOf(_taxWallet); 
		uint256 _checkingBalance = ierc20.balanceOf(_checkingWallet);
		payeeNumber[msg.sender] = _IDnumber;
		//paystubNumber[_IDnumber][payeeNumber]++; 
		/* TODO: arrays of addresses and withheld amounts
		customDripToken(dripDropFactory).customDripTKN(uint256[] memory _taxes, tokenAddress,)
		customDripToken(dripDropFactory).customDripTKN(uint256[] memory _afterTaxAmount, tokenAddress,)
		*/
        return(_taxBalance, _checkingBalance);
    }
}
