import json
from web3 import Web3, HTTPProvider

provider = HTTPProvider("http://localhost:8545")
web3 = Web3(provider)

with open("./build/contracts/HelloWorld.json") as f:
	contractJson = json.load(f)
	nid = list(contractJson["networks"].keys())[0]
	contract = web3.eth.contract(contractJson["abi"], contractJson["networks"][nid]["address"])
	print(contract.call().say())