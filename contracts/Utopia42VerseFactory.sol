// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Utopia42Verse.sol";
import "./interfaces/IUtopia42CollectionFactory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Utopia42Controller.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";


contract Utopia42VerseFactory is AccessControl {

    bytes32 constant public ADMIN_ROLE = keccak256("ADMIN_ROLE");
    address public collectionFactory;
    uint256 public verseCreationFee = 100 ether;
    address public controllerAddress;
    bool public isPublic = false;

    event VerseCreated(address owner, address creator, uint256 time, address verseAddress, address collectionAddress);

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "!Admin");
        _;
    }

    constructor(
        address _controller
    ){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
        controllerAddress = _controller;
    }


    function createVerse(
        address _owner,
        string calldata verseName,
        bool publicAssignEnabled
        ) public payable returns(
        address verse
    ){
        require(isPublic || hasRole(ADMIN_ROLE, msg.sender),
            "not public yet"
        );
        require(msg.value >= verseCreationFee, 'Insufficient Value');
        payable(Utopia42Controller(controllerAddress).DAOFundsWallet()).transfer(msg.value);

        verse = address(new Utopia42Verse(
            _owner,
            controllerAddress,
            publicAssignEnabled,
            verseName
        ));
        address collection = IUtopia42CollectionFactory(collectionFactory).createCollection(
            _owner, verse, msg.sender, controllerAddress, verseName
        );
        Utopia42Verse(verse).adminSetNFTContract(collection);
        emit VerseCreated(_owner, msg.sender, block.timestamp, verse, collection);
    }

    function setVerseCreationFee(uint256 _fee) public  onlyAdmin{
        verseCreationFee = _fee;
    }

    function setCollectionFactoryAddress(address _newAddress) public onlyAdmin {
        collectionFactory = _newAddress;
    }

    function setControllerAddress(address _newAddress) public onlyAdmin {
        controllerAddress = _newAddress;
    }

    function setIsPublic(bool _isPublic) public onlyAdmin {
        isPublic = _isPublic;
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
