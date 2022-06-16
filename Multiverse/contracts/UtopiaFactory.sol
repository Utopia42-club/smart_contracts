// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./Utopia.sol";
import "./UtopiaNFT.sol";

contract UtopiaFactory{

    mapping(address => address) public lands;
    mapping(address => address) public collections;
    event LandCreated(address owner, uint256 time, address landAddress, address collectionAddress);

    function createLand(address _owner) public returns(
        address land,
        address collection
    ){
        require(lands[_owner] == address(0), 'Already created a land');
        land = address(new Utopia(
            _owner
        ));
        lands[_owner] = land;
        collection = address(new UtopiaNFT(
            land
        ));
        collections[land] = collection;
        emit LandCreated(_owner, block.timestamp, land, collection);
    }
}
