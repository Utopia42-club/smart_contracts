const Token = artifacts.require('./ROICoin.sol');

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

    const createToken = () => Token.new();

    it('check buy', async () => {
        const token = await createToken();
        
        const balanceInit = await token.balanceOf(investor1);
        assert.equal(balanceInit, toWei(0), 'initial balance mismatch');

        await token.sendTransaction(transaction(investor1, oneEth));

        const balance = await token.balanceOf(investor1);
        console.log(balance);
        console.log(fromWei(balance));


        const e3 = await token.walletInfo(investor1);
        console.log(e3);
    });

    it('check refs', async () => {
        const token = await createToken();
        
        console.log(await token.walletInfo(investor1));

        await token.buy('0x0000000000000000000000000000000000000000', 
            '0x0000000000000000000000000000000000000000',
            {from: investor1, value: oneEth});

        await token.buy(investor1, 
            '0x0000000000000000000000000000000000000000',
            {from: investor2, value: oneEth});        

        console.log(await token.walletRefs(investor1, 1));
        console.log(await token.walletRefs(investor2, 1));
        //const e3 = await token.walletInfo(investor1);
        //console.log(e3);
    });

});
