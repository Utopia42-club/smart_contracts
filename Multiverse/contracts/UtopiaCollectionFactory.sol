// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


import "./UtopiaNFT.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract UtopiaCollectionFactory is AccessControl{

    bytes32 constant public ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 constant public UTOPIA_FACTORY_ROLE = keccak256("UTOPIA_FACTORY_ROLE");
    address public utopiaFactoryAddress;
    address public controllerAddress;

    event CollectionCreated(address owner, address creator, uint256 time, address verseAddress, address collectionAddress);

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "!admin");
        _;
    }

    modifier onlyUtopia {
        require(hasRole(UTOPIA_FACTORY_ROLE, msg.sender), "!admin");
        _;
    }

    constructor(
        address _utopiaFactory,
        address _controllerAddress
    ){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
        _setupRole(UTOPIA_FACTORY_ROLE, _utopiaFactory);
        utopiaFactoryAddress = _utopiaFactory;
    }


    function createCollection (
        address _owner,
        address _verse,
        address _creator,
        address _controller,
        string memory _verseName
        ) public onlyUtopia returns(
        address collection
    ){

        collection = address(new UtopiaNFT(
            _verse,
            _owner,
            _controller,
            _verseName
        ));
        emit CollectionCreated(_owner, _creator, block.timestamp, _verse, collection);
    }

    function setUtopiaFactoryAddress(address _newAddress) public onlyAdmin {
        utopiaFactoryAddress = _newAddress;
        _setupRole(UTOPIA_FACTORY_ROLE, _newAddress);
    }

}
