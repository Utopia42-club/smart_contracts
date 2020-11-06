module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
	compilers: {
  		solc: {
    			version: "0.4.15",
			settings: {          // See the solidity docs for advice about optimization and evmVersion
     optimizer: {
          enabled: true,
          runs: 200
        }
      //  evmVersion: "byzantium"
     }
		}
	}
};
