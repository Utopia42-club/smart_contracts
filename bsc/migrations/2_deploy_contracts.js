var utopia = artifacts.require('./Utopia.sol')
var nft = artifacts.require('./UtopiaNFT.sol')
var factory = artifacts.require('./UtopiaFactory.sol')

module.exports = async function (deployer) {
	await deployer.deploy(factory)
	// await deployer.deploy(utopia);
	// utopiaDepolyed = await utopia.deployed();

	// await deployer.deploy(nft, utopiaDepolyed.address);
	// nftDeployed = await nft.deployed();

	// await utopiaDepolyed.adminSetNFTContract(nftDeployed.address);
	// await utopiaDepolyed.grantRole(
	// 	"0x02c2a0f67e02c5c69fc1e4729a7ac098cbe0f97f246a96e1a1a108d8f693101b",
	// 	nftDeployed.address
	// );
}
