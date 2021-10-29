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

// contingent on numerous external factors such as jurisdiction and status of each msg.sender, but initially created as a flat rate federal tax demonstration
// meant to be an abstract add-on to another contract which results in income taxable event when a user makes a transaction 
contract TaxWithholding {
  
    address payable immutable IRS;
    address tokenAddress;
    address[] taxpayers;
    uint256 immutable taxRate;
    IERC20 public ierc20;
    mapping(address => bool) paid;
    
    event TaxWithheld(address indexed taxpayer, uint256 indexed time, uint256 taxes);
    
    // @param _IRSaddress: IRS's designated address to receive taxes
    // @param _taxRate: flat percentage tax rate expressed as a whole number
    constructor(address _IRSaddress, uint256 _taxRate) payable {
        require(_IRSaddress != address(0), "Submit valid IRS wallet address");
        require(_taxRate > 0 && _taxRate < 100, "Submit tax rate percentage as whole number, for example 5 for 5%");
        IRS = payable(_IRSaddress); 
        taxRate = _taxRate;
    }
    
    // ******** msg.sender must separately approve address(this) for tokenAddress ********, will need easier implementation
    // @param _income: received income amount by msg.sender in the applicable token corresponding to _tokenAddress 
    // @param _tokenAddress: contract address of ERC20 token received (if applicable/if not simple ETH payment)
    function withholdTax(uint256 _income, address _tokenAddress) public returns(uint256, bool) {
        ierc20 = IERC20(_tokenAddress);
        uint256 _taxes = (uint256(_income/taxRate));
		ierc20.transferFrom(msg.sender, IRS, _taxes);
		taxpayers.push(msg.sender);
		paid[msg.sender] = true;
		emit TaxWithheld(msg.sender, block.timestamp, _taxes);
        return(_taxes, paid[msg.sender]);
    }
}
