
var utopia = artifacts.require("./Utopia.sol");
var factory = artifacts.require("./UtopiaFactory.sol");

module.exports = async function(deployer) {

	await deployer.deploy(factory);
}
