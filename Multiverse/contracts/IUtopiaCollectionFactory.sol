// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


interface IUtopiaCollectionFactory {
    function createCollection (
        address _owner,
        address _verse,
        address _creator
        ) external returns(
        address collection
    );
}
