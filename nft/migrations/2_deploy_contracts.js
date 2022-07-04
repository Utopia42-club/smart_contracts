
var minter = artifacts.require("./MRC721Minter.sol");
var nft = artifacts.require("./UnbcNft.sol");
var settings = artifacts.require("./Settings.sol");

module.exports = async function(deployer) {

	// await deployer.deploy(nft,"0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB", "0x554e4243000000000000000000000000000000000000000000000000000000");
	// await deployer.deploy(minter, "0xb800B8AC21a451444A5E9d21ce0ac89Da219F3D4");
	await deployer.deploy(settings, "0xb800B8AC21a451444A5E9d21ce0ac89Da219F3D4");

}
