// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Tickets is ERC721, ERC721Enumerable, Pausable, Ownable, ERC721Burnable {
    using Counters for Counters.Counter;

    using SafeMath for uint;

    /* VARIABLES */

    Counters.Counter private _tokenIdCounter;

    uint256 public MAX_TICKETS;

    uint public constant maxTicketPurchase = 20;

    uint256 public constant ticketPrice = 10000000000000000; //0.08 ETH

    /* EVENTS */

    event ticketBought();

    event ticketTransfered();

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
      return MAX_TICKETS;
    }

    /**
     * Set some tickets aside
     */
    function reserveTickets(uint256 reserves) public onlyOwner {   
        // require reserves !< supply     
        uint supply = totalSupply();
        uint i;
        for (i = 0; i < reserves; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(msg.sender).transfer(balance);
    }

    /**
    * Mints Tickets
    */
    function buyTickets(uint numberOfTokens) public payable {
        require(paused(), "Sale must be active to mint ticket");
        require(numberOfTokens <= maxTicketPurchase, "Can only mint 20 tokens at a time");
        require(totalSupply().add(numberOfTokens) <= MAX_TICKETS, "Purchase would exceed max supply of tickets");
        require(ticketPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
        
        for(uint i = 0; i < numberOfTokens; i++) {
            uint mintIndex = totalSupply();
            if (totalSupply() < MAX_TICKETS) {
                _safeMint(msg.sender, mintIndex);
            }
        }
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
