# ArtefHack setup

## Prerequisites
install npm: https://www.npmjs.com/get-npm
install virtualenv for a clean setup: https://virtualenv.pypa.io/en/stable/
install python3

## Install Truffle to compile and deploy your contracts easily
npm install -g truffle
npm install

## Install testrpc to run a local blockchain
npm install -g ethereumjs-testrpc
testrpc

## Compile your contract and deploy it to your local blockchain. A 'build' directory should have appeared after this step.
truffle migrate

## Setup the python3 environment
virtualenv -p python3 ~/.venv-py3
source ~/.venv-py3/bin/activate
pip install web3

## run the script to check everythings worked
python3 helloworld.py

# You are now ready for the ArtefHack ! Good luck !
