// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

// initialSupply (send to Owner) => 7 000 000 [DONE]
// maxSupply (capped) => true [DONE]
// burnable => true [DONE]
// blockReward to miners => true [DONE]
// PandaSeaPayToken goerli => 0x1de79C32ea8Ae07300E1367567ADE92a11EEF012

contract PandaSeaPayToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;

    // set Owner, blockReward and initialSupply. Also sends all initial tokens to Owner
    constructor(uint256 cap, uint256 reward) ERC20("Example Token", "PSP") ERC20Capped(cap * (10 ** decimals())) {
        owner = payable(msg.sender);
        blockReward = reward * (10 ** decimals());
        _mint(owner, 7000000 * (10 ** decimals()));
    }

    // def function adquired in node_modules/@openzeppelin/contracts/token/ERC20/ERC20Capped.sol 
    function _mint(address account, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
        require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
        super._mint(account, amount);
    }

    // gives corresponding rewards to corresponding miner
    function _mintMinerReward() internal { 
        _mint(block.coinbase, blockReward); // block.coinbase => miners address
    } 

    // middleware for giving miner his rewards before executing the transfer
    // virtual override is used to over write the oppenzeppelin original function (_beforTokenTransfer) to implement the necessary validation
    function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
        if (from != address(0) && block.coinbase != address(0) && to != block.coinbase) { // address(0) => nullAddress(0x0000.....00000)
            _mintMinerReward();
        }
        super._beforeTokenTransfer(from, to, value);
    }

    // destroy the smart contract
    // function destroy() public onlyOwner {
    //     selfdestruct(owner);
    // }

    // function for changing the setBlockReward
    // function setBlockReward(uint256 reward) public onlyOwner {
    //     blockReward = reward * decimals;
    // }

    // modifier onlyOwner {
    //     require(msg.sender == owner, "Only the Owner can call this function");
    //     _;
    // }
}