const HDWalletProvider = require('@truffle/hdwallet-provider');
require('dotenv').config();
const NODEENDPOINT = process.env.NODEENDPOINT;
const MNEMONIC = process.env.MNEMONIC;

module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*',
    },
    sepolia: {
      provider: () => new HDWalletProvider(MNEMONIC, NODEENDPOINT),
      network_id: 11155111,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
  },
  compilers: {
    solc: {
      version: '0.8.9',
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
