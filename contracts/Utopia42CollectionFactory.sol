// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


import "./Utopia42VerseLands.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Utopia42CollectionFactory is AccessControl{

    bytes32 constant public ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 constant public UTOPIA_FACTORY_ROLE = keccak256("UTOPIA_FACTORY_ROLE");
    address public utopia42VerseFactoryAddress;

    event CollectionCreated(address owner, address creator, uint256 time, address verseAddress, address collectionAddress);

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "!admin");
        _;
    }

    modifier onlyUtopia {
        require(hasRole(UTOPIA_FACTORY_ROLE, msg.sender), "!UTOPIA_VERSE_FACTORY");
        _;
    }

    constructor(
        address _utopiaFactory
    ){
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
        _setupRole(UTOPIA_FACTORY_ROLE, _utopiaFactory);
        utopia42VerseFactoryAddress = _utopiaFactory;
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

        collection = address(new Utopia42VerseLands(
            _verse,
            _controller,
            _verseName
        ));
        emit CollectionCreated(_owner, _creator, block.timestamp, _verse, collection);
    }

    function setUtopiaFactoryAddress(address _newAddress) public onlyAdmin {
        utopia42VerseFactoryAddress = _newAddress;
        _setupRole(UTOPIA_FACTORY_ROLE, _newAddress);
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
