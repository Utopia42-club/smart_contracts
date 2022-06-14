
var minter = artifacts.require("./MRC721Minter.sol");
var nft = artifacts.require("./UnbcNft.sol");

module.exports = async function(deployer) {

	// await deployer.deploy(nft,"0xb1d71F62bEe34E9Fc349234C201090c33BCdF6DB", "0x554e4243000000000000000000000000000000000000000000000000000000");
	await deployer.deploy(minter, "0xd045cFB95f6A20d25860F937010f7e333c0D3b96");
}
