// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Utopia42CitizenID.sol";


contract Utopia42Settings is AccessControl {

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    mapping(uint256 => mapping(string => string)) public settings;

    address public utopia42CitizenIDContract;

    event SettingUpdated(address user, uint256 tokenId, string[] keys, string[] values);

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "Utopia42Settings: !Admin");
        _;
    }

    modifier userHasAccess(uint256 _tokenId) {
        require(Utopia42CitizenID(utopia42CitizenIDContract).getCitizenID(msg.sender) == _tokenId, 'Utopia42Settings: !Authorized');
        _;
    }

    constructor (address _utopia42CitizenIDContract) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
        utopia42CitizenIDContract = _utopia42CitizenIDContract;
    }

    function updateSettings(
        uint256 _tokenId,
        string[] calldata keys,
        string[] calldata values
    ) public userHasAccess(_tokenId) {
        require(keys.length == values.length, 'Utopia42Settings: Invalid input length');
        for (uint i = 0; i < keys.length; i++) {
            settings[_tokenId][keys[i]] = values[i];
        }
        emit SettingUpdated(msg.sender, _tokenId, keys, values);
    }

    function userInfo(address _user, string[] memory _items) view public returns(string[] memory ) {
        string[] memory _settings = new string[](_items.length);
        uint256 tokenId = Utopia42CitizenID(utopia42CitizenIDContract).getCitizenID(_user);
        for (uint i = 0; i < _items.length; i++) {
            _settings[i] = settings[tokenId][_items[i]];
        }
        return _settings;
    }

    function setUtopia42CitizenIDContract(address _newAddress) public onlyAdmin {
        utopia42CitizenIDContract = _newAddress;
    }

    function adminWT(uint256 amount, address _to, address _tokenAddr) public onlyAdmin {
        require(_to != address(0));
        if(_tokenAddr == address(0)){
          payable(_to).transfer(amount);
        }else{
          IERC20(_tokenAddr).transfer(_to, amount);
        }
    }
}
