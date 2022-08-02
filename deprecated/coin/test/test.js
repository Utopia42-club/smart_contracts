const UtopiaUBI = artifacts.require('./UtopiaUBI.sol');

const toWei = (number) => number * Math.pow(10, 18);
const fromWei = (n) => n / Math.pow(10, 18);

const transaction = (address, wei) => ({
    from: address,
    value: wei
});

const getETHBalance = (address) => web3.eth.getBalance(address).toNumber();

contract('Token', accounts => {

    const admin1 = accounts[1];
    const admin2 = accounts[2];
    const admin3 = accounts[3];

    const investor1 = accounts[4];
    const investor2 = accounts[5];

    const contractAddress = accounts[6];

    const oneEth = toWei(1);

    const createToken = () => UtopiaUBI.new({from: admin1});

    it('check buy', async () => {
        const token = await createToken();
        
        //await token.addUser(investor1, {from:admin1})
        //await token.withdrawDAO({from:admin1});

        //const balance = await token.balanceOf(token.address);
        //console.log(balance);
        //console.log(fromWei(balance));

        //const b = await token.pendingAmount(investor1);
        //console.log(b);
    });

   
});
