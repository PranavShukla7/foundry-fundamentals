// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
    }

    function testInc() public {
        counter.increment();
        assertEq(counter.count(), 1);
    }

    function testDec() public {
        counter.increment();
        counter.decrement();
        assertEq(counter.count(), 0);
    }

    function testDecUnderflow() public {
        vm.expectRevert(Counter.CounterAlreadyZero.selector);
        counter.decrement();
    }
}