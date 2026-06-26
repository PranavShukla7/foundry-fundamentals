// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/Fundme.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
    FundMe fundme;
    //uint256 number = 1;
    address USER = makeAddr("pranavshukla");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    function setUp() external {
        //fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        DeployFundMe deployer = new DeployFundMe();
        fundme = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
    }
    function testDemo() public view {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view{
        //console.log("Owner address is: ", fundme.i_owner());
        //console.log("Msg sender address is: ", msg.sender);
        assertEq(fundme.getOwner(), msg.sender);
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
    modifier funded() {
        vm.prank(USER);
        fundme.fund{value: SEND_VALUE}();
        _;
    }
    function testFundUpdatesFundedDataStructure() public funded{
        //vm.prank(USER);
        //fundme.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundme.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
    function testAddsFunderToArrayOfFunders() public funded {
        ////vm.prank(USER);
        //fundme.fund{value: SEND_VALUE}();
        address funder = fundme.getFunder(0);
        assertEq(funder, USER);
    }
    function testOnlyOwnerCanWithdraw() public {
        vm.prank(USER);
        vm.expectRevert();
        fundme.withdraw();
    }
    function testWithdrawWithASingleFunder() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        // Act
        vm.prank(fundme.getOwner());
        fundme.withdraw();

        // Assert
        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundMeBalance = address(fundme).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }
    function testWithdrawFromMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            //vm.prank(address(i));
            hoax(address(i), SEND_VALUE);
            fundme.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundMeBalance = address(fundme).balance;

        // Act
        vm.startPrank(fundme.getOwner());
        fundme.withdraw();
        vm.stopPrank();

        // Assert
        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundMeBalance = address(fundme).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }
}