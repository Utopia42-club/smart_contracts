// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Utopia.sol";
import "./IUtopiaCollectionFactory.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract UtopiaFactory is AccessControl {

    bytes32 constant public ADMIN_ROLE = keccak256("ADMIN_ROLE");
    address public collectionFactory;

    uint256 verseCreationFee = .001 ether;


    event VerseCreated(address owner, address creator, uint256 time, address verseAddress, address collectionAddress);

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "!Admin");
        _;
    }

    constructor(){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
    }


    function createVerse(address _owner) public payable returns(
        address verse
    ){
        require(msg.value >= verseCreationFee, 'Insufficient Value');
        verse = address(new Utopia(
            _owner
        ));
        address collection = IUtopiaCollectionFactory(collectionFactory).createCollection(_owner, verse, msg.sender);
        emit VerseCreated(_owner, msg.sender, block.timestamp, verse, collection);
    }

    function setVerseCreationFee(uint256 _fee) public  onlyAdmin{
        verseCreationFee = _fee;
    }

    function setCollectionFactoryAddress(address _newAddress) public onlyAdmin {
        collectionFactory = _newAddress;
    }

}
