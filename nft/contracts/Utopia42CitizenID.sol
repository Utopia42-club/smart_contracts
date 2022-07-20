// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MRC721.sol";
import "./MRC721Metadata.sol";

contract Utopia42CitizenID is MRC721{
    bytes32 constant public ADMIN_ROLE = keccak256("ADMIN ROLE");
    address public signer;
    bytes32 public app;

    struct NFTParam {
        uint256 mintTime;
        bool isVerified;
        uint256 verifyTime;
    }

    mapping(uint256 => NFTParam) public params;


    mapping(address => uint256) public brightIDAddrs;
    mapping(address => bool) public citizenIDTransferWhitelist;

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "!Only Admin");
        _;
    }

    constructor(
        address _signer,
        bytes32 _app
    ) MRC721(
        "Utopia42 Citizen ID",
        "U42ID",
        "https://citizenid-api.utopia42.club/"
    ){
        signer = _signer;
        app = _app;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _setupRole(ADMIN_ROLE, msg.sender);
        _setupRole(MINTER_ROLE, msg.sender);
        citizenIDTransferWhitelist[address(0)] = true;
    }

    function _beforeMint(
        address to,
        uint256 id
    ) internal virtual override {
        require(id > 0, 'Utopia42CitizenID: id is 0');
        // Each wallet can mint just one ID
        require(getCitizenID(to) == 0, "Utopia42CitizenID: duplicate ID");

        params[id].mintTime = block.timestamp;
    }

    function setBrightId(
        uint256 _nftId,
        address[] memory addrs,
        uint timestamp,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public returns(bool) {
        require(
            brightIDAddrs[addrs[0]] == 0 || // do not have any ID yet
            (
                brightIDAddrs[addrs[0]] == _nftId &&
                !params[_nftId].isVerified
            ), // has an ID but not verified yet
            "Already registered"
        );

        bytes32 message = keccak256(abi.encodePacked(app, addrs, timestamp));
        address _signer = ecrecover(message, v, r, s);
        require(_signer == signer, "Not authorized");

        bool isOwner;
        for (uint i = 0; i < addrs.length; i++) {
            if (ownerOf(_nftId) == addrs[i]) {
                isOwner = true;
            }
            require(
                brightIDAddrs[addrs[i]] == 0 ||
                brightIDAddrs[addrs[i]] == _nftId,
                'Already registered another ID.'
            );
        }
        require(isOwner, '!owner');


        if(ownerOf(_nftId) != addrs[0]) {
            _transfer(ownerOf(_nftId), addrs[0], _nftId);
        }

        if(!params[_nftId].isVerified){
            params[_nftId].isVerified = true;
            params[_nftId].verifyTime = block.timestamp;
        }

        for(uint i = 0; i < addrs.length; i++) {
            brightIDAddrs[addrs[i]] = _nftId;
        }

        return true;
    }

    function getCitizenID(address _user) public view returns(uint256 citizenId){
        if(brightIDAddrs[_user] != 0){
            return brightIDAddrs[_user];
        }
        uint256[] memory ids = super.tokensOfOwner(_user);
        if(ids.length > 0){
            return ids[0];
        }
        return 0;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override {
        require(
            !params[tokenId].isVerified ||
            brightIDAddrs[to] != tokenId ||
            citizenIDTransferWhitelist[to],
            'Not transferable'
        );
        require(
            getCitizenID(to) == 0,
            "To alreay has an ID"
        );
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function setCitizenIDTransferWhitelist(address _user, bool _inWhitelist) public onlyAdmin {
        citizenIDTransferWhitelist[_user] = _inWhitelist;
    }

}
