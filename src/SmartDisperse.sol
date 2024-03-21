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
    
     event EtherDispersed(address _sender ,address payable[] _recipients,uint256[] _values);
    event ERC20TokenDispersed(address _sender, IERC20 _token, address[] _recipients, uint256[] _values);

    /**
     * @dev to withraw ERC20 Tokens sent directly to the contract
     */
    function withdrawERC20Tokens(IERC20 _token, uint256 _amount) external onlyOwner {
        address owner = owner();
         require(
            _token.balanceOf(address(this)) >= _amount,
            "Contract has Insufficient balance"
        );
        require(_token.transfer(owner,_amount));
    }

    /**
     * @dev Disperse ether among multiple recipients.
     * @param _recipients Array of recipient addresses.
     * @param _values Array of corresponding ether values to be transferred.
     */
    function disperseEther(address payable[] memory _recipients, uint256[] memory _values) external payable {
    
        for (uint256 i = 0; i < _recipients.length; i++) {
            _recipients[i].transfer(_values[i]);
             
        }
              emit EtherDispersed(msg.sender,_recipients,_values);

        uint256 balance = address(this).balance;
       
        if (balance > 0) {
            payable(msg.sender).transfer(balance);
        }


    }

    /**
     * @dev Disperse ERC-20 tokens among multiple recipients.
     * @param _token ERC-20 token contract address Instance.
     * @param _recipients Array of recipient addresses.
     * @param _values Array of corresponding token values to be transferred.
     */

    function disperseToken(IERC20 _token, address[] memory _recipients, uint256[] memory _values) external {
        uint256 total = 0;
        for (uint256 i = 0; i < _recipients.length; i++) {
            total += _values[i];
        }
        require(_token.transferFrom(msg.sender, address(this), total));
        for (uint256 i = 0; i < _recipients.length; i++) {
            require(_token.transfer(_recipients[i], _values[i]));
        }
             emit ERC20TokenDispersed(msg.sender,_token,_recipients,_values);
    }

    /**
     * @dev Disperse ERC-20 tokens direct among multiple recipients in a single transaction.
     * @param _token ERC-20 token contract address Instance.
     * @param _recipients Array of recipient addresses.
     * @param _values Array of corresponding token values to be transferred.
     */
    function disperseTokenSimple(IERC20 _token, address[] memory _recipients, uint256[] memory _values) external {
        for (uint256 i = 0; i < _recipients.length; i++) {
            require(_token.transferFrom(msg.sender, _recipients[i], _values[i]));
        }
         emit ERC20TokenDispersed(msg.sender,_token,_recipients,_values);
    }
}
