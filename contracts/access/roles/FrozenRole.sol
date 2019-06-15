pragma solidity ^0.5.0;

import "../Roles.sol";

contract FrozenRole {
    using Roles for Roles.Role;

    event FrozenerAdded(address indexed account);
    event FrozenerRemoved(address indexed account);

    Roles.Role private _frozensers;

    constructor () internal {
        _addFrozener(msg.sender);
    }

    modifier onlyFrozener() {
        require(isFrozener(msg.sender), "FrozenerRole: caller does not have the Frozener role");
        _;
    }

    function isFrozener(address account) public view returns (bool) {
        return _frozensers.has(account);
    }

    function addFrozener(address account) public onlyFrozener {
        _addFrozener(account);
    }

    function renounceFrozener() public {
        _removeFrozener(msg.sender);
    }

    function _addFrozener(address account) internal {
        _frozensers.add(account);
        emit FrozenerAdded(account);
    }

    function _removeFrozener(address account) internal {
        _frozensers.remove(account);
        emit FrozenerRemoved(account);
    }
}
