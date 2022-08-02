const createCsvWriter = require('csv-writer').createObjectCsvWriter;
const utopiaAbi = require('./abis/old_utopia_abi');
const Web3 = require('web3');
require('dotenv').config();

const web3 = new Web3(process.env.RPC_URL);
const contract = new web3.eth.Contract(utopiaAbi, process.env.OLD_UTOPIA_ADDRESS);


const csvWriter = createCsvWriter({
  path: 'out.csv',
  header: [
    {id: 'address', title: 'Address'},
    {id: 'lands', title: 'Lands'},
  ]
});

;(async () => {

  contract.methods.getOwners().call()
  .then(async owners => {
    owners.forEach(async owner => {
      const lands = await contract.methods.getLands(owner).call();
      const data = [
        {
          address: owner,
          lands: JSON.stringify(lands)
        }
      ];
      csvWriter
      .writeRecords(data)
      .then(()=> console.log(`${owner} was written successfully.`));
    });
  })

})();
