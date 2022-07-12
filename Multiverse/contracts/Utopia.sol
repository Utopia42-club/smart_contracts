// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/access/AccessControl.sol";
import '@openzeppelin/contracts/utils/cryptography/ECDSA.sol';

interface IUtpoiaNFT{
  function burn(uint256 nftId) external;
  function mint(address sender, uint256 nftId) external;
}

contract Utopia is AccessControl{
    using ECDSA for bytes32;

    bytes32 constant public ADMIN_ROLE = keccak256("ADMIN ROLE");
    bytes32 constant public NFT_ROLE = keccak256("NFT ROLE");
    bytes32 constant public BURN_ROLE = keccak256("BURN ROLE");
    bytes32 constant public CONFLICT_ROLE = keccak256("CONFLICT ROLE");

    struct Land{
        uint256 id; // unique ID
        int256 x1;
        int256 x2;
        int256 y1;
        int256 y2;
        uint256 time;
        string hash;
        bool isNFT;
        address owner;
        uint256 ownerIndex; // index of land on ownerLands
    }

    mapping(address => uint256[]) public ownerLands;

    //landId => Land
    mapping(uint256 => Land) public lands;

    bool public publicAssignEnabled = true;
    bool public assignLandWithoutSigEnabled = false;
    bool public landToNFTEnabled = true;

    // all funds goes to the DAO wallet and will be managed 
    // by the DAO
    address payable public DAOWallet = payable(msg.sender);

    uint256 public unitLandPrice = 0.0001 ether;

    uint256 public lastLandId = 0;

    // land owners can convert lands to NFTs after
    // some time.
    // It will allow us to find and resolve the conflicts
    uint256 public landToNFTMinDelay = 0;

    address public nftContract;

    event Burn(uint256 landId);
    event Assign(uint256 landId, int256 x1,
        int256 x2, int256 y1, int256 y2, address owner, string hash);
    event LandUpdate(uint256 landId, string hash);
    event LandTransfer(uint256 landId, address from, address to);

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "!admin");
        _;
    }

    modifier onlyNFT {
        require(hasRole(NFT_ROLE, msg.sender), "!nft");
        _;
    }

    modifier onlyBurner {
        require(hasRole(BURN_ROLE, msg.sender), "!burn");
        _;
    }

    modifier isPublic(){
        require(publicAssignEnabled, "!public");
        _;
    }

    constructor(address _owner){
        _setupRole(DEFAULT_ADMIN_ROLE, _owner);
        _setupRole(ADMIN_ROLE, _owner);
    }


    function updateLand(string memory hash, uint256 landId) public returns (bool){
        require(lands[landId].owner == msg.sender, "!owner");
        require(!lands[landId].isNFT, "isNFT");
        lands[landId].hash = hash;

        emit LandUpdate(landId, hash);
        return true;
    }

    function transferLand(uint256 landId, address _to) public{
        require(lands[landId].owner == msg.sender, "!owner");
        transferLandInternal(landId, _to, msg.sender);
    }

    function transferNFTLand(uint256 landId, address _to) public onlyNFT{
        require(lands[landId].isNFT, "!isNFT");
        transferLandInternal(landId, _to, lands[landId].owner);
    }

    function burnLand(uint256 landId) onlyBurner public{
        burnLandInternal(landId);
    }

    function burnLandInternal(uint256 landId) private{
        lands[landId].x1 = 0;
        lands[landId].x2 = 0;
        lands[landId].y1 = 0;
        lands[landId].y2 = 0;

        if(lands[landId].isNFT){
            lands[landId].isNFT = false;
            IUtpoiaNFT(nftContract).burn(landId);
        }

        //remove from current owner
        address owner = lands[landId].owner;
        uint256 index = lands[landId].ownerIndex;

        if(ownerLands[owner].length > 1){
            ownerLands[owner][index] = ownerLands[owner][ownerLands[owner].length-1];
            lands[ownerLands[owner][index]].ownerIndex = index;
        }

        ownerLands[owner].pop();
        lands[landId].owner = address(0);

        emit Burn(landId);
    }

    function transferLandInternal(uint256 landId, address _to, address _from) private{
        // add the land to _to
        uint256 index = lands[landId].ownerIndex;

        lands[landId].ownerIndex = ownerLands[_to].length;
        lands[landId].owner = _to;
        ownerLands[_to].push(landId);

        //remove from current owner
        if(ownerLands[_from].length > 1){
            ownerLands[_from][index] = ownerLands[_from][ownerLands[_from].length-1];
            lands[ownerLands[_from][index]].ownerIndex = index;
        }

        ownerLands[_from].pop();
        emit LandTransfer(landId, _from, _to);
    }

    function adminAssignLand(int256 x1,
        int256 x2, int256 y1, int256 y2, address addr, string memory hash)
        public onlyAdmin{

        assignLandInternal(x1, x2, y1, y2, addr, hash);
    }

    function assignLand(int256 x1,
        int256 x2, int256 y1, int256 y2, string memory hash)
                isPublic public payable{
        require(assignLandWithoutSigEnabled, "requires sig");
        uint256 cost = abs(x2-x1) * abs(y2-y1) * unitLandPrice;
        require(msg.value >= cost, "value < price");

        DAOWallet.transfer(msg.value);

        assignLandInternal(x1, x2, y1, y2, msg.sender, hash);
    }

    function assignLandConflictFree(int256 x1,
        int256 x2, int256 y1, int256 y2, string memory hash,
        uint lastLandChecked, bytes calldata sig
    ) isPublic public payable{
        bytes32 sigHash = keccak256(abi.encodePacked(
            x1, x2, y1, y2, lastLandChecked
        ));
        sigHash = sigHash.toEthSignedMessageHash();
        address signer = sigHash.recover(sig);
        require(hasRole(CONFLICT_ROLE, signer), "!sig");

        require(!hasConflict(x1, x1, y1, y2, lastLandChecked), "conflict");

        uint256 cost = abs(x2-x1) * abs(y2-y1) * unitLandPrice;
        require(msg.value >= cost, "value < price");

        DAOWallet.transfer(msg.value);

        assignLandInternal(x1, x2, y1, y2, msg.sender, hash);
    }

    function assignLandInternal(int256 x1,
        int256 x2, int256 y1, int256 y2, address addr, string memory hash) private{
        uint256 landId = ++lastLandId;
        lands[landId] = Land(
            landId,
            x1,
            x2,
            y1,
            y2,
            block.timestamp,
            hash,
            false,
            addr,
            ownerLands[addr].length
        );
        ownerLands[addr].push(landId);
        emit Assign(landId, x1, x2, y1, y2, addr, hash);
    }

    function landToNFT(uint256 landId) public{

        require(block.timestamp - lands[landId].time >= landToNFTMinDelay, "delay < minDelay");

        require(landToNFTEnabled || hasRole(NFT_ROLE, msg.sender), "landToNFTEnabled !enabled");
        require(lands[landId].owner == msg.sender || hasRole(NFT_ROLE, msg.sender), "!owner");
        require(!lands[landId].isNFT, "already NFT");

        lands[landId].isNFT = true;
        IUtpoiaNFT(nftContract).mint(msg.sender, landId);
    }

    function NFTToLand(uint256 landId) public{
        require(lands[landId].owner == msg.sender || hasRole(NFT_ROLE, msg.sender), "!owner");
        require(lands[landId].isNFT, "!NFT");

        lands[landId].isNFT = false;
        IUtpoiaNFT(nftContract).burn(landId);
    }

    function adminSetIsPublic(bool val) onlyAdmin public{
        publicAssignEnabled = val;
    }

    function adminSetUnitLandPrice(uint256 price) onlyAdmin public{
        unitLandPrice = price;
    }

    function adminSetDAOWallet(address payable _DAOWallet) onlyAdmin public{
        DAOWallet = _DAOWallet;
    }

    function adminSetNFTContract(address addr) onlyAdmin public{
        nftContract = addr;
    }

    function adminEnableWithoutSig(bool val) public onlyAdmin{
        assignLandWithoutSigEnabled = val;
    }

    function adminEnableLandToNFT(bool val) public onlyAdmin{
        landToNFTEnabled = val;
    }

    function adminSetLandToNFTMinDelay(uint256 val) public onlyAdmin{
        landToNFTMinDelay = val;
    }

    function landPrice(int256 x1, 
        int256 x2, int256 y1, int256 y2)
                view public returns(uint256){
        return abs(x2-x1) * abs(y2-y1) * unitLandPrice;
    }

    function abs(int256 x) pure public returns (uint256) {
        return uint256(x > 0 ? x : -1*x);
    }

    function getLands(address owner) view public returns (Land[] memory _lands) {
        _lands = new Land[](ownerLands[owner].length);
        for(uint256 i=0; i< _lands.length; i++){
            _lands[i] = lands[ownerLands[owner][i]];
        }
    }

    function getLandsByIds(uint256[] memory ids) view public returns (Land[] memory _lands) {
        _lands = new Land[](ids.length);
        for(uint256 i=0; i< _lands.length; i++){
            _lands[i] = lands[ids[i]];
        }
    }

    function hasConflict(int256 x1, int256 x2, int256 y1, int256 y2,
        uint256 lastLandChecked
    ) view public returns(bool){
        for(uint256 i=lastLandChecked; i<lastLandId; i++){
            Land storage l = lands[i];
            bool noOverlap = l.x1 > x2 ||
                x1 > l.x2 ||
                l.y1 > y2 ||
                y1 > l.y2;
            if(!noOverlap){
                return true;
            }
        }
        return false;
    }
}