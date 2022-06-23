
var minter = artifacts.require("./MRC721Minter.sol");
var nft = artifacts.require("./UnbcNft.sol");

module.exports = async function(deployer) {

	// await deployer.deploy(nft,"0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB", "0x554e4243000000000000000000000000000000000000000000000000000000");
	await deployer.deploy(minter, "0x7A4aCd401DBea587fb7ecC42D6a74AED86694fE2");
}
