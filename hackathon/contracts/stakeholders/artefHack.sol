pragma solidity ^0.4.4;

import '../stakeholders/publisher.sol';
import '../storage/catalogue.sol';
import '../utils/roles.sol';
import '../utils/utils.sol';


contract ArtefHack is Role {
	Balances private balances;
	address public artefhack;

	Catalogue public catalogue;
  Publisher public publisher;

	struct UserResult {
		bytes32 content;
		bool message;
		bool score;
	}

	bytes32 firstContent;
	mapping(address => UserResult[]) results;

	function ArtefHack(address _balances, address _publisher, address _roles, address _catalogue) Role(_roles) public {
	    balances = Balances(_balances);
	    publisher = Publisher(_publisher);
	    catalogue = Catalogue(_catalogue);
	}
	
	function publish(uint catalogueId) public returns (bytes32) {
		uint preference;
		bytes32 content;
		(content, preference) = publisher.buyContent(artefhack, catalogueId);
		return content;
	}

	function setArtefHack(address _artefhack) public isRole("Admin") {
		artefhack = _artefhack;
	}

	function visit() public isRole("User") returns (bytes32, bool) {
		require(artefhack > 0);
		//TODO
		bool message = true;
		if(firstContent == ""){
			firstContent = publish(0);
		}
  	return (firstContent, message);
	}

	function eval(bytes32 content, bool message, bool score) public isRole("User") {
		UserResult result;
		result.content = content;
		result.message = message;
		result.score = score;

		results[msg.sender].push(result);
	}
}
