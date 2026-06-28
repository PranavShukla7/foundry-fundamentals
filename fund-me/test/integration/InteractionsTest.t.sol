//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/Fundme.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    FundMe fundme;
    address USER = makeAddr("pranavshukla");
        uint256 constant SEND_VALUE = 0.1 ether;
        uint256 constant STARTING_BALANCE = 10 ether;
        uint256 constant GAS_PRICE = 1;

    function setUp() public {
        DeployFundMe deployer = new DeployFundMe();
        fundme = deployer.run();
        vm.deal(USER, STARTING_BALANCE);
    }
    function testUserCanFundInteractions() public {
        FundFundMe fundfundme = new FundFundMe();
        vm.deal(address(fundfundme), SEND_VALUE);
        fundfundme.fundFundMe(address(fundme));

        WithdrawFundMe withdrawfundme = new WithdrawFundMe();
        withdrawfundme.withdrawFundMe(address(fundme));

        assert(address(fundme).balance == 0);
    }
}