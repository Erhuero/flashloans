pragma solidity ^0.8.6;
//SPDX-License-Identifier:UNLICENSED

//smart contract that lend tokens in the flashloan

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
//prevent security vulnerability
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import './IFlashLoanUser.sol';

contract Flashloanprovider is ReentrancyGuard{
    //point to the DAI, USDC etc
    mapping(address => IERC20) public tokens;

    //when we deploy a flashloan provider we pass an array of all the tokens we support
    constructor(address[] memory _tokens){
        //loop through the array
        for(uint i = 0; i < _tokens.length; i++){
            //mapping population for each of the loop
            tokens[_tokens[i]] = IERC20(_tokens[i]);
        }
    }

    function executeFlashloan(//call to the lend
        //address where we need to send the token
        address callback,
        //amount lend
        uint amount,
        //address of the token
        address _token,
        //arbitrary data forward to the borrower
        bytes memory data
    )
    nonReentrant()
    external {
        //extract the pointer of the token we lend
        IERC20 token = tokens[_token];
        //save the original balance of the token before lending the token
        uint originalBalance = token.balanceOf(address(this));
        //make sure we have the token available
        require(address(token) != address(0), 'token not supported');
        //abort transaction
        require(originalBalance >= amount, 'amount too high');
        //enough balance to be lend
        require(originalBalance >= amount, 'amount too high');
        token.transfer(callback, amount);
        //instanciate the pointer to the borower
        //flashloan user will make use of the token to the arbitrage and profit
        IFlashloanUser(callback).flashloanCallback(amount, _token, data);
        //make sure to give back money
        require(
            token.balanceOf(address(this)) == originalBalance,
            'flashloan not reimbursed'
        );
    }
}