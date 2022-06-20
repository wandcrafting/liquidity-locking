pragma solidity ^0.4.24;

library SafeMath {
    function safeAdd(uint256 a, uint256 b) external pure returns (uint256 c) {
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint256 a, uint256 b) external pure returns (uint256 c) {
        require(b <= a);
        c = a - b;
    }

    function safeMul(uint256 a, uint256 b) external pure returns (uint256 c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function safeDiv(uint256 a, uint256 b) external pure returns (uint256 c) {
        require(b > 0);
        c = a / b;
    }
}