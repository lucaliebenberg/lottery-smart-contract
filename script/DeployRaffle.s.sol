// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {Raffle} from "../src/Raffle.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployRaffle is Script {
    function run() external returns (Raffle,HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (
            uint256 entranceFee, 
            uint256 interval, 
            address VRFCoordinator, 
            bytes32 gasLane, 
            uint64 subscriptionId, 
            uint32 callbackGasLimit
        ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        Raffle raffle = new Raffle(
            entranceFee,
            interval,
            VRFCoordinator,
            gasLane,
            subscriptionId,
            callbackGasLimit
        );
        vm.stopBroadcast();

        return (raffle, helperConfig);
    }
}