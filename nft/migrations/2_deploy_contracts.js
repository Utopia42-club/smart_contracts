
var minter = artifacts.require("./Utopia42CitizenIDMinter.sol");
var nft = artifacts.require("./Utopia42CitizenID.sol");
var Utopia42Settings = artifacts.require("./Utopia42Settings.sol");

module.exports = async function(deployer) {

	// await deployer.deploy(nft,"0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB", "0x554e4243000000000000000000000000000000000000000000000000000000");
	// await deployer.deploy(minter, "0x929Ccf84BE21B3A7a71f3D8DE062394E0FA74541");
	await deployer.deploy(Utopia42Settings, "0x929Ccf84BE21B3A7a71f3D8DE062394E0FA74541");

}
