pragma solidity ^0.5.0;

import "../access/roles/FrozenRole.sol";

/**
 * @dev Contract module which allows children to implement an emergency stop
 * mechanism that can be triggered by an authorized account.
 *
 * This module is used through inheritance. It will make available the
 * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
 * the functions of your contract. Note that they will not be pausable by
 * simply including this module, only once the modifiers are put in place.
 */
contract Frozenable is FrozenRole {
    
    /**
     * @dev Emitted when the pause is triggered by a pauser (`account`).
     */
    event Frezee(address account);

    /**
     * @dev Emitted when the pause is lifted by a pauser (`account`).
     */
    event UnFrezee(address account);

    mapping (address => bool) private frozenAccount;

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotFrozened() {
        require(!frozenAccount[msg.sender]);
        _;
    }

    function freezeAccount(address target) public onlyFrozener {
        frozenAccount[target] = true;
        emit Frezee(target);
    }
    
    function unFreezeAccount(address target) public onlyFrozener {
        frozenAccount[target] = false;
        emit UnFrezee(target);
    }
    
    function isFrozen(address target) public view returns (bool){
        return frozenAccount[target];
    }

}
