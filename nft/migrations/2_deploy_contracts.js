
var Utopia42CitizenID = artifacts.require("./Utopia42CitizenID.sol");
var Utopia42CitizenIDMinter = artifacts.require("./Utopia42CitizenIDMinter.sol");
var Utopia42Settings = artifacts.require("./Utopia42Settings.sol");
require('dotenv').config()

module.exports = async function(deployer) {
	await deployer.deploy(Utopia42CitizenID, process.env.BRIGHTID_SIGNER, process.env.APP_NAME);
	await deployer.deploy(Utopia42CitizenIDMinter, Utopia42CitizenID.address);
	let Utopia42CitizenID_ = await Utopia42CitizenID.deployed();
	await Utopia42CitizenID_.grantRole(process.env.MINTER_ROLE, Utopia42CitizenIDMinter.address)
	await deployer.deploy(Utopia42Settings, Utopia42CitizenID.address);
}
