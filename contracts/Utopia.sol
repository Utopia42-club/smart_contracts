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
        uint256 x1;
        uint256 x2;
        uint256 y1;
        uint256 y2;
        uint256 time;
        string hash;
    }

    // admins
    address[] public admins;

    address[] public onwers;
    mapping(address => Land[]) lands;

    constructor(){
        admins[admins.length++] = msg.sender;
    }

    function getOwners() view public returns (address[]) {
        return onwers;
    }

    
    function getLands(address onwer) view public returns (Land[]) {
        return lands[onwer];
    }

    function getLand(address onwer, uint256 index) 
    view public returns (
        uint256 x1,
        uint256 y1,
        uint256 x2,
        uint256 y2,
        uint256 time, string hash) {
        if(lands[onwer].length <= index){
            return;
        }
        x1 = lands[onwer][index].x1;
        x2 = lands[onwer][index].x2;
        y1 = lands[onwer][index].y1;
        y2 = lands[onwer][index].y2;
        time = lands[onwer][index].time;
        hash = lands[onwer][index].hash;
    }

    function assignLand(uint256 x1, 
        uint256 y1, uint256 x2, uint256 y2){
        if(!(lands[msg.sender].length > 0)){
            onwers[onwers.length++] = msg.sender;
        }
        lands[msg.sender].push(Land(
            x1,
            x2,
            y1,
            y2,
            now,
            ""
        ));
    }

    function updateLand(string hash, uint256 index) returns (bool){
        if(lands[msg.sender].length <= index){
            return false;
        }
        lands[msg.sender][index].hash = hash;
        return true;
    }
}
