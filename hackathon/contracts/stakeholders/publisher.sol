pragma solidity ^0.4.4;

import '../storage/catalogue.sol';
import '../storage/balances.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract Publisher is Role {

	address public publisher;
	Balances public balances;
	Catalogue public catalogue;
	bytes32[] public contents;

	uint PUBLISHER_COMPENSATION = 50;

	function Publisher(address _catalogue, address _balances, address _roles) Role(_roles) public{
		catalogue = Catalogue(_catalogue);
		balances = Balances(_balances);
	}

	function insertContent(bytes32 identifier, uint preference) isRole('Publisher') public returns (uint idx) {
		// TODO test indexes
		uint res = contents.push(identifier)-1;
		catalogue.insert(res, preference);
		return res;
	}

	function setPublisher(address _publisher) isRole('Admin') public {
		publisher = _publisher;
	}

	function buyContent(address _from, uint catalogueId) public returns (bytes32 content, uint pref) {
		require(publisher > 0);
		if (balances.pay(_from, publisher, int(PUBLISHER_COMPENSATION))) {
			uint preference;
			uint idx;
			(preference, idx) = catalogue.get(catalogueId);

			return (contents[catalogueId], preference);
		}
		return ("", 0);
	}
}
