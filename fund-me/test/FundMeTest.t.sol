// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/Fundme.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundme;
    uint256 number = 1;
    function setUp() external {
        //fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployer = new DeployFundMe();
        fundme = deployer.run();
    }
    function testDemo() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view{
        //console.log("Owner address is: ", fundme.i_owner());
        //console.log("Msg sender address is: ", msg.sender);
        assertEq(fundme.i_owner(), msg.sender);
    }

    function testVersionIsAccurate() public view{
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
        //vm.skip(true);
    }
    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundme.fund();
    }
}