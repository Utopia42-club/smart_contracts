var Utopia42Controller = artifacts.require("./Utopia42Controller.sol");
var Utopia42VerseFactory = artifacts.require("./Utopia42VerseFactory.sol");
var collectionFactory = artifacts.require("./UtopiaCollectionFactory.sol");
var Utopia42Verse = artifacts.require("./Utopia42Verse.sol");
var utopiaNft = artifacts.require("./UtopiaNFT.sol");
require('dotenv').config()

module.exports = async function(deployer) {
    await deployer.deploy(Utopia42Controller, process.env.DAO_WALLET)
    await deployer.deploy(Utopia42VerseFactory, Utopia42Controller.address);
    await deployer.deploy(collectionFactory, Utopia42VerseFactory.address);
    let Utopia42VerseFactory_ = await Utopia42VerseFactory.deployed()
    await Utopia42VerseFactory_.setCollectionFactoryAddress(collectionFactory.address)
    await deployer.deploy(Utopia42Verse,
    	process.env.VERSE_OWNER,
    	Utopia42Controller.address,
    	true,
    	"Test"
    );
    await deployer.deploy(
      utopiaNft,
      Utopia42Verse.address,
      Utopia42Controller.address,
      "Test"
    );
}
