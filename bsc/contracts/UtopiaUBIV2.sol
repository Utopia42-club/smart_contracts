pragma solidity ^0.5.15;

interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address account) external view returns (uint);
    function transfer(address recipient, uint amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Context {
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint;

    mapping (address => uint) private _balances;

    mapping (address => mapping (address => uint)) private _allowances;

    uint private _totalSupply;
    function totalSupply() public view returns (uint) {
        return _totalSupply;
    }
    function balanceOf(address account) public view returns (uint) {
        return _balances[account];
    }
    function transfer(address recipient, uint amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view returns (uint) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }
    function increaseAllowance(address spender, uint addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
    function _transfer(address sender, address recipient, uint amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }
    function _mint(address account, uint amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }
    function _burn(address account, uint amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }
    function _approve(address owner, address spender, uint amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor (string memory name, string memory symbol, uint8 decimals) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }
    function name() public view returns (string memory) {
        return _name;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

library SafeMath {
    function add(uint a, uint b) internal pure returns (uint) {
        uint c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint a, uint b) internal pure returns (uint) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        require(b <= a, errorMessage);
        uint c = a - b;

        return c;
    }
    function mul(uint a, uint b) internal pure returns (uint) {
        if (a == 0) {
            return 0;
        }

        uint c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }
    function div(uint a, uint b) internal pure returns (uint) {
        return div(a, b, "SafeMath: division by zero");
    }
    function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint c = a / b;

        return c;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

library SafeERC20 {
    using SafeMath for uint;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
        callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    function safeApprove(IERC20 token, address spender, uint value) internal {
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }
    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}


contract UtopiaUBIV2 is ERC20, ERC20Detailed{
    using SafeMath for uint256;

    // wallet => join time
    mapping(address => uint256) public users;
    mapping(address => uint256) public lastClaimed;

    mapping(address => bool) public admins;

    uint256 public coinsPerDay = 10 ether;
    uint256 public userInitialCoins = 1000 ether;
    uint256 public utopiaDAOInitialCoins = 1000000000 ether;

    uint256 public utopiaDAOLastPaidTime = 0;

    address public utopiaDAOFinance = 0x22fd697B06Fee6F5c5Df5cdd4283BD45cc73B056;

    
    // x percent of each withdraw 
    uint8 public utopiaDAOPercent = 12;    

    uint256 public usersCount = 0;

    bool public settingsLocked = false;

    uint256 public withdrawedAmountDAO = 0;

    constructor() ERC20Detailed("Utopia UBI", "UNBC", 18) public{
        admins[msg.sender] = true;
        // DAO initial coins
        withdrawDAO();        
    }
    
    modifier isAdmin(){
        require(admins[msg.sender]);
        _;
    }

    modifier notLocked(){
        require(!settingsLocked);
        _;
    }


    function() payable external{
        require(false, "ETH not accepted.");
    }

    function addUser(address _user) isAdmin public{
        required(users[_user] == 0, 'Duplicate User');
        withdrawDAO();

        users[_user] = now;
        usersCount += 1;
        _mint(_user, userInitialCoins);
        lastClaimed[_user] = now;
    }

    function addAdmin(address _admin) isAdmin public{
        admins[_admin] = true;
    }

    function deleteAdmin(address _admin) isAdmin public{
        admins[_admin] = false;
    }

    function pendingAmount(address _wallet) view public returns(uint256){
        if(users[_wallet]==0 || lastClaimed[_wallet]==0){
            return 0;
        }
        uint256 ndays = now.sub(
            lastClaimed[_wallet]
        ).div(1 days);

        return ndays.mul(coinsPerDay);
    }

    function pendingAmountDAO() view public returns(uint256){
        uint256 ndays = now.sub(
            utopiaDAOLastPaidTime
        ).div(1 days);
        return ndays.mul(coinsPerDay).mul(
            usersCount
        ).mul(utopiaDAOPercent).div(100);
    }

    function withdrawDAO() public{
        uint256 amount = utopiaDAOLastPaidTime == 0 ?
            utopiaDAOInitialCoins : pendingAmountDAO();
        if(amount <= 0){
            return;
        }
        // mint to contract address
        _mint(utopiaDAOFinance, amount);
        withdrawedAmountDAO = withdrawedAmountDAO.add(amount);

        // update last paid time
        utopiaDAOLastPaidTime = now;
    }

    function _withdrawFor(address user) private{
        uint256 amount = pendingAmount(user);
        if(amount > 0){
            _mint(user, amount);
            lastClaimed[user] = now;
        }
    }

    function transfer(address recipient, uint amount) public returns (bool){
        _withdrawFor(recipient);
        _withdrawFor(msg.sender);
        return ERC20.transfer(recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint amount) public returns (bool){
        _withdrawFor(sender);
        _withdrawFor(recipient);
        return ERC20.transferFrom(sender, recipient, amount);   
    }

    function balanceOf(address account) public view returns (uint) {
        return ERC20.balanceOf(account).add(pendingAmount(account));
    }

    function setCoinsPerDay(uint256 _coinsPerDay) isAdmin notLocked public{
        coinsPerDay = _coinsPerDay;
    }

    function setUtopiaDAOFinance(address _addr) isAdmin notLocked public{
        utopiaDAOFinance = _addr;
    }

    function setUserInitialCoins(uint256 _userInitialCoins) isAdmin notLocked public{
        userInitialCoins = _userInitialCoins;
    }

    function setUtopiaDAOPercent(uint8 _percent) isAdmin notLocked public{
        utopiaDAOPercent = _percent;
    }

    function lockSettings() isAdmin notLocked public{
        settingsLocked = true;
    }
}
