var helloworld = artifacts.require("HelloWorld");

module.exports = function(deployer) {
  deployer.deploy(helloworld);
};
