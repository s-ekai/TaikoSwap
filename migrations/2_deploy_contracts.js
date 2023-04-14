const Superpositon = artifacts.require("Superpositon");

module.exports = function(deployer) {
  deployer.deploy(Superpositon, 100000);
};