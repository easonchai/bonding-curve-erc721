//SPDX-License-Identifier: Unlicense
pragma solidity ^0.6.8;

import "./OwnableERC721.sol";

contract DecentramallToken is OwnableERC721 {
    //Max limit of tokens to be minted
    uint256 public currentLimit = 1000;

    constructor() OwnableERC721("Decentramall Space Token", "SPACE", 500) public {
    }

    /**
     * @dev Get price of next token
     *
     * Assuming current bonding curve function of y = x^2 + basePrice
     *
     * Plug in value into function above
     */
    function price() public view returns(uint256) {
        uint256 nextToken = totalSupply() + 1;

        return ((nextToken ** 2) + basePrice);
    }

    /**
     * @dev Buy a unique token
     *
     * One address can only hold one token as the token ID is based on a hashed version of the buyer's address
     *
     * The price of the token is based on a bonding curve function
     */
    function buy() public payable {
        require(msg.value >= price(), "Not enough funds to purchase token!");
        _safeMint(msg.sender, uint256(keccak256(abi.encodePacked(msg.sender))), "");
    }

    /**
     * @dev Sell a unique token
     *
     * One address can only hold one token as the token ID is based on a hashed version of the buyer's address
     *
     * The price of the token is based on a bonding curve function
     */
    function sell() public payable {
        _safeMint(msg.sender, uint256(keccak256(abi.encodePacked(msg.sender))), "");
    }

    /**
     * @dev Change the currentLimit variable (Max supply)
     *
     * Only admin(s) can change this variable
     */
    function changeLimit(uint256 _limit) public onlyAdmin{
        currentLimit = _limit;
    }

    /**
     * @dev Add a new admin
     *
     * Only admin(s) can add new admin
     */
    function addAdmin(address _newAdmin) public onlyAdmin{
        adminByAddress[_newAdmin] = true;
    }

    /**
     * @dev Get currentLimit
     *
     * Only admin(s) can add new admin
     */
    function getLimit() public view returns(uint256){
        return(currentLimit);
    }
}