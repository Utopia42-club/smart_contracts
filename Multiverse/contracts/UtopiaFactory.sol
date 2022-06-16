// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "./Utopia.sol";

contract UtopiaFactory{

    mapping(address => address) public utopia;
    event LandCreated(address owner, uint256 time, address landAddress);

    function createLand(address _owner) public returns(address){
        require(utopia[_owner] == address(0), 'Already created a land');
        address land = address(new Utopia(
            _owner
        ));
        utopia[_owner] = land;
        emit LandCreated(_owner, block.timestamp, land);
        return land;
    }
}
