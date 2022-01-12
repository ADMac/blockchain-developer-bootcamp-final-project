Inheritance and Interfaces
- Inherits from the ERC721 contract to make each ticket unique
- Inherits from inumerable to have ticket counts
- Inherits from pausable to be able to pause and unpause sales
- Inherits from Ownable interface to provide an access control mechanism for buying and reserving tickets

Access Control
- Owner can pause and unpause contract to prevent buying of new tickets
- Contract owner can reserve tickets