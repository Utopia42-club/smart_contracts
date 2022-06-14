// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IBrightID {
    event Verified(address indexed addr);
    function isVerified(address addr) external view returns (bool);
}
