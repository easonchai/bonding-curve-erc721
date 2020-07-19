//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract DecentramallToken is ERC721 {

    constructor() ERC721("Decentramall Space Token", "SPACE") public {
    }

    function mint(address purchaser) public returns(uint256){
        uint256 tokenId = uint256(keccak256(abi.encodePacked(purchaser)));
        _safeMint(purchaser, tokenId, "");
        return (tokenId);
    }

    function burn(uint256 tokenId) public {
        _burn(tokenId);
    }
}