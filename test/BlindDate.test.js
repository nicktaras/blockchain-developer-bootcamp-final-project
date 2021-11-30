const BlindDate = artifacts.require('BlindDate');

const chai = require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('BlindDate', (accounts) => {

    let contract = null;

    before(async () => {
      contract = await BlindDate.deployed();
    })

    BlindDate.deployed().then((_instance) => { console.log(_instance) })

    describe('deployment', async () => {

      it('contract exists', async () => {
        assert.notEqual(BlindDate, null);
      });
      
      it('deployed successfully', async () => {
        const address = contract.address;
        assert.notEqual(address, null);
      });
      
      it('has a name', async () => {
        const name = await contract.name();
        assert.equal(name, 'BlindDate');
      });
      
      it('has a symbol', async () => {
        const symbol = await contract.symbol();
        assert.equal(symbol, 'BDAT');
      });

    });

    describe('payable methods', async () => {
      
      it('generate a new profile', async () => {
        const newProfile = await contract.addProfile('0x02e3118b168CcfD4Fb11F460cD50E53397E7Ee89','xyz','cyberpunk',0,0,'Australia',0,[0, 1, 2, 3, 4]);
        assert.equal(newProfile.receipt.status, true);
      });

      it('creates a new profile mapping', async () => {
        const newProfile = await contract.addProfile('0x02e3118b168CcfD4Fb11F460cD50E53397E7Ee89', 'xyz','cyberpunk',0,0,'Australia',0,[0, 1, 2, 3, 4]);
        const profile = await contract.getProfile(newProfile.receipt.from);
        assert.equal((profile) ? true : false, true);
      });
      
      it('update a profile', async () => {
        const currProfile = await contract.updateProfile('xyz','cyberpunk2030',0,0,'Greece',0,[0, 1, 2, 3, 4]);
        assert.equal(currProfile.receipt.status, true);
      });

      it('should contain no dates', async () => {
        assert.equal(contract.datesArray.length, 0);
      });
      
      it('should contain 1 date', async () => {

        await contract.addProfile('0x02e3118b168CcfD4Fb11F460cD50E53397E7Ee89', 'xyz','cyberpunk',0,0,'Australia',0,[0, 1, 2, 3, 4]);
        await contract.addProfile('0xd0758718e62f9D8DC332a8AF5C23fC169afED027', 'abc','punkyCyber',0,0,'Australia',0,[0, 1, 2, 3, 4]);

        // should find the address of second date etc.
        await contract.addDate("0xd0758718e62f9D8DC332a8AF5C23fC169afED027", 'hi, how are you?');
        assert.equal(contract.datesArray[0], 0);
      });
      
      it('reactivates account', async () => {
        const newProfile = await contract.addProfile('0x02e3118b168CcfD4Fb11F460cD50E53397E7Ee89','xyz','cyberpunk2030',0,0,'Greece',0,[0, 1, 2, 3, 4]);
        await contract.reactivateAccount();
        const profile = await contract.getProfile(newProfile.receipt.from);
        assert.equal(profile.active, true);
      });
      
      it('deactivates account', async () => {
        const newProfile = await contract.addProfile('0x02e3118b168CcfD4Fb11F460cD50E53397E7Ee89','xyz','cyberpunk2030',0,0,'Greece',0,[0, 1, 2, 3, 4]);
        await contract.deactivateAccount();
        const profile = await contract.getProfile(newProfile.receipt.from);
        assert.equal(profile.active, false);
      });
      
      
    });

})