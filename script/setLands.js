const utopiaAbi = require('./abis/new_utopia_abi');
const HDWalletProvider = require("@truffle/hdwallet-provider");
const Web3 = require('web3');
var fs = require('fs');
var parse = require('csv-parse');
require('dotenv').config();

const provider = new HDWalletProvider(process.env.PK, process.env.RPC_URL);
const web3 = new Web3(provider);
const contract = new web3.eth.Contract(utopiaAbi, process.env.NEW_UTOPIA_ADDRESS);

;(async () => {
  fs.createReadStream('out.csv')
  .pipe(parse({delimiter: ','}))
  .on('data', function(row) {
    if (row[1] == 'Lands') return
    const address = row[0];
    const lands = JSON.parse(row[1]);
    lands.forEach(async land => {
      contract.methods.adminAssignLand(
        land[0],
        land[1],
        land[2],
        land[3],
        address,
        land[5],
      ).send({from: process.env.ADMIN_PUB})
      .then(function(receipt){
        console.log(receipt)
        console.log('-------------------------------------')
      });
    });
  })
  .on('end',function() {
  });
})();
