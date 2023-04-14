const Superposition = artifacts.require("Superposition");

module.exports = function(deployer) {
  deployer.deploy(
    Superposition,
    '0x2aB7C0ab9AB47fcF370d13058BfEE28f2Ec0940c',
    11155111,
    167002
  );
};