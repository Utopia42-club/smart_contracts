pragma solidity ^0.4.25;
pragma experimental ABIEncoderV2;

import 'zeppelin-solidity/contracts/math/SafeMath.sol';

/**
 * @title Utopia
 * @author Reza Bakhshandeh <reza[dot]bakhshandeh[at]gmail[dot]com>
 */
contract Utopia{
    using SafeMath for uint256;

    struct Land{
        int256 x1;
        int256 x2;
        int256 y1;
        int256 y2;
        uint256 time;
        string hash;
    }

    // admins
    mapping(address => bool) public adminsMap;
    address[] public admins;

    address[] public owners;
    mapping(address => Land[]) public lands;

    bool public allowPublicAssign = true;

    address public fundsWallet = 0x38e41787d3F428Fad17CfD5470C4cFC4c0Ee3738;

    uint256 public unitLandPrice = 0.0001 ether;

    constructor(){
        admins[admins.length++] = msg.sender;
        adminsMap[msg.sender] = true;
    }

    modifier isPublic(){
        require(allowPublicAssign);
        _;
    }

    modifier isAdmin(){
        require(adminsMap[msg.sender]);
        _;
    }

    function getOwners() view public returns (address[]) {
        return owners;
    }

    
    function getLands(address owner) view public returns (Land[]) {
        return lands[owner];
    }

    function getLand(address owner, uint256 index) 
    view public returns (
        int256 x1,
        int256 y1,
        int256 x2,
        int256 y2,
        uint256 time, string hash) {
        if(lands[owner].length <= index){
            return;
        }
        x1 = lands[owner][index].x1;
        x2 = lands[owner][index].x2;
        y1 = lands[owner][index].y1;
        y2 = lands[owner][index].y2;
        time = lands[owner][index].time;
        hash = lands[owner][index].hash;
    }


    function assignLand(int256 x1, 
        int256 y1, int256 x2, int256 y2, string hash)
                isPublic public payable{

        uint256 cost = abs(x2-x1) * abs(y2-y1) * unitLandPrice;
        assert(msg.value >= cost);

        fundsWallet.transfer(msg.value);

        if(!(lands[msg.sender].length > 0)){
            owners[owners.length++] = msg.sender;
        }
        lands[msg.sender].push(Land(
            x1,
            x2,
            y1,
            y2,
            now,
            hash
        ));
    }

    function adminAssignLand(int256 x1, 
        int256 y1, int256 x2, int256 y2, address addr) isAdmin{
        if(!(lands[addr].length > 0)){
            owners[owners.length++] = addr;
        }

        lands[addr].push(Land(
            x1,
            x2,
            y1,
            y2,
            now,
            ""
        ));
    }

    function adminSetIsPublic(bool val) isAdmin{
        allowPublicAssign = val;
    }

    function adminSetUnitLandPrice(uint256 price) isAdmin{
        unitLandPrice = price;
    }

    function addAdmin(address addr) isAdmin{
        assert(addr != address(0));
        admins[admins.length++] = addr;
        adminsMap[addr] = true;
    }

    function updateLand(string hash, uint256 index) returns (bool){
        if(lands[msg.sender].length <= index){
            return false;
        }
        lands[msg.sender][index].hash = hash;
        return true;
    }

    function landPrice(int256 x1, 
        int256 y1, int256 x2, int256 y2)
                view public returns(uint256){
        return abs(x2-x1) * abs(y2-y1) * unitLandPrice;
    }

    function abs(int256 x) view public returns (uint256) {
        return uint256(x > 0 ? x : -1*x);
    }
}
