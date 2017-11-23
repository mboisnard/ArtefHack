pragma solidity ^0.4.4;

contract HelloWorld {

	function say() public returns (bytes32) {
		bytes32 res = "Hello World";
		return res;
	}

}
