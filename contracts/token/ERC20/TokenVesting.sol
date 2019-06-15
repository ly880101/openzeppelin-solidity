
pragma solidity ^0.5.0;

import "./SafeERC20.sol";
import "../../math/SafeMath.sol";
import "./IERC20.sol";
import "../../ownership/Ownable.sol";


/**
 * @title TokenVesting
 * @dev A token holder contract that can release its token balance gradually like a
 * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
 * owner.https://www.jianshu.com/p/db7cb9431ecc
 */
contract TokenVesting is Ownable {
  using SafeMath for uint256;
  using SafeERC20 for IERC20;

  event Released(uint256 amount);
  event Revoked();

  // beneficiary of tokens after they are released
  address public beneficiary;

  uint256 public cliff;
  uint256 public start;
  uint256 public releaseGap;
  uint256 public duration;
  uint256 public totalSeg;

  bool public revocable;

  mapping (address => uint256) private released;
  mapping (address => bool) private revoked;

  /**
   * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
   * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
   * of the balance will have vested.
   * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
   * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
   * @param _start the time (as Unix time) at which point vesting starts
   * @param _duration duration in seconds of the period in which the tokens will vest
   * @param _revocable whether the vesting is revocable or not
   */
  constructor(
    address _beneficiary,
    uint256 _start,
    uint256 _cliff,
    uint256 _duration,
    uint256 _releaseGap,
    bool _revocable
  )
    public
  {
    require(_beneficiary != address(0));
    require(_cliff <= _duration);
    require(_releaseGap > 0);

    beneficiary = _beneficiary;
    revocable = _revocable;
    releaseGap = _releaseGap;
    duration = _duration;
    totalSeg = _duration.div(_releaseGap);
    cliff = _start.add(_cliff);
    start = _start;
  }

  /**
   * @notice Transfers vested tokens to beneficiary.
   * @param _token Colorbay token which is being vested
   */
  function release(IERC20 _token) public {
    uint256 unreleased = releasableAmount(_token);

    require(unreleased > 0, 'ERC20 release unreleased <= 0');

    released[address(_token)] = released[address(_token)].add(unreleased);

    _token.safeTransfer(beneficiary, unreleased);

    emit Released(unreleased);
  }

  /**
   * @notice Allows the owner to revoke the vesting. Tokens already vested
   * remain in the contract, the rest are returned to the owner.
   * @param _token ERC20 token which is being vested
   */
  function revoke(IERC20 _token) public onlyOwner {
    require(revocable);
    require(!revoked[address(_token)]);

    uint256 balance = _token.balanceOf(address(this));

    uint256 unreleased = releasableAmount(_token);
    if(unreleased > 0){
        released[address(_token)] = released[address(_token)].add(unreleased);
        _token.safeTransfer(beneficiary, unreleased);
    }
    revoked[address(_token)] = true;
    uint256 refund = balance.sub(unreleased);
    _token.safeTransfer(owner(), refund);

    emit Revoked();
  }

  /**
   * @dev Calculates the amount that has already vested but hasn't been released yet.
   * @param _token Colorbay token which is being vested
   */
  function releasableAmount(IERC20 _token) public view returns (uint256) {
    return vestedAmount(_token).sub(released[address(_token)]);
  }

  /**
   * @dev Calculates the amount that has already vested.
   * @param _token ERC20 token which is being vested
   */
  function vestedAmount(IERC20 _token) public view returns (uint256) {
    uint256 currentBalance = _token.balanceOf(address(this));
    uint256 totalBalance = currentBalance.add(released[address(_token)]);
    
    if (block.timestamp < cliff) {
        return 0;
    } else if (block.timestamp >= start.add(duration) || revoked[address(_token)]) {
        return totalBalance;
    } else {
        uint256 a = block.timestamp.sub(start).div(releaseGap);
        if(a > 0){
            return totalBalance.mul(a).div(totalSeg);
        }else{
            return 0;
        }
    }
  }
  
  function isRevoked(IERC20 _token) public view returns (bool){
      return revoked[address(_token)];
  }
  
  function releasedCoin(IERC20 _token) public view returns (uint256){
      return released[address(_token)];
  }
  
  function balanceOf(IERC20 _token) public view returns  (uint256){
      return _token.balanceOf(address(this));
  }
  
  
  
}