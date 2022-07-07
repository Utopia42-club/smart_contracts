// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./UnbcNft.sol";


contract Settings is AccessControl {

    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    string[] public defaultSettings = [
        "avatar"
    ];

    mapping(uint256 => mapping(string => string)) public settings;
    mapping(address => uint256) public userToken;

    address public nftAddress;

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "Settings: !Admin");
        _;
    }

    modifier userHasAccess(uint256 _tokenId) {
        require(UnbcNft(nftAddress).userHasAccessToken(msg.sender, _tokenId), 'Settings: !Authorized');
        _;
    }

    modifier userHasRegistered(uint256 _tokenId) {
        require(UnbcNft(nftAddress).userHasRegisteredToken(msg.sender, _tokenId), 'Settings: !Authorized');
        _;
    }

    modifier checkKeys (string[] calldata keys) {
        for (uint i = 0; i < keys.length; i++) {
            bool includeDefault;
            for (uint j = 0; j < defaultSettings.length; j++) {
                if (keccak256(abi.encodePacked(keys[i])) == keccak256(abi.encodePacked(defaultSettings[j]))) {
                    includeDefault = true;
                }
            }
            require(includeDefault, 'Settings: Invalid Input');
        }
        _;
    }

    constructor (address _nftAddress) {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
        nftAddress = _nftAddress;
    }

    function updateSettingsByBrigthId(
        uint256 _tokenId,
        string[] calldata keys,
        string[] calldata values
    ) public userHasAccess(_tokenId) checkKeys(keys) {
        require(keys.length == values.length, 'Settings: Invalid input length');
        for (uint i = 0; i < keys.length; i++) {
            settings[_tokenId][keys[i]] = values[i];
        }
        userToken[msg.sender] = _tokenId;

    }

    function updateSettings(
        uint256 _tokenId,
        string[] calldata keys,
        string[] calldata values
    ) public userHasRegistered(_tokenId) checkKeys(keys) {
        require(keys.length == values.length, 'Settings: Invalid input length');
        for (uint i = 0; i < keys.length; i++) {
            settings[_tokenId][keys[i]] = values[i];
        }
        userToken[msg.sender] = _tokenId;
    }

    function updateDefaultSettings(string[] memory _newDefaultSettings) public onlyAdmin {
        defaultSettings = _newDefaultSettings;
    }

    function getDeafaultSettings() public view returns(string[] memory) {
        return defaultSettings;
    }

    function userInfo(address _user) view public returns(string[] memory ) {
        string[] memory setts = new string[](defaultSettings.length);
        uint256 tokenId = userToken[_user];
        for (uint i = 0; i < defaultSettings.length; i++) {
            setts[i] = settings[tokenId][defaultSettings[i]];
        }
        return setts;
    }
}

