// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Utopia42Controller is AccessControl{

    bytes32 constant public UTOPIA42DAO_ROLE = keccak256("UTOPIA42DAO_ROLE");

    mapping(address => uint256) versesUnitLandsPrice;
    mapping(address => uint256) versesTransferLandFees;
    mapping(address => bool) public versesTransferLandFreeFee;
    mapping(address => bool) public versesFreeLand;
    mapping(address => bool) public conflictResolverWallets;

    address public DAOWallet;
    address public verseNFTOwner;
    address public DAOFundsWallet;
    uint256 public defaultUnitLandPrice = .0001 ether;
    uint256 public defaultTransferLandFee = .00001 ether;
    uint256 public landToNFTMinDelay;
    string public baseTokenURI = "https://nft-api.utopia42.club/";

    event UnitLandPriceSet(address verseAddress, uint256 price);
    event TransferLandFeeSet(address verseAddress, uint256 fee);
    event TransferLandFreeFeeSet(address verseAddress, bool free);
    event ConflictResolverSet(address wallet, bool active);
    event VerseFreeLandSet(address wallet, bool active);

    constructor (
        address _daoWallet,
        address _daoFundsWallet,
        address _verseNFTOwner
    ) {
        DAOWallet = _daoWallet;
        DAOFundsWallet = _daoFundsWallet;
        verseNFTOwner = _verseNFTOwner;
        _setupRole(DEFAULT_ADMIN_ROLE, _daoWallet);
        _setupRole(UTOPIA42DAO_ROLE, _daoWallet);
    }

    modifier onlyUtopia42DAO {
        require(hasRole(UTOPIA42DAO_ROLE, msg.sender), "!UTOPIA42DAO");
        _;
    }

    function setDAOWallet(address _wallet) public onlyUtopia42DAO {
        DAOWallet = _wallet;
    }

    function setVerseNFTOwner(address _wallet) public onlyUtopia42DAO {
        verseNFTOwner = _wallet;
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

    function setConflictResolverWallets(address _wallet, bool active) public onlyUtopia42DAO {
        conflictResolverWallets[_wallet] = active;
        emit ConflictResolverSet(_wallet, active);
    }

    function setUnitLandPriceForVerse(address _verseAddress, uint256 _price) public onlyUtopia42DAO {
        versesUnitLandsPrice[_verseAddress] = _price;
        emit UnitLandPriceSet(_verseAddress, _price);
    }

    function setTransferLandFeeForVerse(address _verseAddress, uint256 _fee) public onlyUtopia42DAO {
        versesTransferLandFees[_verseAddress] = _fee;
        emit TransferLandFeeSet(_verseAddress, _fee);
    }

    function setTransferLandFreeFeeForVerse(address _verseAddress, bool _free) public onlyUtopia42DAO {
        versesTransferLandFreeFee[_verseAddress] = _free;
        emit TransferLandFreeFeeSet(_verseAddress, _free);
    }

    function setVersesFreeLand(address _verseAddress, bool _free) public onlyUtopia42DAO {
        versesFreeLand[_verseAddress] = _free;
        emit VerseFreeLandSet(_verseAddress, _free);
    }

    function unitLandPrice(address _verseAddress) public view returns(uint256 _unitLandPrice) {
        if (versesFreeLand[_verseAddress]) {
            return _unitLandPrice;
        }
        _unitLandPrice = versesUnitLandsPrice[_verseAddress] == 0 ?
                         defaultUnitLandPrice :
                         versesUnitLandsPrice[_verseAddress];
    }

    function transferLandFee(address _verseAddress) public view returns(uint256 _transferLandPrice) {
        if (versesTransferLandFreeFee[_verseAddress]) {
            return _transferLandPrice;
        }
        _transferLandPrice = versesTransferLandFees[_verseAddress] == 0 ?
                             defaultTransferLandFee :
                             versesTransferLandFees[_verseAddress];
    }

    function adminWT(uint256 amount, address _to, address _tokenAddr) public onlyUtopia42DAO {
        require(_to != address(0));
        if(_tokenAddr == address(0)){
          payable(_to).transfer(amount);
        }else{
          IERC20(_tokenAddr).transfer(_to, amount);
        }
    }

}
