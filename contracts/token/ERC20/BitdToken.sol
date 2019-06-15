pragma solidity ^0.5.0;



import "./ERC20Mintable.sol";
import "./ERC20Burnable.sol";
import "./ERC20Frozensable.sol";
import "../../math/SafeMath.sol";


contract BitdToken is ERC20Frozensable,ERC20Mintable,ERC20Burnable {
    
    string private _name; 
    string private _symbol;
    uint8 private _decimals;
    
    constructor (uint256 totalSupply, string memory name, string memory symbol, uint8 decimals)  
    ERC20(totalSupply)
    public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }
    
    
    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei.
     *
     * > Note that this information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * `IERC20.balanceOf` and `IERC20.transfer`.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }
    
    
    function approveAndCall(address _spender, uint256 _value, bytes calldata _extraData)  external whenNotFrozened whenNotPaused  returns (bool){
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)) {
            spender.receiveApproval(msg.sender, _value, address(this), _extraData);
            return true;
        }
    }
    
    function multiTransfer(address[] calldata _tos, uint256[] calldata _values)  external whenNotFrozened whenNotPaused returns (bool){
        require(_tos.length == _values.length);
        uint256 len = _tos.length;
        require(len > 0);
        uint256 amount = 0;
        for (uint256 i = 0; i < len; i = i.add(1)) {
            amount = amount.add(_values[i]);
        }
        require(amount <= balanceOf(msg.sender));
        for (uint256 j = 0; j < len; j = j.add(1)) {
            address _to = _tos[j];
            _transfer(msg.sender, _to,  _values[j]);
        }
        return true;
    }
    
}
