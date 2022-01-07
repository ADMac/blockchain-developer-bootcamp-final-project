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

    this.tickets = await Tickets.new(1000);
  });

  // check ticket supply
  it('no tickets have been sold', async function () {
    const supply = await this.tickets.totalSupply({ from: sender });

    assert.equal(supply, 0, 'ticket supply is incorrect');
  });

  // mint new tickets
  it('new tickets will be bought', async function () {
    const stuff = await this.tickets.buyTickets(4, { from: receiver, value: web3.utils.toWei('1', 'ether') });

    // assert owner has 4 tickets
    const ticketCount = await this.tickets.balanceOf(receiver);
    assert.equal(ticketCount.toString(), new BN(4).toString());
    // expect(await this.tickets.balanceOf(receiver))
      // .to.be.equal(new BN(4));
  });

  // mint max amount of tickets
  it('cannot buy more than max amount of tickets', async function () {
    await expectRevert(
      this.tickets.buyTickets(21, { from: receiver }),
      'buyTickets: Can only buy 4 tokens at a time',
    );
  });

  // reserve tickets
  it('tickets can be reserved', async function () {
    await this.tickets.reserveTickets(10, { from: sender });

    const tokenBalance = await this.tickets.balanceOf(sender)
    const tokenCount = new BN(10);

    // assert owner has 10 tickets
    assert.equal(tokenCount.toString(), tokenBalance.toString());
  });

  // reserve more than max tickets
  it('no more that 20 tickets reserved', async function () {
    await expectRevert(
      this.tickets.reserveTickets(21, { from: sender }),
      'reserveTickets: Tried to reserve more the 20 tickets',
    );
  });

  // buy tickets below price
  it('cannot buy tickets under price', async function () {
    await expectRevert(
      this.tickets.buyTickets(4, { from: receiver, value: 1 }),
      'buyTickets: Ether value sent is not correct',
    );
  });

  // pause minting
  it('pause buying of tickets', async function () {
    const pause = await this.tickets.pause({ from: sender });

    expectEvent(pause, 'Paused', {
      account: sender,
    });

    // assert failure
    await expectRevert(
      this.tickets.buyTickets(4, { from: receiver }),
      'buyTickets: Sale must be active to buy ticket',
    );
  });

  // unpause minting
  it('unpause buying of tickets', async function () {
    const pause = await this.tickets.pause({ from: sender });

    const unpause = await this.tickets.unpause({ from: sender });

    // verify unpause
    expectEvent(unpause, 'Unpaused', {
      account: sender,
    });

    // assert passing
    const stuff1 = await this.tickets.buyTickets(3, { from: receiver, value: web3.utils.toWei('1', 'ether') });
  });

  // mint tickets while paused
/*
  it('updates balances on successful transfers', async function () {
    this.tickets.transfer(receiver, this.value, { from: sender });

    // BN assertions are automatically available via chai-bn (if using Chai)
    expect(await this.tickets.balanceOf(receiver))
      .to.be.bignumber.equal(this.value);
  });*/
});