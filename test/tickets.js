const {
  BN,           // Big Number support
  constants,    // Common constants, like the zero address and largest integers
  expectEvent,  // Assertions for emitted events
  expectRevert, // Assertions for transactions that should fail
} = require('@openzeppelin/test-helpers');

const Tickets = artifacts.require('Tickets');

contract('Tickets', function ([sender, receiver]) {
  beforeEach(async function () {
    // The bundled BN library is the same one web3 uses under the hood
    this.value = new BN(1);

    this.tickets = await Tickets.new(10000);
  });

  // mint new tickets
  it('new tickets will be minted', async function () {
    const stuff = await this.tickets.buyTickets(this.value, { from: sender });
    // assert allowed
  });

  // mint max amount of tickets
  it('cannot mint more than max amount of tickets', async function () {
    const stuff = await this.tickets.buyTickets(21, this.value, { from: sender });
    // assert failure
  });

  // reserve tickets
  it('tickets can be reserved', async function () {
    const stuff = await this.tickets.reserveTickets(9999, { from: sender });

    // assert failure
    const stuff1 = await this.tickets.mintTickets(21, this.value, { from: sender });
  });

  // buy tickets below price
  it('cannot buy tickets under price', async function () {
    // assert failure
    const stuff = await this.tickets.mintTickets(this.value, { from: sender });
  });

  // pause minting
  it('pause minting of tickets', async function () {
    const stuff = await this.tickets.pause({ from: sender });

    // assert failure
    const stuff1 = await this.tickets.mintTickets(this.value, { from: sender });
  });

  // unpause minting
  it('unpause minting of tickets', async function () {
    const stuff = await this.tickets.unpause({ from: sender });

    // assert passing
    const stuff1 = await this.tickets.mintTickets(this.value, { from: sender });
  });

  // mint tickets while paused
/*
  it('reverts when transferring tokens to the zero address', async function () {
    // Conditions that trigger a require statement can be precisely tested
    await expectRevert(
      this.tickets.transfer(constants.ZERO_ADDRESS, this.value, { from: sender }),
      'Tickets: transfer to the zero address',
    );
  });

  it('emits a Transfer event on successful transfers', async function () {
    const receipt = await this.tickets.transfer(
      receiver, this.value, { from: sender }
    );

    // Event assertions can verify that the arguments are the expected ones
    expectEvent(receipt, 'Transfer', {
      from: sender,
      to: receiver,
      value: this.value,
    });
  });

  it('updates balances on successful transfers', async function () {
    this.tickets.transfer(receiver, this.value, { from: sender });

    // BN assertions are automatically available via chai-bn (if using Chai)
    expect(await this.tickets.balanceOf(receiver))
      .to.be.bignumber.equal(this.value);
  });*/
});