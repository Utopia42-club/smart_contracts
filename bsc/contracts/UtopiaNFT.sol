// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

interface IUtopia{
    function transferNFTLand(uint256 tokenId, address to) external;
}

contract UtopiaNFT is ERC721Enumerable, Ownable{
    string public _baseTokenURI = "https://nft-api.utopia42.club/";
    address public utopiaContract;

    modifier onlyUtopia(){
        require(msg.sender == utopiaContract, "!utopia");
        _;
    }

    constructor(address _utopia) ERC721("Utopia42 Lands", "UL42"){
        utopiaContract = _utopia;
    }


    function mint(address to, uint256 id) external onlyUtopia{
        _mint(to, id);
    }

    function burn(uint256 id) external onlyUtopia{
        _burn(id);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from != address(0) && to != address(0)) {
            // transfer land ownership on Utopia
            IUtopia(utopiaContract).transferNFTLand(tokenId, to);
        }
    }

    function updateUtopiaContract(address _addr) public onlyOwner{
        utopiaContract = _addr;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }
}
