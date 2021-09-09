//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/** INCOMPLETE, FOR DEMONSTRATION ONLY, not recommended to be used for any purpose and provided with no warranty whatsoever
 *  @dev simple tax withholding contract to give IRS its pound of DeFi flesh
 *  provides rough estimate, division intricacies in process **/
 
interface IERC20 {

    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


contract TaxWithholding {
  
    address payable immutable IRS; 
    address payable[] taxpayers;
    address tokenAddress;
    bool isPaid;
    uint8 immutable taxRate;
    IERC20 public ierc20;
    mapping(address => bool) paid;
    
    // @param _IRSaddress: IRS's designated address to receive taxes
    // @param _taxRate: flat percentage tax rate expressed as a whole number
    constructor(address _IRSaddress, uint8 _taxRate) payable {
        require(_IRSaddress != address(0), "Submit valid IRS wallet address");
        require(_taxRate > 0 && _taxRate < 100, "Submit tax rate percentage as whole number, for example 5 for 5%");
        IRS = payable(_IRSaddress); 
        taxRate = _taxRate;
    }
    
    // function approve() {} - consider replacing ERC20 interface approve/transfer with safeTransfers
    
    // @param _income:  income amount and 
    // @param _tokenAddress: contract address of ERC20 token received (if applicable/if not simple ETH payment)
    function withholdTax(uint256 _income, address _tokenAddress) public returns(uint256, uint256) {
        ierc20 = IERC20(_tokenAddress);
        ierc20.transfer(address(this), _income); // send gross income to this contract
        uint256 _taxes = (uint256(_income/uint256(taxRate)));
        uint256 _afterTaxAmount = _income - _taxes;
		    ierc20.transferFrom(address(this), IRS, _taxes);
		    ierc20.transferFrom(address(this), msg.sender, _afterTaxAmount);
		    paid[msg.sender] = true;
        return(_taxes, _afterTaxAmount);
    }
}
