
var minter = artifacts.require("./Utopia42CitizenIDMinter.sol");
var nft = artifacts.require("./Utopia42CitizenID.sol");
var settings = artifacts.require("./Settings.sol");

module.exports = async function(deployer) {

	// await deployer.deploy(nft,"0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB", "0x554e4243000000000000000000000000000000000000000000000000000000");
	// await deployer.deploy(minter, "0x2D46fC2A5b297ac43eC336d5f2f39fe4d58b3D5B");
	await deployer.deploy(settings, "0x2D46fC2A5b297ac43eC336d5f2f39fe4d58b3D5B");

}
