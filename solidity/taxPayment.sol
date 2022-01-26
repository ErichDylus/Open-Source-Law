//SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

/// FOR DEMONSTRATION ONLY, incomplete, unaudited, not recommended to be used for any purpose and provided with no warranty whatsoever
/// @notice simple tax remitting contract to give IRS its pound of ERC20 flesh, estimated quarterly tax, etc.; sends to immutable IRS wallet address 
 
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// contingent on numerous external factors such as jurisdiction and status of each msg.sender, but initially created as a flat rate federal tax demonstration
// meant to be an abstract add-on to another contract which results in income taxable event when a dApp makes a transaction 
contract TaxPayment {
  
    address payable public immutable IRS;
    uint256 public immutable taxRate;
    mapping(address => uint256) taxPaymentNumber;
    mapping(uint256 => mapping(address => uint256) /*taxPaymentNumber*/) taxPaymentNumberAmount;
    
    event TaxPaid(address indexed taxpayer, uint256 indexed taxPaymentNumber, uint256 indexed timeOfPayment, uint256 taxPaymentAmount);
    
    /// @param _IRSaddress IRS's designated address to receive taxes
    /// @param _taxRate percentage tax rate expressed as a nonzero uint with 18 decimals/100. 1e18 = 100%, 1e17 = 10%, 1e15 = 0.1%, etc. 
    constructor(address _IRSaddress, uint256 _taxRate) payable {
        require(_taxRate > 0 && _taxRate < 1e18, "INVALID_TAX_RATE");
        IRS = payable(_IRSaddress); 
        taxRate = _taxRate;
    }
    
    /// @notice msg.sender must first separately approve address(this) for tokenAddress for at least _income amount
    /// @param _income received income amount by msg.sender in the applicable token corresponding to _tokenAddress, assuming 18 decimals 
    /// @param _tokenAddress contract address of ERC20 token received (if applicable/if not simple ETH payment)
    /// @return taxes paid, tax payment number for this msg.sender
    // TODO: add ETH functionality
    function payTax(uint256 _income, address _tokenAddress) public returns(uint256, uint256) {
        uint256 _taxes;
        uint256 _rate = taxRate;
        uint256 _denom = 1e18;
        assembly {
            _taxes := div(mul(_income, _rate), _denom)
        }
        IERC20(_tokenAddress).transferFrom(msg.sender, IRS, _taxes);
	taxPaymentNumber[msg.sender]++;
	taxPaymentNumberAmount[_taxes][msg.sender] = taxPaymentNumber[msg.sender];
	emit TaxPaid(msg.sender, taxPaymentNumber[msg.sender], block.timestamp, _taxes);
        return(_taxes, taxPaymentNumber[msg.sender]);
    }
}
