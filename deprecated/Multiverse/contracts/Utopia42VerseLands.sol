// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./MRC721.sol";
import "./Utopia42Controller.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IUtopia42Verse{
    function transferNFTLand(uint256 tokenId, address to) external;
}


contract Utopia42VerseLands is MRC721, Ownable{

    address public verseContract;
    address public controllerAddress;
    bytes32 constant public Utopia42DAO_ROLE = keccak256("Utopia42DAO_ROLE");

    modifier onlyUtopia42DAO(){
        require(msg.sender == Utopia42Controller(controllerAddress).DAOWallet(), "!Utopia42DAO");
        _;
    }

    constructor (
        address _verseAddress,
        address _controller,
        string memory _verseName
        ) MRC721(
            string(abi.encodePacked("Utopia42 Lands ", _verseName)),
            "UL42",
            Utopia42Controller(_controller).baseTokenURI()
            ) {
        controllerAddress = _controller;
        _setupRole(DEFAULT_ADMIN_ROLE, Utopia42Controller(controllerAddress).DAOWallet());
        _setupRole(Utopia42DAO_ROLE, Utopia42Controller(controllerAddress).DAOWallet());
        transferOwnership(Utopia42Controller(controllerAddress).verseNFTOwner());
    	_setupRole(MINTER_ROLE, _verseAddress);
    	_setupRole(BURNER_ROLE, _verseAddress);
        verseContract = _verseAddress;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from != address(0) && to != address(0)) {
            // transfer land ownership on Utopia
            IUtopia42Verse(verseContract).transferNFTLand(tokenId, to);
        }
    }

    function updateUtopiaContract(address _addr) public onlyUtopia42DAO {
        verseContract = _addr;
    }

    function setControllerAddress(address _addr) public onlyUtopia42DAO {
        controllerAddress = _addr;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        uint256 chainID;
        assembly {
            chainID := chainid()
        }
        return string(abi.encodePacked(
                Utopia42Controller(controllerAddress).baseTokenURI(),
                Strings.toString(chainID),
                "/",
                Strings.toHexString(uint160(verseContract), 20),
                "/"
            )
        );
    }

}
