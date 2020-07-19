//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
 
contract DecentramallToken is ERC721 {
    using SafeMath for uint256;
    
    uint256 public tokenId = 1;
    
    constructor() ERC721("Decentramall Space Token", "SPACE") public {
    }

    //Todo: Make only owner able to mint
    function mint(address to) public {
        _safeMint(to, tokenId, "");
        tokenId.add(1);
    }

    function getTokenId() public view returns(uint256){
        return(tokenId);
    }
}