// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MRC721.sol";
import "./IBrightID.sol";
// import "./MRC721Metadata.sol";

contract UnbcNft is MRC721 {
    address public signer;
    bytes32 public app;
	uint256 public maxSupply = 4000;

    struct Verification {
        uint256 time;
        bool isVerified;
    }
    struct Nft {
        address[] ownerHistory;
        address currentOwner;
        bool nonTransferable;
    }
    mapping(address => Verification) public verifications;
    mapping(uint256 => Nft) public nfts;
    mapping(address => uint256) public uniqueOwner;
    mapping(address => uint256) public usersTokenRegistered;

	constructor(
        address _signer,
        bytes32 _app
    ) MRC721(
    	"UNBC NFT",
    	"UNBC",
        "http://127.0.0.1:5000/"
    ){
        signer = _signer;
        app = _app;
    	_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    	_setupRole(MINTER_ROLE, msg.sender);
    }

    function _beforeMint(
        address to,
        uint256 id
    ) internal virtual override {
    	require(totalSupply() <= maxSupply, "> maxSupply");
    }

    function setBrightId(
        uint256 _nftId,
        address[] memory addrs,
        uint timestamp,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public returns(bool) {
        //TODO
        //chech this condition
        // require(verifications[addrs[0]].time < timestamp, "Newer verification registered before");
        require(!verifications[addrs[0]].isVerified, "Registered before");

        bytes32 message = keccak256(abi.encodePacked(app, addrs, timestamp));
        address _signer = ecrecover(message, v, r, s);
        require(_signer == signer, "Not authorized");

        bool isOwner;
        for (uint i = 0; i < addrs.length; i++) {
            if (ownerOf(_nftId) == addrs[i]) {
                isOwner = true;
            }
            if (uniqueOwner[addrs[i]] > 0) {
                require(uniqueOwner[addrs[i]] == _nftId, 'Already registered another ID');
            }
        }
        require(isOwner, 'Only nft owner');

        verifications[addrs[0]].time = timestamp;
        verifications[addrs[0]].isVerified = true;
        for(uint i = 0; i < addrs.length; i++) {
            uint256 tokenRegistered = usersTokenRegistered[addrs[i]];
            if (tokenRegistered != 0) {
                nfts[tokenRegistered].nonTransferable = false;
                nfts[tokenRegistered].currentOwner = address(0);
            }
            delete usersTokenRegistered[addrs[i]];
            uniqueOwner[addrs[i]] = _nftId;
            if (i == 0) continue;
            verifications[addrs[i]].time = timestamp;
            verifications[addrs[i]].isVerified = false;
        }

        if (ownerOf(_nftId) != addrs[0]) {
            nfts[_nftId].nonTransferable = false;
            _transfer(ownerOf(_nftId), addrs[0], _nftId);
        }
        nfts[_nftId].nonTransferable = true;
        nfts[_nftId].currentOwner = addrs[0];
        nfts[_nftId].ownerHistory.push(addrs[0]);
        return true;
    }

    function registerToken(
        uint256 _tokenId
    ) public returns(bool){
        require(ownerOf(_tokenId) == tx.origin, 'UnbcNft: Only Token Owner');
        require(usersTokenRegistered[tx.origin] == 0 &&
                uniqueOwner[tx.origin] == 0,
                'UnbcNft: Already registered another token'
                );
        nfts[_tokenId].nonTransferable = true;
        nfts[_tokenId].currentOwner = tx.origin;
        nfts[_tokenId].ownerHistory.push(tx.origin);
        usersTokenRegistered[tx.origin] = _tokenId;
        return true;
    }

    function nftOwnerHistory(uint256 _tokenId) view public returns(address[] memory) {
        address[] memory owners = new address[](nfts[_tokenId].ownerHistory.length);
        for (uint i = 0; i < nfts[_tokenId].ownerHistory.length; i++) {
            owners[i] = nfts[_tokenId].ownerHistory[i];
        }
        return owners;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        super._beforeTokenTransfer(from, to, tokenId);
        require(!nfts[tokenId].nonTransferable, 'This tokenId is not transferable');
    }

    function userHasAccessToken (
        address _user,
        uint256 _tokenId
    ) public view returns(bool) {
        if (
            verifications[_user].isVerified &&
            uniqueOwner[_user] == _tokenId
           ) {
            return true;
        } else {
            return false;
        }
    }

    function userHasRegisteredToken (
        address _user,
        uint256 _tokenId
    ) public view returns(bool) {
        return usersTokenRegistered[_user] == _tokenId;
    }

}
