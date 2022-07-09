// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IMRC721 is IERC721{

    function mint(address to, uint256 id) external;

    function burn(uint256 tokenId) external;

    function tokensOfOwner(address _owner) external view returns(uint256[] memory);

    function totalSupply() external view returns (uint256);

    function setBrightId(uint256 _nftId, address[] memory addrs, uint timestamp, uint8 v, bytes32 r, bytes32 s) external returns(bool);

    function registerToken(uint256 _nftId) external returns(bool);
}
