
var minter = artifacts.require("./MRC721Minter.sol");
var nft = artifacts.require("./UnbcNft.sol");
var settings = artifacts.require("./Settings.sol");

module.exports = async function(deployer) {

	// await deployer.deploy(nft,"0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB", "0x554e4243000000000000000000000000000000000000000000000000000000");
	// await deployer.deploy(minter, "0x7c1d8713BCc0E1E10e317feaD2C1D5E60474F8ae");
	await deployer.deploy(settings, "0x7c1d8713BCc0E1E10e317feaD2C1D5E60474F8ae");

}
