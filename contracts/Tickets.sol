// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title A simulator for trees
/// @author Allister McKenzie
/// @notice You can use this contract for only the most basic simulation
/// @dev All function calls are currently implemented without side effects
/// @custom:experimental This is an experimental contract.

contract Tickets is ERC721, ERC721Enumerable, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;

    using SafeMath for uint;

    /* VARIABLES */

    Counters.Counter private _tokenIdCounter;

    uint256 public MAX_TICKETS;

    uint256 soldTickets;

    uint public constant maxTicketPurchase = 4;

    uint256 public constant ticketPrice = 10000000000000000; //0.01 ETH

    /* EVENTS */

    event ticketBought(uint count);

    event ticketTransfered(uint ticketId);

    event fundsWithdrawn(uint amount);

    /* CONSTRUCTOR */

    constructor(uint256 maxNftSupply) ERC721("Tickets", "TCKT") {
      MAX_TICKETS = maxNftSupply;
    }

    /* FUNCTIONS */

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function totalSupply() public view override returns (uint256) {
      return soldTickets;
    }
// make private???
    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    /// @notice Owner can reserve no more that 20 tickets for themselves
    /// @dev The Alexandr N. Tetearing algorithm could increase precision
    /// @param reserves The number of tickets the user want to reserve
    /// @note should add limit to the total amount of the supply that can be reserved by the owner
    /// @note would prefer to batch mint instead of minting in loop

    function reserveTickets(uint256 reserves) public onlyOwner {   
        require(reserves < 20, "reserveTickets: Tried to reserve more the 20 tickets");
        uint supply = totalSupply();
        require(reserves + supply <= MAX_TICKETS, "reserveTickets: reserve plus supply is bigger than max ticket amount");
        uint i;
        for (i = 0; i < reserves; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
        assert(balance == 0);
        emit fundsWithdrawn(balance);
    }

    /// @notice User purchases a specific number of tokens
    /// @param numberOfTickets The amount of tickets the user wants to purchase
    /// @note would prefer to batch mint instead of minting in loop

    function buyTickets(uint numberOfTickets) public payable {
        require(!paused(), "buyTickets: Sale must be active to buy ticket");
        require(numberOfTickets <= maxTicketPurchase, "buyTickets: Can only buy 4 tokens at a time");
        require(totalSupply().add(numberOfTickets) <= MAX_TICKETS, "buyTickets: Purchase would exceed max supply of tickets");
        require(ticketPrice.mul(numberOfTickets) <= msg.value, "buyTickets: Ether value sent is not correct");
        
        for(uint i = 0; i < numberOfTickets; i++) {
            uint mintIndex = totalSupply();
            if (totalSupply() < MAX_TICKETS) {
                soldTickets += 1; 
                _safeMint(msg.sender, mintIndex);
            }
        }

        emit ticketBought(numberOfTickets);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}