pragma solidity ^0.4.4;

import '../storage/roles.sol';
import '../utils/utils.sol';

contract Role {
  address public owner;
  RolesStorage roles;

  function Role(address _roles) public {
    owner = tx.origin;
    roles = RolesStorage(_roles);
  }

  function setRole(address _from, string role) public {
    roles.setRole(_from, role);
  }

  modifier isRole(string role) {
    require(roles.isAuthorizedRole(role));
    require(Utils.stringToBytes32(role) == roles.getRole(tx.origin));

    _;
  }
}
