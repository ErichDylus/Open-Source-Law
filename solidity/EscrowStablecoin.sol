//SPDX-License-Identifier: MIT

pragma solidity 0.7.5;

/* IN PROCESS, INCOMPLETE - adapting ETHescrow for ERC20 stablecoins
**unaudited and for demonstration only, subject to all disclosures, licenses, and caveats of the open-source-law repo
**@dev create a simple smart escrow contract, with an ERC20 stablecoin as payment, expiration denominated in seconds, and option for dispute resolution with LexLocker
**intended to be deployed by buyer (as funds are placed in escrow upon deployment, and returned to deployer if expired)*/

interface LexLocker {
    function requestLockerResolution(address counterparty, address resolver, address token, uint256 sum, string calldata details, bool swiftResolver) external payable returns (uint256);
}

interface IERC20 { 
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool); 
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract EscrowStablecoin {
    
  //escrow struct to contain basic description of underlying deal, purchase price, seller (ultimate recipient of funds)
  struct InEscrow {
      string description;
      uint256 deposit;
      address payable seller;
  }
  
  InEscrow[] public escrows;
  address escrowAddress;
  address payable lexlocker = payable(0xD476595aa1737F5FdBfE9C8FEa17737679D9f89a); //LexLocker contract address
  address payable lexDAO = payable(0x01B92E2C0D06325089c6Fd53C98a214f5C75B2aC); //lexDAO address, used below as resolver 
  address payable buyer;
  address payable seller;
  address stablecoin;
  uint256 deposit;
  uint256 effectiveTime;
  uint256 expirationTime;
  uint256 public totalBalance;
  bool sellerApproved;
  bool buyerApproved;
  bool isDisputed;
  bool isExpired;
  bool isClosed;
  IERC20 public ierc20;
  string description;
  mapping(address => bool) public parties; //map whether an address is a party to the transaction for restricted() modifier 
  
  event DealDisputed(address indexed sender, bool isDisputed); //index dispute by sender, consider including token/resolver/other identifier
  event DealExpired(bool isExpired);
  event DealClosed(bool isClosed);
  
  modifier restricted() { 
    require(parties[msg.sender], "This may only be called by a party to the deal or the by escrow contract");
    _;
  }
  
  //deployer (buyer) initiates escrow with description, deposit amount in USD, address of stablecoin, seconds until expiry, and designate recipient seller
  //deployer must separately approve this contract address for the deposit amount (keep decimals in mind)
  constructor(string memory _description, uint256 _deposit, address payable _seller, address _stablecoin, uint256 _secsUntilExpiration) payable {
      require(_seller != msg.sender, "Designate different party as seller");
      buyer = payable(address(msg.sender));
      deposit = _deposit;
      escrowAddress = address(this);
      stablecoin = _stablecoin;
      ierc20 = IERC20(stablecoin);
      description = _description;
      seller = _seller;
      parties[msg.sender] = true;
      parties[_seller] = true;
      parties[escrowAddress] = true;
      effectiveTime = uint256(block.timestamp);
      expirationTime = effectiveTime + _secsUntilExpiration;
      approveParties();
  }
  
  //buyer may confirm seller's recipient address as extra security measure
  function designateSeller(address payable _seller) public restricted {
      require(_seller != seller, "Party already designated as seller");
      require(_seller != buyer, "Buyer cannot also be seller");
      require(!isExpired, "Too late to change seller");
      parties[_seller] = true;
      seller = _seller;
  }
  
  //approve seller to withdraw deposit amount at closing and buyer in case of termination (and therefore deposit return)
  function approveParties() public restricted returns (bool) {
      ierc20.allowance(escrowAddress, seller);
      ierc20.approve(seller, deposit);
      ierc20.approve(buyer, deposit);
      return true;
  } 
  
  //buyer deposits in escrowAddress
  function sendDeposit() public restricted returns(bool, uint256) {
      ierc20.transferFrom(buyer, escrowAddress, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
      
  }
  
  //return deposit to buyer
  function returnDeposit() internal returns(bool, uint256) {
      ierc20.transfer(buyer, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
  }
  
  //send deposit to seller
  function paySeller() internal returns(bool, uint256) {
      ierc20.transfer(seller, deposit);
      return (true, ierc20.balanceOf(escrowAddress));
  } 
  
  //create new escrow contract within master structure
  function sendNewEscrow(string memory _description, uint256 _deposit, address payable _seller) private restricted {
      InEscrow memory newRequest = InEscrow({
         description: _description,
         deposit: _deposit,
         seller: _seller
      });
      escrows.push(newRequest);
  }
  
  //check if expired, and if so, return balance to buyer
  function checkIfExpired() public returns(bool){
        if (expirationTime <= uint256(block.timestamp)) {
            isExpired = true;
            returnDeposit();
            emit DealExpired(isExpired);
        } else {
            isExpired = false;
        }
        return(isExpired);
    }
    
  // for seller to check if deposit is in escrow
  function checkEscrow() public restricted view returns(uint256) {
      return ierc20.balanceOf(escrowAddress);
  }
    
  // for early termination by either buyer or seller due to claimed breach of the other party, claiming party requests LexLocker resolution
  // deposit either returned to buyer or remitted to seller as payment or liquidated damages
  function disputeDeal(address _token, string calldata _details, bool _singleArbiter) public restricted returns(string memory){
      require(!isClosed && !isExpired, "Too late for early termination");
      ierc20.approve(lexlocker, deposit);
      if (msg.sender == seller) {
            LexLocker(lexlocker).requestLockerResolution(buyer, lexDAO, _token, deposit, _details, _singleArbiter);
            ierc20.transferFrom(escrowAddress, lexlocker, deposit);
            isDisputed = true;
            emit DealDisputed(seller, isDisputed);
            return("Seller has initiated LexLocker dispute resolution.");
        } else if (msg.sender == buyer) {
            LexLocker(lexlocker).requestLockerResolution(seller, lexDAO, _token, deposit, _details, _singleArbiter);
            ierc20.transferFrom(escrowAddress, lexlocker, deposit);
            isDisputed = true;
            emit DealDisputed(buyer, isDisputed);
            return("Buyer has initiated Lexlocker dispute resolution.");
        } else {
            return("You are neither buyer nor seller.");
        }
  }

  function readyToClose() public restricted returns(string memory){
         if (msg.sender == seller) {
            sellerApproved = true;
            return("Seller is ready to close.");
        } else if (msg.sender == buyer) {
            buyerApproved = true;
            return("Buyer is ready to close.");
        } else {
            return("You are neither buyer nor seller.");
        }
  }
    
  // check if both buyer and seller are ready to close and expiration has not been met; if so, close deal and pay seller
  function closeDeal() public returns(bool){
      require(sellerApproved && buyerApproved, "Parties are not ready to close.");
      if (expirationTime <= uint256(block.timestamp)) {
            isExpired = true;
            returnDeposit();
            emit DealExpired(isExpired);
        } else {
            isClosed = true;
            paySeller();
            emit DealClosed(isClosed);
        }
        return(isClosed);
  }
}
