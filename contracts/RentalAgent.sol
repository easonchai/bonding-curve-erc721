pragma solidity ^0.6.8;

import './EstateAgent.sol';
import './DecentramallToken.sol';
import '@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol';

contract RentalAgent is IERC721Receiver{

    mapping (address => mapping(uint256 => address)) beneficialOwner;

    event Deposit(address from, uint256 tokenId);

    function unfreeze(DecentramallToken nftContract, uint256 tokenId) external{
        require(beneficialOwner[address(nftContract)][tokenId] == msg.sender, "User did not deposit token!");
        nftContract.safeTransferFrom(address(this), msg.sender, tokenId);
    }

    /**
    * @dev Deposit the SPACE token to this contract
    **/
    function onERC721Received(address, address from, uint256 tokenId, bytes calldata)
        external override
        returns(bytes4)
    {
        beneficialOwner[msg.sender][tokenId] = from;
        emit Deposit(msg.sender, tokenId);
        return 0x150b7a02;
    }

    // /**
    // * @dev Deposit the SPACE token to this contract
    // **/
    // function deposit() public{
        
    // }

    // /**
    // * @dev Allows users to borrow a specific amount of the reserve currency, provided that the borrower
    // **/
    // function lend() public {

    // }

    // /**
    // * @dev Allows users to borrow a specific amount of the reserve currency, provided that the borrower
    // **/
    // function borrow() public {
        
    // }
}