const Utopia = artifacts.require('./Utopia.sol');

contract('Utopia', accounts => {

    const admin1 = accounts[1];

    const createGame = () => Utopia.new(
    );

    it('get owners', async () => {
        const game = await createGame();

        await game.assignLand(1,2,3,4, {from: admin1});
        const owners = await game.getOwners();
        console.log("owners", owners[0], admin1);
        assert.equal(owners[0],admin1, 'owners mismatch');
    });

    it('get lands', async () => {
        const game = await createGame();

        await game.assignLand(1,2,3,4, {from: admin1});
        const lands = await game.getLand(admin1, 0);
        console.log("lands", lands);
        //assert.equal(owners, [admin1], 'owners mismatch');
    });
});

