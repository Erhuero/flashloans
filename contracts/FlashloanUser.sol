pragma solidity ^0.8.6;
//SPDX-License-Identifier:UNLICENSED

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import './IFlashLoanUser.sol';
import './FlashLoanProvider.sol';

contract FlashloanUser is IFlashloanUser {
    //start the flashloan
    function startFlashloan(
        address flashloan,
        uint amount,
        address token
    )
    external {
        Flashloanprovider(flashloan).executeFlashloan(
            address(this),
            amount,
            token,
            bytes('')
        );
    }
    //callback implementation, executed after token borrow
    function flashloanCallback(
        uint amount, 
        address token, 
        bytes memory data
    )

    override
    external {
        //do some arbitrage, liquidation etc ...


        //reimburse borrowed token
        IERC20(token).transfer(msg.sender, amount);
    }

}