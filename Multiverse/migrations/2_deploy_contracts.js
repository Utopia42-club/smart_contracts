
var Utopia42Controller = artifacts.require("./Utopia42Controller.sol");
var Utopia42VerseFactory = artifacts.require("./Utopia42VerseFactory.sol");
var collectionFactory = artifacts.require("./UtopiaCollectionFactory.sol");
var Utopia42Verse = artifacts.require("./Utopia42Verse.sol");
var utopiaNft = artifacts.require("./UtopiaNFT.sol");

module.exports = async function(deployer) {

	// await deployer.deploy(Utopia42Controller, '0xF3cB8cb6170FA64Ea20DFe4D46762fb4d9BB23f4')
	// await deployer.deploy(Utopia42VerseFactory, '0xAcBfC37359e2BD789bEa32b08f40ac0329213c29');
	await deployer.deploy(collectionFactory, '', '0xAcBfC37359e2BD789bEa32b08f40ac0329213c29');
	// await deployer.deploy(Utopia42Verse, "0x06c0313ea7E4F02d5A3077b292F104AECfBD5404");
	// await deployer.deploy(utopiaNft, "0x006ab595524d8E6e73fE8dE52686c43e16A7799e", "0x06c0313ea7E4F02d5A3077b292F104AECfBD5404");
}
