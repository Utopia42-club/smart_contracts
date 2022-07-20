
var Utopia42Controller = artifacts.require("./Utopia42Controller.sol");
var Utopia42VerseFactory = artifacts.require("./Utopia42VerseFactory.sol");
var collectionFactory = artifacts.require("./UtopiaCollectionFactory.sol");
var Utopia42Verse = artifacts.require("./Utopia42Verse.sol");
var utopiaNft = artifacts.require("./UtopiaNFT.sol");

module.exports = async function(deployer) {

    // await deployer.deploy(Utopia42Controller, '0xF3cB8cb6170FA64Ea20DFe4D46762fb4d9BB23f4')
    await deployer.deploy(Utopia42VerseFactory, '0x693aA12240576Ff74169b25Cf1D4CcE15f2135Cd');
    // await deployer.deploy(collectionFactory, '0x4aee2ECcd5dd9CeE23b98B24a3CaA68bb5f092f2');
    // await deployer.deploy(Utopia42Verse,
    // 	"0x06c0313ea7E4F02d5A3077b292F104AECfBD5404",
    // 	"0x693aA12240576Ff74169b25Cf1D4CcE15f2135Cd",
    // 	true,
    // 	"Test"
    // );
    // await deployer.deploy(
    //   utopiaNft,
    //   "0x458fb21098F9fcb9bf9C02072235704B563D565F",
    //   "0x693aA12240576Ff74169b25Cf1D4CcE15f2135Cd",
    //   "Test"
    // );
}
