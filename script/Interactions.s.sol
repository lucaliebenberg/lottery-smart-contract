// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        (
            ,,address VRFCoordinator,,,
        ) = helperConfig.activeNetworkConfig();
        return createSubscription(VRFCoordinator);
    }

    function createSubscription(address vrfCoordinator) public returns (uint64) {
        console.log("createSubscription on chainID: ", block.chainid);
        vm.startBroadcast();
        uint64 subId = VRFCoordinatorV2Mock(vrfCoordinator).createSubscription();
        vm.stopBroadcast();
        console.log("Your subId is: ", subId);
        console.log("Please upadte your subscription in HelperConfig.s.sol");
    }

    function run() external returns (uint64) {
        return createSubscriptionUsingConfig();
    }
}