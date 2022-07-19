// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Utopia42Controller is AccessControl{

    bytes32 constant public ADMIN_ROLE = keccak256("ADMIN ROLE");

    mapping(address => uint256) versesUnitLandsPrice;
    mapping(address => uint256) versesTransferLandFees;

    address public DAOWallet;
    uint256 public defaultUnitLandPrice = .0001 ether;
    uint256 public defaultTransferLandFee = .00001 ether;
    string public baseTokenURI = "https://nft-api.utopia42.club/";

    constructor (
        address _daoAddress
    ) {
        DAOWallet = _daoAddress;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
    }

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "!Admin");
        _;
    }

    function setDAOWallet(address _wallet) public onlyAdmin {
        DAOWallet = payable(_wallet);
    }

    function setUintLandPrice(uint256 _price) public onlyAdmin {
        defaultUnitLandPrice = _price;
    }

    function setTransferLandFee(uint256 _fee) public onlyAdmin {
        defaultTransferLandFee = _fee;
    }

    function setBaseTokenUri(string calldata _uri) public onlyAdmin {
        baseTokenURI = _uri;
    }

    function setUnitLandPriceForVerse(address _verseAddress, uint256 _price) public onlyAdmin {
        versesUnitLandsPrice[_verseAddress] = _price;
    }

    function setTransferLandFeeForVerse(address _verseAddress, uint256 _price) public onlyAdmin {
        versesTransferLandFees[_verseAddress] = _price;
    }

    function unitLandPrice(address _verseAddress) public view returns(uint256 _unitLandPrice) {
        _unitLandPrice = versesUnitLandsPrice[_verseAddress] == 0 ?
                         defaultUnitLandPrice :
                         versesUnitLandsPrice[_verseAddress];
    }

    function transferLandFee(address _verseAddress) public view returns(uint256 _transferLandPrice) {
        _transferLandPrice = versesTransferLandFees[_verseAddress] == 0 ?
                             defaultTransferLandFee :
                             versesTransferLandFees[_verseAddress];
    }

}
