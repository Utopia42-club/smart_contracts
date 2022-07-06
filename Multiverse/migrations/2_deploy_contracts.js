
var utopia = artifacts.require("./Utopia.sol");
var utopiaNft = artifacts.require("./UtopiaNFT.sol");
var utopiaFactory = artifacts.require("./UtopiaFactory.sol");
var collectionFactory = artifacts.require("./UtopiaCollectionFactory.sol");

module.exports = async function(deployer) {

	// await deployer.deploy(utopia, "0x06c0313ea7E4F02d5A3077b292F104AECfBD5404");
	// await deployer.deploy(utopiaNft, "0x199bf2733f4322E826B1B999C9f2972B8346fE18");
	// await deployer.deploy(utopiaFactory);
	await deployer.deploy(collectionFactory, '0xDfa23bEE9F0D357616688Da553Af5213B3719aee');
}
