pragma solidity ^0.5.0;

import "./ERC20.sol";
import "../../lifecycle/Frozenable.sol";
import "../../lifecycle/Pausable.sol";

/**
 * @title Frozen token
 * @dev ERC20 modified with frozen transfers.
 */
contract ERC20Frozensable is ERC20, Frozenable, Pausable {
    function transfer(address to, uint256 value) public whenNotFrozened whenNotPaused returns (bool) {
        return super.transfer(to, value);
    }

    function transferFrom(address from, address to, uint256 value) public whenNotFrozened whenNotPaused returns (bool) {
        return super.transferFrom(from, to, value);
    }

    function approve(address spender, uint256 value) public whenNotFrozened  whenNotPaused returns (bool) {
        return super.approve(spender, value);
    }

    function increaseAllowance(address spender, uint256 addedValue) public whenNotFrozened  whenNotPaused returns (bool) {
        return super.increaseAllowance(spender, addedValue);
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotFrozened whenNotPaused returns (bool) {
        return super.decreaseAllowance(spender, subtractedValue);
    }

}
