// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Utopia42CitizenID.sol";


// TODO: rename to Utopia42Settings
contract Settings is AccessControl {

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    mapping(uint256 => mapping(string => string)) public settings;

    address public utopia42CitizenIDContract;

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "Settings: !Admin");
        _;
    }

    modifier userHasAccess(uint256 _tokenId) {
        require(Utopia42CitizenID(utopia42CitizenIDContract).getCitizenID(msg.sender) == _tokenId, 'Settings: !Authorized');
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
        require(keys.length == values.length, 'Settings: Invalid input length');
        for (uint i = 0; i < keys.length; i++) {
            settings[_tokenId][keys[i]] = values[i];
        }
    }

    function userInfo(address _user, string[] memory _items) view public returns(string[] memory ) {
        string[] memory _settings = new string[](_items.length);
        uint256 tokenId = Utopia42CitizenID(utopia42CitizenIDContract).getCitizenID(_user);
        for (uint i = 0; i < _items.length; i++) {
            _settings[i] = settings[tokenId][_items[i]];
        }
        return _settings;
    }
}
