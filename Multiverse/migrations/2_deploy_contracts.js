
var Utopia42Controller = artifacts.require("./Utopia42Controller.sol");
var Utopia42VerseFactory = artifacts.require("./Utopia42VerseFactory.sol");
var collectionFactory = artifacts.require("./UtopiaCollectionFactory.sol");
var Utopia42Verse = artifacts.require("./Utopia42Verse.sol");
var utopiaNft = artifacts.require("./UtopiaNFT.sol");

module.exports = async function(deployer) {

    // await deployer.deploy(Utopia42Controller, '0xF3cB8cb6170FA64Ea20DFe4D46762fb4d9BB23f4')
    // await deployer.deploy(Utopia42VerseFactory, '0x2a15B2cDF1e147020F1BC07a57E9Db7867fe2AE4');
    // await deployer.deploy(collectionFactory, '0x5605EE031A57759c513F83d0391e1AB53569174d');
    // await deployer.deploy(Utopia42Verse,
    // 	"0x06c0313ea7E4F02d5A3077b292F104AECfBD5404",
    // 	"0x2a15B2cDF1e147020F1BC07a57E9Db7867fe2AE4",
    // 	true,
    // 	"Test"
    // );
    await deployer.deploy(
      utopiaNft,
      "0xf5b7A31D5721Dd0d3A3F7fb764C6bc4AfFE87479",
      "0x2a15B2cDF1e147020F1BC07a57E9Db7867fe2AE4",
      "Test"
    );
}
