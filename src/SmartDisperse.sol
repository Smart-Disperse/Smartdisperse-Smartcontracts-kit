//SPDX-License-Identifier: MIT
/**
 * @title SmartDisperse
 * @dev This contract facilitates Batch transfers of ERC20 token and Native token on same chain.
 */
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @dev SmartDisperse contract
 */

contract SmartDisperse is Ownable {

    constructor(address _owner) Ownable(_owner) {
       
    }
    
   
    /**
     * @dev to withraw ERC20 Tokens sent directly to the contract
     */
    function withdrawERC20Tokens(IERC20 token, uint256 amount) external onlyOwner {
        address owner = owner();
        require(token.transfer(owner,amount));
    }

    /**
     * @dev Disperse ether among multiple recipients.
     * @param recipients Array of recipient addresses.
     * @param values Array of corresponding ether values to be transferred.
     */
    function disperseEther(address payable[] memory recipients, uint256[] memory values) external payable {
    
        for (uint256 i = 0; i < recipients.length; i++) {
            recipients[i].transfer(values[i]);
        }
        uint256 balance = address(this).balance;
       
        if (balance > 0) {
            payable(msg.sender).transfer(balance);
        }

    }

    /**
     * @dev Disperse ERC-20 tokens among multiple recipients.
     * @param token ERC-20 token contract address Instance.
     * @param recipients Array of recipient addresses.
     * @param values Array of corresponding token values to be transferred.
     */

    function disperseToken(IERC20 token, address[] memory recipients, uint256[] memory values) external {
        uint256 total = 0;
        for (uint256 i = 0; i < recipients.length; i++) {
            total += values[i];
        }
        require(token.transferFrom(msg.sender, address(this), total));
        for (uint256 i = 0; i < recipients.length; i++) {
            require(token.transfer(recipients[i], values[i]));
        }
    }

    /**
     * @dev Disperse ERC-20 tokens direct among multiple recipients in a single transaction.
     * @param token ERC-20 token contract address Instance.
     * @param recipients Array of recipient addresses.
     * @param values Array of corresponding token values to be transferred.
     */
    function disperseTokenSimple(IERC20 token, address[] memory recipients, uint256[] memory values) external {
        for (uint256 i = 0; i < recipients.length; i++) {
            require(token.transferFrom(msg.sender, recipients[i], values[i]));
        }
    }
}
