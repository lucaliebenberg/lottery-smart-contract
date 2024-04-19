// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        (
            ,,address VRFCoordinator,,,,
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

contract FundSubscription is Script {
    uint96 public constant FUND_AMOUNT = 3 ether;

    function fundSubscriptionUsingConfig() public {
        HelperConfig helperConfig = new HelperConfig();
        (
            ,,address VRFCoordinator,, uint64 subid,,address link
        ) = helperConfig.activeNetworkConfig();
        fundSubscription(VRFCoordinator, subid, link);
    }

    function fundSubscription(address vrfCoordinator, uint64 subid, address link) public {
        console.log("Funding subscription: ", subid);
        console.log("Uisng coordinator: ", vrfCoordinator);
        console.log("On ChainId: ", block.chainid);
        if (block.chainid == 31337) {
            vm.startBroadcast();
            VRFCoordinatorV2Mock(vrfCoordinator).fundSubscription(
                subid,
                FUND_AMOUNT
            );
            vm.stopBroadcast();
        } else {
            vm.startBroadcast();
            LinkToken(link).transferAndCall(vrfCoordinator, FUND_AMOUNT, abi.encode(subid));
            vm.stopBroadcast();
        }
    }
       function run() external {
        fundSubscriptionUsingConfig();
    }
}