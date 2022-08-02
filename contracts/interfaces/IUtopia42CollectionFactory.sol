// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


interface IUtopia42CollectionFactory {
    function createCollection (
        address _owner,
        address _verse,
        address _creator,
        address _controller,
        string memory _verseName
        ) external returns(
        address collection
    );
}
