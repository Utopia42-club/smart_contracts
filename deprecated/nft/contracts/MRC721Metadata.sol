// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IMRC721Metadata.sol";

abstract contract MRC721Metadata{
    function mint(address to, uint256 id, 
    	bytes calldata data) external virtual{}

    function encodeParams(uint256 id) virtual public view returns(bytes memory);
    
    function encodeParams(uint256[] calldata ids) public view returns(bytes memory){
    	bytes[] memory params = new bytes[](ids.length);
    	for(uint8 i =0; i < ids.length; i++){
    		params[i] = encodeParams(ids[i]);
    	}
    	return abi.encode(params);
    }
}
