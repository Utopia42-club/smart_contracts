// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract Utopia42Controller is AccessControl{

    bytes32 constant public ADMIN_ROLE = keccak256("ADMIN ROLE");

    address public DAOWallet;
    uint256 public unitLandPrice = .0001 ether;
    uint256 public transferLandFee = .00001 ether;
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
        unitLandPrice = _price;
    }

    function setTransferLandFee(uint256 _fee) public onlyAdmin {
        transferLandFee = _fee;
    }

    function setBaseTokenUri(string calldata _uri) public onlyAdmin {
        baseTokenURI = _uri;
    }

}
