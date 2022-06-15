// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**
 * @title Utopia
 * @author Reza Bakhshandeh <reza[dot]bakhshandeh[at]gmail[dot]com>
 */
import "@openzeppelin/contracts/access/AccessControl.sol";

interface IUtpoiaNFT{
  function burn(uint256 nftId) external;
  function mint(address sender, uint256 nftId) external;
}

contract Utopia is AccessControl{

    bytes32 constant public ADMIN_ROLE = keccak256("Admin Role");
    bytes32 constant public NFT_ROLE = keccak256("NFT ROLE");

    struct Land{
        uint256 id;
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

    bool public allowPublicAssign = true;

    address payable public DAOWallet = payable(msg.sender);

    uint256 public unitLandPrice = 0.0001 ether;

    uint256 public lastLandId = 0;

    address nftContract;

    modifier onlyAdmin {
        require(hasRole(ADMIN_ROLE, msg.sender), "!admin");
        _;
    }

    modifier onlyNFT {
        require(hasRole(NFT_ROLE, msg.sender), "!nft");
        _;
    }

    modifier isPublic(){
        require(allowPublicAssign);
        _;
    }

    constructor(
        address _owner
    ){
        _setupRole(DEFAULT_ADMIN_ROLE, _owner);
        _setupRole(ADMIN_ROLE, _owner);
    }

    function assignLand(int256 x1,
        int256 x2, int256 y1, int256 y2, string memory hash)
                isPublic public payable{

        uint256 cost = abs(x2-x1) * abs(y2-y1) * unitLandPrice;
        require(msg.value >= cost, "value < price");

        DAOWallet.transfer(msg.value);

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
            msg.sender,
            ownerLands[msg.sender].length
        );
        ownerLands[msg.sender].push(landId);
    }

    function updateLand(string memory hash, uint256 landId) public returns (bool){
        require(lands[landId].owner == msg.sender, "!owner");
        require(!lands[landId].isNFT, "isNFT");
        lands[landId].hash = hash;
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
    }

    function adminAssignLand(int256 x1, 
        int256 x2, int256 y1, int256 y2, address addr, string memory hash)
        public onlyAdmin{
     
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
    }

    function landToNFT(uint256 landId) public{
        require(lands[landId].owner == msg.sender, "!owner");
        require(!lands[landId].isNFT, "alreay NFT");

        lands[landId].isNFT = true;
        IUtpoiaNFT(nftContract).mint(msg.sender, landId);
    }

    function NFTToLand(uint256 landId) public{
        require(lands[landId].owner == msg.sender, "!owner");
        require(lands[landId].isNFT, "!NFT");

        lands[landId].isNFT = false;
        IUtpoiaNFT(nftContract).burn(landId);
    }

    function adminSetIsPublic(bool val) onlyAdmin public{
        allowPublicAssign = val;
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
}
