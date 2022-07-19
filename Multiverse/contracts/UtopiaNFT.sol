// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./MRC721.sol";
import "./Utopia42Controller.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IUtopiaVerse42{
    function transferNFTLand(uint256 tokenId, address to) external;
}

// TODO: Let's use MRC721
//Done

// TODO: Who is owner of the contract? Utopia or verse owner?
// owner should be utopia admins. Because we want to set 
// fees on opensea
contract UtopiaNFT is MRC721, Ownable{

    //TODO: call this from controller
    //?
    address public verseContract;
    address public controllerAddress;
    bytes32 constant public Utopia42DAO_ROLE = keccak256("Utopia42DAO_ROLE");
    // TODO: Let's call this Utopia42Verse
    // Done
    // Utopia42Verse ---> verse contract
    // Utopia42DAO ---> Utopia DAO wallet(admins)
    modifier onlyUtopia42DAO(){
        require(hasRole(Utopia42DAO_ROLE, msg.sender), "!Utopia42DAO");
        _;
    }


    constructor (
        address _verseAddress,
        address _owner,
        address _controller,
        string memory _verseName
        //TODO: Name should be different for each verse
        // Done
        ) MRC721(
            string(abi.encodePacked("Utopia42 Lands ", _verseName)),
            "UL42",
            Utopia42Controller(_controller).baseTokenURI()
            ) {
        controllerAddress = _controller;
        _setupRole(DEFAULT_ADMIN_ROLE, Utopia42Controller(controllerAddress).DAOWallet());
        _setupRole(Utopia42DAO_ROLE, Utopia42Controller(controllerAddress).DAOWallet());
        transferOwnership(Utopia42Controller(controllerAddress).DAOWallet());
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
            IUtopiaVerse42(verseContract).transferNFTLand(tokenId, to);
        }
    }

    function updateUtopiaContract(address _addr) public onlyUtopia42DAO {
        verseContract = _addr;
    }

    // TODO: base url should be _baseTokenURI + verseContract
    //Done
    function _baseURI() internal view virtual override returns (string memory) {
        return string(abi.encodePacked(
                Utopia42Controller(controllerAddress).baseTokenURI(),
                Strings(address(this))
            )
        );
    }

}
