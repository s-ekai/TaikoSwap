const Puppeteer = artifacts.require("Puppeteer");

module.exports = function(deployer) {
  deployer.deploy(
    Puppeteer,
    '0x11013a48Ad87a528D23CdA25D2C34D7dbDA6b46b'
  );
};