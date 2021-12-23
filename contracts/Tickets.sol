// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Tickets is ERC721, Ownable {
    using SafeMath for uint256;

    uint256 public startingIndexBlock;

    uint256 public startingIndex;

    uint256 public constant ticketPrice = 10000000000000000; //0.01 ETH

    uint public constant maxTicketPurchase = 20;

    uint256 public MAX_TICKETS;

    bool public saleIsActive = false;

    uint256 public REVEAL_TIMESTAMP;

    constructor() ERC721("Tickets", "TCKT") {}

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    constructor(string memory name, string memory symbol, uint256 maxTicketSupply, uint256 saleStart) ERC721(name, symbol) {
        MAX_TICKETS = maxTicketSupply;
        REVEAL_TIMESTAMP = saleStart + (86400 * 9);
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        msg.sender.transfer(balance);
    }

    /**
     * Reserve some tickets for giveaways
     */
    function reserveTickets() public onlyOwner {        
        uint supply = totalSupply();
        uint i;
        for (i = 0; i < 30; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    /*
    * Pause sale if active, make active if paused
    */
    function flipSaleState() public onlyOwner {
        saleIsActive = !saleIsActive;
    }

    /**
    * Mints Bored Apes
    */
    function mintTickets(uint numberOfTickets) public payable {
        require(saleIsActive, "Sale must be active to mint Ape");
        require(numberOfTickets <= maxTicketPurchase, "Can only buy 20 tickets at a time");
        require(totalSupply().add(numberOfTickets) <= MAX_APES, "Purchase would exceed max supply of tickets");
        require(apePrice.mul(numberOfTickets) <= msg.value, "Ether value sent is not correct");
        
        for(uint i = 0; i < maxTicketPurchase; i++) {
            uint mintIndex = totalSupply();
            if (totalSupply() < TICKET_APES) {
                _safeMint(msg.sender, mintIndex);
            }
        }

        // If we haven't set the starting index and this is either 1) the last saleable token or 2) the first token to be sold after
        // the end of pre-sale, set the starting index block
        if (startingIndexBlock == 0 && (totalSupply() == TICKET_APES || block.timestamp >= REVEAL_TIMESTAMP)) {
            startingIndexBlock = block.number;
        } 
    }

    /**
     * Set the starting index for the collection
     */
    function setStartingIndex() public {
        require(startingIndex == 0, "Starting index is already set");
        require(startingIndexBlock != 0, "Starting index block must be set");
        
        startingIndex = uint(blockhash(startingIndexBlock)) % MAX_APES;
        // Just a sanity case in the worst case if this function is called late (EVM only stores last 256 block hashes)
        if (block.number.sub(startingIndexBlock) > 255) {
            startingIndex = uint(blockhash(block.number - 1)) % MAX_APES;
        }
        // Prevent default sequence
        if (startingIndex == 0) {
            startingIndex = startingIndex.add(1);
        }
    }

    /**
     * Set the starting index block for the collection, essentially unblocking
     * setting starting index
     */
    function emergencySetStartingIndexBlock() public onlyOwner {
        require(startingIndex == 0, "Starting index is already set");
        
        startingIndexBlock = block.number;
    }
}