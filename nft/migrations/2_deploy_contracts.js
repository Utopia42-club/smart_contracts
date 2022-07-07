
var minter = artifacts.require("./MRC721Minter.sol");
var nft = artifacts.require("./UnbcNft.sol");
var settings = artifacts.require("./Settings.sol");

module.exports = async function(deployer) {

	await deployer.deploy(nft,"0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB", "0x554e4243000000000000000000000000000000000000000000000000000000");
	// await deployer.deploy(minter, "0x8765cD378AD2123c783de30F8e72F9f9Dc5D900C");
	// await deployer.deploy(settings, "0x8765cD378AD2123c783de30F8e72F9f9Dc5D900C");

}
