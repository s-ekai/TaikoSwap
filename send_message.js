const HDWalletProvider = require('@truffle/hdwallet-provider');
const Web3 = require('web3');
require('dotenv').config();
const NODEENDPOINT = process.env.NODEENDPOINT;
const MNEMONIC = process.env.MNEMONIC;
const PRIVATEKEY = process.env.PRIVATEKEY;
const contractABI = [
    {
      type: "function",
      stateMutability: "view",
      outputs: [{ type: "address", name: "", internalType: "address" }],
      name: "addressManager",
      inputs: [],
    },
    {
      type: "function",
      stateMutability: "pure",
      outputs: [{ type: "bytes32", name: "", internalType: "bytes32" }],
      name: "getSignalSlot",
      inputs: [
        { type: "address", name: "app", internalType: "address" },
        { type: "bytes32", name: "signal", internalType: "bytes32" },
      ],
    },
    {
      type: "function",
      stateMutability: "nonpayable",
      outputs: [],
      name: "init",
      inputs: [{ type: "address", name: "_addressManager", internalType: "address" }],
    },
    {
      type: "function",
      stateMutability: "view",
      outputs: [{ type: "bool", name: "", internalType: "bool" }],
      name: "isSignalReceived",
      inputs: [
        { type: "uint256", name: "srcChainId", internalType: "uint256" },
        { type: "address", name: "app", internalType: "address" },
        { type: "bytes32", name: "signal", internalType: "bytes32" },
        { type: "bytes", name: "proof", internalType: "bytes" },
      ],
    },
    {
      type: "function",
      stateMutability: "view",
      outputs: [{ type: "bool", name: "", internalType: "bool" }],
      name: "isSignalSent",
      inputs: [
        { type: "address", name: "app", internalType: "address" },
        { type: "bytes32", name: "signal", internalType: "bytes32" },
      ],
    },
    {
      type: "function",
      stateMutability: "view",
      outputs: [{ type: "address", name: "", internalType: "address" }],
      name: "owner",
      inputs: [],
    },
    {
      type: "function",
      stateMutability: "nonpayable",
      outputs: [],
      name: "renounceOwnership",
      inputs: [],
    },
    {
      type: "function",
      stateMutability: "view",
      outputs: [{ type: "address", name: "", internalType: "address payable" }],
      name: "resolve",
      inputs: [
        { type: "string", name: "name", internalType: "string" },
        { type: "bool", name: "allowZeroAddress", internalType: "bool" },
      ],
    },
    {
      type: "function",
      stateMutability: "view",
      outputs: [{ type: "address", name: "", internalType: "address payable" }],
      name: "resolve",
      inputs: [
        { type: "uint256", name: "chainId", internalType: "uint256" },
        { type: "string", name: "name", internalType: "string" },
        { type: "bool", name: "allowZeroAddress", internalType: "bool" },
      ],
    },
    {
      type: "function",
      stateMutability: "nonpayable",
      outputs: [{ type: "bytes32", name: "storageSlot", internalType: "bytes32" }],
      name: "sendSignal",
      inputs: [{ type: "bytes32", name: "signal", internalType: "bytes32" }],
    },
    {
      type: "function",
      stateMutability: "nonpayable",
      outputs: [],
      name: "transferOwnership",
      inputs: [{ type: "address", name: "newOwner", internalType: "address" }],
    },
    {
      type: "event",
      name: "Initialized",
      inputs: [{ type: "uint8", name: "version", indexed: false }],
      anonymous: false,
    },
    {
      type: "event",
      name: "OwnershipTransferred",
      inputs: [
        { type: "address", name: "previousOwner", indexed: true },
        { type: "address", name: "newOwner", indexed: true },
      ],
      anonymous: false,
    },
    { type: "error", name: "B_NULL_APP_ADDR", inputs: [] },
    { type: "error", name: "B_WRONG_CHAIN_ID", inputs: [] },
    { type: "error", name: "B_ZERO_SIGNAL", inputs: [] },
    { type: "error", name: "RESOLVER_DENIED", inputs: [] },
    { type: "error", name: "RESOLVER_INVALID_ADDR", inputs: [] },
  ];
const contractAddress = '0x11013a48Ad87a528D23CdA25D2C34D7dbDA6b46b'; // コントラクトのアドレス
const provider = new HDWalletProvider(MNEMONIC, NODEENDPOINT);
const web3 = new Web3(provider);

const contractInstance = new web3.eth.Contract(contractABI, contractAddress);
const signal = '0xaaa';
const data = contractInstance.methods.sendSignal(signal).encodeABI()
const fromAddress = '0x95da7875663Eaaf33521ccd5cf93B245577B5e7e'; // ニーモニックに対応するアドレス

async function sendTransaction() {

    try {
      const nonce = await web3.eth.getTransactionCount(fromAddress, 'pending');
      const rawTx = {
        nonce: web3.utils.toHex(nonce),
        to: contractAddress,
        'gas': 30000,
        'maxFeePerGas': 100000,
        value: '0',
        data: data,
        chainId: 11155111
      };
      console.log(rawTx);
      const signedTx = await web3.eth.accounts.signTransaction(rawTx, PRIVATEKEY);
      const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
      console.log('Transaction receipt:', receipt);
    } catch (error) {
      console.error('Error sending transaction:', error);
    }
}

(async function(){
    await sendTransaction();
})();