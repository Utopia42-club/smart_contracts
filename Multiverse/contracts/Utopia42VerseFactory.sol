// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Utopia42Verse.sol";
import "./IUtopiaCollectionFactory.sol";
import "./Utopia42Controller.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

//TODO: rename to Utopia42VerseFactory
// and rename Utopia.sol to Utopia42Verse
contract Utopia42VerseFactory is AccessControl {

    bytes32 constant public ADMIN_ROLE = keccak256("ADMIN_ROLE");
    address public collectionFactory;

    uint256 public verseCreationFee = 0.001 ether;
    address public controllerAddress;


    // TODO: add admin setter function
    //Done
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

        verse = address(new Utopia42Verse(
            _owner,
            controllerAddress,
            publicAssignEnabled,
            verseName
        ));
        address collection = IUtopiaCollectionFactory(collectionFactory).createCollection(
            _owner, verse, msg.sender, controllerAddress, verseName
        );
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
}
