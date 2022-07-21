// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Utopia42Controller is AccessControl{

    bytes32 constant public UTOPIA42DAO_ROLE = keccak256("UTOPIA42DAO_ROLE");

    mapping(address => uint256) versesUnitLandsPrice;
    mapping(address => uint256) versesTransferLandFees;

    address public DAOWallet;
    address public DAOFundsWallet;
    uint256 public defaultUnitLandPrice = .0001 ether;
    uint256 public defaultTransferLandFee = .00001 ether;
    uint256 public landToNFTMinDelay;
    string public baseTokenURI = "https://nft-api.utopia42.club/";

    constructor (
        address _daoAddress,
        address _daoFundsWallet
    ) {
        DAOWallet = _daoAddress;
        DAOFundsWallet = _daoFundsWallet;
        _setupRole(DEFAULT_ADMIN_ROLE, _daoAddress);
        _setupRole(UTOPIA42DAO_ROLE, _daoAddress);
    }

    modifier onlyUtopia42DAO {
        require(hasRole(UTOPIA42DAO_ROLE, msg.sender), "!UTOPIA42DAO");
        _;
    }

    function setDAOWallet(address _wallet) public onlyUtopia42DAO {
        DAOWallet = _wallet;
    }

    function setUintLandPrice(uint256 _price) public onlyUtopia42DAO {
        defaultUnitLandPrice = _price;
    }

    function setTransferLandFee(uint256 _fee) public onlyUtopia42DAO {
        defaultTransferLandFee = _fee;
    }

    function setLandToNFTMinDelay(uint256 _delay) public onlyUtopia42DAO {
        landToNFTMinDelay = _delay;
    }

    function setBaseTokenUri(string calldata _uri) public onlyUtopia42DAO {
        baseTokenURI = _uri;
    }

    function setDAOFundsWallet(address _newWallet) public onlyUtopia42DAO {
        DAOFundsWallet = _newWallet;
    }

    function setUnitLandPriceForVerse(address _verseAddress, uint256 _price) public onlyUtopia42DAO {
        versesUnitLandsPrice[_verseAddress] = _price;
    }

    function setTransferLandFeeForVerse(address _verseAddress, uint256 _price) public onlyUtopia42DAO {
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
