pragma solidity ^0.6.8;

import './EstateAgent.sol';
import './DecentramallToken.sol';

contract RentalAgent{

    //Possibly move this to a registry instead
    mapping(uint256 => address) rightfulOwner;
    mapping(address => uint256) rentalEarned;

    mapping(uint256 => address) tokenRenter;
    mapping(uint256 => bool) tokenStatus;

    DecentramallToken public token;
    EstateAgent public estateAgent;

    event setToken(address _newContract);
    event setAgent(address _newContract);
    event Deposit(address from, uint256 tokenId);
    event Rented(address renter, uint256 tokenId);
    event Withdraw(address to, uint256 tokenId);

    /**
     * @dev Set token address
     * @param _newContract the address of the newly deployed SPACE token
     * In case if token address ever changes, we can set this contract to point there
     */
    function setToken(DecentramallToken _newContract) external onlyAdmin {
        token = _newContract;
        emit SetToken(_newContract);
    }

    /**
     * @dev Set EstateAgent address
     * @param _newContract the address of the EstateAgent
     */
    function setAgent(EstateAgent _newContract) external onlyAdmin {
        estateAgent = _newContract;
        emit SetAgent(_newContract);
    }

    /**
    * @dev Deposit the SPACE token to this contract
    * @param tokenId ID of the token to check
    **/
    function deposit(uint256 tokenId) public {
        require(token.verifyLegitimacy(tokenId) == true && token.tokenOfOwnerByIndex(msg.sender, tokenId) == true, "Fake token!");
        token.safeTransferFrom(msg.sender, address(this), tokenId);

        //Register the rightful owner if first time user
        if(rightfulOwner[tokenId] != msg.sender){
            rightfulOwner[tokenId] = msg.sender;
        }
        emit Deposit(msg.sender, tokenId);
    }

    /**
    * @dev Withdraw the SPACE token from this contract
    * @param tokenId ID of the token to check
    **/
    function withdrawSpace(uint256 tokenId) public {
        require(tokenStatus[tokenId] == false && rightfulOwner[tokenId] == msg.sender, "Token is rented/not yours!");
        token.safeTransferFrom(address(this), msg.sender, tokenId);
    }

    /**
    * @dev Allows users to rent a SPACE token of choice
    * @param tokenId ID of the token to check
    **/
    function rent(uint256 tokenId) public payable{
        //To rent, it costs 1/10 to buy new
        uint256 rentPrice = (estateAgent.price(token.totalSupply() + 1 ) / 10);
        require(msg.value >= (rentPrice * 1 ether), "Not enough funds!");
        require(tokenStatus[tokenId] == false, "Token is already rented!");
        tokenRenter[tokenId] = msg.sender;
        rentalEarned[rightfulOwner[tokenId]] = rentPrice;
    }

    /**
    * @dev Claim the rent earned
    **/
    function claimRent() public {
        uint256 toClaim = rentalEarned[msg.sender];
        require(address(this).balance >= toClaim, "Not enough funds to pay!");
        rentalEarned[msg.sender] -= toClaim;
        msg.sender.transfer(toClaim);
    }

    /**
    * @dev Remove rent status
    * @param tokenId ID of the token to perform action on
    **/
    function finishRent(uint256 tokenId) public{
        require(tokenStatus[tokenId] == true, "Token not rented!");
        tokenRenter[tokenId] = 0;
        tokenStatus[tokenId] = false;
    }

    /**
    * @dev Check who has the rights to use the token currently
    * @param tokenId ID of the token to check
    **/
    function checkDelegatedOwner(uint256 tokenId) public view returns (address) {
        //Check if the token is being rented
        if(tokenStatus[tokenId] == true){
            //Since rented, the current owner is the renter
            return tokenRenter[tokenId];
        } else {
            //Token is not rented, it either exists in this contract, or is held by the owner
            address currentOwner = token.checkOwner(tokenId);
            if(currentOwner == address(this)){
                //Token is here! Time to check the registry
                return rightfulOwner[tokenId];
            } else {
                return currentOwner;
            }
        }
    }
}