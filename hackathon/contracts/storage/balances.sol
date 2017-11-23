pragma solidity ^0.4.4;

import '../utils/utils.sol';


contract Balances {

  struct Balance {
    int balance;
    uint idx;
  }

  address owner;
  mapping(address => Balance) public balances;
  address[] index;

  function Balances() public {
    owner = tx.origin;
  }

  function fund(int value) public {
    require(tx.origin == owner);
    updateBalance(tx.origin, value);
  }

  function create(address addr) public {
    require(!exists(addr));
    balances[addr].idx = index.push(addr)-1;
    balances[addr].balance = 0;
  }

  function pay(address from, address to, int value) public returns (bool success) {
    if (!(exists(from) && balances[from].balance > value && exists(to))) {
      return false;
    }
    updateBalance(from, -value);
    updateBalance(to, value);

    return true;
  }

  function exists(address addr) public constant returns(bool) {
    return (index.length > 0 && index[balances[addr].idx] == addr);
  }

  function getBalance(address addr) public returns(int) {
    require(exists(addr));
    return balances[addr].balance;
  }

  function updateBalance(address addr, int updateAmount) private {
      balances[addr].balance = balances[addr].balance + updateAmount;
  }
}
