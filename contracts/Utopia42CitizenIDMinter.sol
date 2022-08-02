// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./interfaces/IMRC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Utopia42CitizenIDMinter is Ownable {

  using ECDSA for bytes32;


  uint256 public unitPrice = 0.001 ether; // 0.001 ether
  bool public mintEnabled = true;
  uint8 public maxPerUser = 20;

  IMRC721 public nftContract;

  uint256 public maxCap = 3270;


  constructor(
    address nftContractAddress
  ){
    nftContract = IMRC721(nftContractAddress);
  }

  function mint(address _to, uint _count) public payable {
    require(mintEnabled, "!enabled");
    require(_count <= maxPerUser, "> maxPerUser");
    require(_count+nftContract.totalSupply() + 1 <= maxCap, "> maxCap");
    require(msg.value >= price(_count), "!value");

    _mint(_to, _count);
  }

  function _mint(address _to, uint _count) private{
    for(uint i = 0; i < _count; i++){
      nftContract.mint(_to, nftContract.totalSupply() + 1);
    }
  }

  function price(uint _count) public view returns (uint256) {
    return _count * unitPrice;
  }

  function updateUnitPrice(uint256 _unitPrice) public onlyOwner {
    unitPrice = _unitPrice;
  }

  function updateMintEnabled(bool enable) public onlyOwner {
    mintEnabled = enable;
  }

  function updateMaxPerUser(uint8 _maxPerUser) public onlyOwner {
    maxPerUser = _maxPerUser;
  }

  function updateNftContrcat(IMRC721 _newAddress) public onlyOwner {
    nftContract = IMRC721(_newAddress);
  }

  function updateMaxCap(uint256 _val) public onlyOwner {
    maxCap = _val;
  }

  // allows the owner to withdraw tokens
  function ownerWithdraw(uint256 amount, address _to, address _tokenAddr) public onlyOwner{
    require(_to != address(0));
    if(_tokenAddr == address(0)){
      payable(_to).transfer(amount);
    }else{
      IERC20(_tokenAddr).transfer(_to, amount);
    }
  }
}
