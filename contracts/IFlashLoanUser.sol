pragma solidity ^0.8.6;
//SPDX-License-Identifier:UNLICENSED

interface IFlashloanUser {
    function flashloanCallback(uint amount, address token, bytes memory data) external;

}