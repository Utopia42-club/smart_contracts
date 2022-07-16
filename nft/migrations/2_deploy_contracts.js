
var minter = artifacts.require("./Utopia42CitizenIDMinter.sol");
var nft = artifacts.require("./Utopia42CitizenID.sol");
var settings = artifacts.require("./Settings.sol");

module.exports = async function(deployer) {

	// await deployer.deploy(nft,"0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB", "0x554e4243000000000000000000000000000000000000000000000000000000");
	// await deployer.deploy(minter, "0x4b74e0B90d12f2DbFfF25C830b44B2093F2F9d32");
	await deployer.deploy(settings, "0x4b74e0B90d12f2DbFfF25C830b44B2093F2F9d32");

}
