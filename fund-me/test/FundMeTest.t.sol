// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/Fundme.sol";

contract FundMeTest is Test{
    uint256 number = 1;
    FundMe fundme;
    function setUp() external {
        fundme = new FundMe();
    }
    function testDemo() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }
}