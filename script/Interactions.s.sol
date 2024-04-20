// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";
import {VRFCoordinatorV2Mock} from "@chainlink/contracts/src/v0.8/mocks/VRFCoordinatorV2Mock.sol";
import {LinkToken} from "../test/mocks/LinkToken.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";

contract CreateSubscription is Script {
    function createSubscriptionUsingConfig() public returns (uint64) {
        HelperConfig helperConfig = new HelperConfig();
        (
            ,,address VRFCoordinator,,,,, uint256 deployerKey
        ) = helperConfig.activeNetworkConfig();
        return createSubscription(VRFCoordinator, deployerKey);
    }

    function createSubscription(address vrfCoordinator, uint256 deployerKey) public returns (uint64) {
        console.log("createSubscription on chainID: ", block.chainid);
        vm.startBroadcast(deployerKey);
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
            ,,address VRFCoordinator,, uint64 subid,,address link, uint256 deployerKey
        ) = helperConfig.activeNetworkConfig();
        fundSubscription(VRFCoordinator, subid, link, deployerKey);
    }

    function fundSubscription(address vrfCoordinator, uint64 subid, address link, uint256 deployerKey) public {
        console.log("Funding subscription: ", subid);
        console.log("Uisng coordinator: ", vrfCoordinator);
        console.log("On ChainId: ", block.chainid);
        if (block.chainid == 31337) {
            vm.startBroadcast(deployerKey);
            VRFCoordinatorV2Mock(vrfCoordinator).fundSubscription(
                subid,
                FUND_AMOUNT
            );
            vm.stopBroadcast();
        } else {
            vm.startBroadcast(deployerKey);
            LinkToken(link).transferAndCall(vrfCoordinator, FUND_AMOUNT, abi.encode(subid));
            vm.stopBroadcast();
        }
    }
       function run() external {
        fundSubscriptionUsingConfig();
    }
}

contract AddConsumer is Script {
    function addConsumer(
        address raffle,
        address VRFCoordinator,
        uint64 subId,
        uint256 deployerKey
    ) public {
        console.log("Adding consumer contract: ", raffle);
        console.log("Using vrfCoordinator: ", VRFCoordinator);
        console.log("On ChainId: ", block.chainid);
        vm.startBroadcast(deployerKey);
        VRFCoordinatorV2Mock(VRFCoordinator).addConsumer(subId, raffle);
        vm.stopBroadcast();
    }

    function addConsumerUsingConfig(address raffle) public {
        HelperConfig helperConfig = new HelperConfig();
                (
                    ,
                    ,
                    address VRFCoordinator,
                    , 
                    uint64 subid, 
                    ,
                    ,
                    uint256 deployerKey
                ) = helperConfig.activeNetworkConfig();
                addConsumer(raffle, VRFCoordinator, subid, deployerKey);            
    }

    function run() external {
        address raffle = DevOpsTools.get_most_recent_deployment(
            "Raffle",
            block.chainid
        );
        addConsumerUsingConfig(raffle);
    }
}