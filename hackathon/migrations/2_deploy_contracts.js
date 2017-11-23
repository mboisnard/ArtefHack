var artefhack = artifacts.require("ArtefHack");
var publisher = artifacts.require("Publisher");

var balances = artifacts.require("Balances");
var catalogue = artifacts.require("Catalogue");

var roles = artifacts.require("RolesStorage");
var utils = artifacts.require("Utils");

module.exports = function(deployer) {
  deployer.deploy(utils).then(function(){
    return deployer.link(utils, [artefhack, publisher, roles]).then(function(){
      return deployer.deploy(roles).then(function() {
        return deployer.deploy(balances).then(function() {
          return deployer.deploy(catalogue).then(function() {
            return deployer.deploy(publisher, catalogue.address, balances.address, roles.address).then(function() {
              return deployer.deploy(artefhack, balances.address, publisher.address, roles.address, catalogue.address);
            });
          });
        });
      });
    });
  });
};
