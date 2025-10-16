// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title Digital Assets Check
 * @author Andrea Liu 10-Oct-2025 UAE
 * @notice This is smart contract to check what is the digital assets based on user address input
 */
contract DigitalAssets is Ownable {
    error DigitalAssets_InputIsEmpty();
    error DigitalAssets_ChainIdIsNotRegistered(uint256 chainId);
    error DigitalAssets_ChainIdHasBeenRegistered(uint256 chainId);

    // Mapping from chainId to chainName
    mapping(uint256 => string) public s_chainIdToName;

    // Reverse mapping from chainName to chainId (optional)
    mapping(string => uint256) public s_nameToChainId;

    address private user;

    constructor(address _user) Ownable(msg.sender) {
        user = _user;
        initializeDefaultChains();
    }

    function initializeDefaultChains() internal {
        // Ethereum
        s_chainIdToName[1] = "Ethereum Mainnet";
        s_chainIdToName[5] = "Ethereum Goerli";
        s_chainIdToName[11155111] = "Ethereum Sepolia";

        // Polygon
        s_chainIdToName[137] = "Polygon Mainnet";
        s_chainIdToName[80001] = "Polygon Mumbai";
        s_chainIdToName[1442] = "Polygon zkEVM Testnet";

        // Binance Smart Chain
        s_chainIdToName[56] = "BSC Mainnet";
        s_chainIdToName[97] = "BSC Testnet";

        // Layer 2s
        s_chainIdToName[42161] = "Arbitrum One";
        s_chainIdToName[421613] = "Arbitrum Goerli";
        s_chainIdToName[10] = "Optimism";
        s_chainIdToName[420] = "Optimism Goerli";
        s_chainIdToName[8453] = "Base Mainnet";

        // Others
        s_chainIdToName[43114] = "Avalanche Mainnet";
        s_chainIdToName[43113] = "Avalanche Fuji";
        s_chainIdToName[250] = "Fantom Opera";
        s_chainIdToName[4002] = "Fantom Testnet";

        // Initialize reverse mapping
        s_nameToChainId["Ethereum Mainnet"] = 1;
        s_nameToChainId["Polygon Mainnet"] = 137;
        s_nameToChainId["BSC Mainnet"] = 56;
        s_nameToChainId["Arbitrum One"] = 42161;
        s_nameToChainId["Optimism"] = 10;
        s_nameToChainId["Base Mainnet"] = 8453;
        s_nameToChainId["Avalanche Mainnet"] = 43114;
        s_nameToChainId["Fantom Opera"] = 250;
    }

    function getChainName(uint256 _chainId) public view returns (string memory) {
        string memory name  = s_chainIdToName[_chainId];
        if (bytes(name).length == 0) {
            revert DigitalAssets_ChainIdIsNotRegistered(_chainId);
        }
        return name;
    }

    function getCurrentChainName() public view returns (string memory) {
        return getChainName(block.chainid);
    }

    // Admin functions to add new chains
    function addChain(uint256 _chainId, string memory _chainName) public onlyOwner {
        if (bytes(_chainName).length == 0) {
            revert DigitalAssets_InputIsEmpty();
        }
        if (bytes(s_chainIdToName[_chainId]).length > 0) {
            revert DigitalAssets_ChainIdHasBeenRegistered(_chainId);
        }

        s_chainIdToName[_chainId] = _chainName;
        s_nameToChainId[_chainName] = _chainId;
    }

    function updateChain(uint256 _chainId, string memory _chainName) public onlyOwner {
        if (bytes(s_chainIdToName[_chainId]).length == 0) {
            revert DigitalAssets_ChainIdIsNotRegistered(_chainId);
        }
        if (bytes(_chainName).length == 0) {
            revert DigitalAssets_InputIsEmpty();
        }

        // Remove old reverse mapping
        string memory oldName = s_chainIdToName[_chainId];
        delete s_nameToChainId[oldName];

        // Update mappings
        s_chainIdToName[_chainId] = _chainName;
        s_nameToChainId[_chainName] = _chainId;
    }
}
