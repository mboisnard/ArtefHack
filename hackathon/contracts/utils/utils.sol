pragma solidity ^0.4.4;

library Utils {

	function compare(string _a, string _b) public returns (int) {
		bytes memory a = bytes(_a);
		bytes memory b = bytes(_b);
		uint minLength = a.length;
		if (b.length < minLength) minLength = b.length;
		for (uint i = 0; i < minLength; i ++)
			if (a[i] < b[i])
				return -1;
			else if (a[i] > b[i])
				return 1;
		if (a.length < b.length)
			return -1;
		else if (a.length > b.length)
			return 1;
		else
			return 0;
	}

	function stringToBytes32(string memory source) public returns (bytes32 result) {
	    assembly {
	        result := mload(add(source, 32))
	    }
	}

	function bytes32ToString(bytes32 x) public constant returns (string) {
	    bytes memory bytesString = new bytes(32);
	    uint charCount = 0;
	    for (uint j = 0; j < 32; j++) {
	        byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
	        if (char != 0) {
	            bytesString[charCount] = char;
	            charCount++;
	        }
	    }
	    bytes memory bytesStringTrimmed = new bytes(charCount);
	    for (j = 0; j < charCount; j++) {
	        bytesStringTrimmed[j] = bytesString[j];
	    }
	    return string(bytesStringTrimmed);
	}

}
