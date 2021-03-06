
pragma solidity ^0.4.24;

import "lock.sol";
import "reentrancy.sol";
import "safemath.sol";

contract Lock is ReentrancyGuard {
    using SafeMath for uint256;
    struct LockInfo {
        uint256 startedDate;
        uint256 endDate;
        uint256 amount;
        address tokenAddress;
        address managerAddress;
    }

    uint256 public poolCount = 0;
    LockInfo public pool;

    modifier onlyManager() {
        require(msg.sender == pool.managerAddress);
        _;
    }

    function lockTokens(
        uint256 _endDate,
        uint256 _amount,
        address _tokenAddress
    ) external nonReentrant {
        require(now < _endDate, "endDate should be bigger than now");
        require(_amount != 0, "amount cannot 0");
        require(
            _tokenAddress != address(0),
            "Token adress cannot be address(0)"
        );
        require(
            IERC20(_tokenAddress).transferFrom(
                msg.sender,
                address(this),
                _amount
            ),
            "Transaction failed"
        );
        require(poolCount == 0, "Pool count must be 0");
        pool = LockInfo(now, _endDate, _amount, _tokenAddress, msg.sender);
        poolCount = poolCount.safeAdd(1);
    }

    function getPoolData()
        external
        view
        returns (
            uint256,
            uint256,
            uint256,
            address,
            address
        )
    {
        return (
            pool.startedDate,
            pool.endDate,
            pool.amount,
            pool.tokenAddress,
            pool.managerAddress
        );
    }

    function getTokens() external onlyManager nonReentrant {
        require(now > pool.endDate);
        IERC20(pool.tokenAddress).transfer(msg.sender, pool.amount);
    }
}