//SPDX-License-Identifier: MIT

pragma solidity >=0.8.10;

/// FOR DEMONSTRATION ONLY, incomplete, unaudited, not recommended to be used for any purpose and 
/// provided with no warranty whatsoever pursuant to https://github.com/ErichDylus/Open-Source-Law/blob/main/LICENSE
/// @notice simple tax remitting contract to give IRS estimated quarterly tax, etc.; sends to immutable IRS wallet address 
 
interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

// contingent on factors such as jurisdiction and status of each msg.sender, but initially whole-number flat rate federal tax demonstration
// meant to be an abstract add-on to another contract which results in income taxable event when a dApp makes a transaction 
contract TaxPayment {
  
    address payable public immutable IRS;
    uint256 public immutable taxRate;
    mapping(address => uint256) taxPaymentNumber; // numbered tax payment for each msg.sender
    mapping(uint256 => mapping(address => uint256)) taxPaymentNumberAmount; // tax amount for a given msg.sender's taxPaymentNumber

    error InvalidRate();
    
    event TaxPaid(
        address indexed taxpayer, 
        uint256 indexed taxPaymentNumber, 
        uint256 timeOfPayment, 
        uint256 taxPaymentAmount, 
        address tokenContract
    );
    
    /// @param _IRSaddress IRS's designated address to receive taxes
    /// @param _taxRate percentage tax rate expressed as a nonzero uint < 1000 to allow for one decimal place. 50 = 5%, 5 = 0.5%, etc. 
    constructor(address _IRSaddress, uint256 _taxRate) payable {
        if (_taxRate == 0 || _taxRate >= 1000) revert InvalidRate();
        IRS = payable(_IRSaddress); 
        taxRate = _taxRate;
    }
    
    /// @notice msg.sender must first separately approve address(this) for _tokenAddress for at least _income amount
    /// @param _income received income amount by msg.sender in the applicable token corresponding to _tokenAddress
    /// @param _tokenAddress contract address of ERC20 token received
    /// @return taxes paid, tax payment number for this msg.sender
    function payTax(uint256 _income, address _tokenAddress) public returns(uint256, uint256) {
        //needs testing, but more gas-efficient than: uint256 _taxes = (_income*taxRate) / 1000;
        uint256 _taxes;
        uint256 _rate = taxRate;
        uint256 _denom = 1000; // corresponds to taxRate denomination
        assembly { 
            _taxes := div(mul(_income, _rate), _denom)
        }
        IERC20(_tokenAddress).transferFrom(msg.sender, IRS, _taxes);
	    unchecked { ++taxPaymentNumber[msg.sender]; } // will not overflow on human timelines
	    taxPaymentNumberAmount[_taxes][msg.sender] = taxPaymentNumber[msg.sender];
	    emit TaxPaid(
            msg.sender, 
            taxPaymentNumber[msg.sender], 
            block.timestamp, 
            _taxes, 
            _tokenAddress
        );
        return(_taxes, taxPaymentNumber[msg.sender]);
    }
}
