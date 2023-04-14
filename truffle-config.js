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
      provider: () => new HDWalletProvider(MNEMONIC, NODEENDPOINT, {timeout: 120000}),
      network_id: '11155111',
      gas: 14465030
    },
  },
  compilers: {
    solc: {
      version: '0.8.0',
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
