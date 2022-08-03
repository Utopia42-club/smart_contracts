var Utopia42Controller = artifacts.require("./Utopia42Controller.sol");
var Utopia42VerseFactory = artifacts.require("./Utopia42VerseFactory.sol");
var collectionFactory = artifacts.require("./Utopia42CollectionFactory.sol");
var Utopia42Verse = artifacts.require("./Utopia42Verse.sol");
var Utopia42VerseLands = artifacts.require("./Utopia42VerseLands.sol");

var Utopia42CitizenID = artifacts.require("./Utopia42CitizenID.sol");
var Utopia42CitizenIDMinter = artifacts.require("./Utopia42CitizenIDMinter.sol");
var Utopia42Settings = artifacts.require("./Utopia42Settings.sol");

require('dotenv').config()

module.exports = async function(deployer) {
    await deployer.deploy(
      Utopia42Controller,
      process.env.DAO_WALLET,
      process.env.DAO_FUNDS_WALLET,
      process.env.VERSE_NFT_OWNER
    )
    await deployer.deploy(Utopia42VerseFactory, Utopia42Controller.address);
    await deployer.deploy(collectionFactory, Utopia42VerseFactory.address);
    let Utopia42VerseFactory_ = await Utopia42VerseFactory.deployed()
    await Utopia42VerseFactory_.setCollectionFactoryAddress(collectionFactory.address)

    // await deployer.deploy(Utopia42Verse,
    // 	process.env.VERSE_NFT_OWNER,
    // 	Utopia42Controller.address,
    // 	true,
    // 	"Test"
    // );
    // await deployer.deploy(
    //   Utopia42VerseLands,
    //   Utopia42Verse.address,
    //   Utopia42Controller.address,
    //   "Test"
    // );

    await deployer.deploy(Utopia42CitizenID, process.env.BRIGHTID_SIGNER, process.env.APP_NAME);
    await deployer.deploy(Utopia42CitizenIDMinter, Utopia42CitizenID.address);
    let Utopia42CitizenID_ = await Utopia42CitizenID.deployed();
    await Utopia42CitizenID_.grantRole(process.env.MINTER_ROLE, Utopia42CitizenIDMinter.address)
    await deployer.deploy(Utopia42Settings, Utopia42CitizenID.address);
}
