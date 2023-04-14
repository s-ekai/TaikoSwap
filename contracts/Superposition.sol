pragma solidity ^0.8.0;


contract Superpositon {

    address public owner;
    address public bridgeContract;
    uint256 public currentMessageId;
    uint256 private nonce;
    uint256 public l1ChainId;
    uint256 public l2ChainId;
    // it means superposition l2 contract.
    address public l2Contract;

    // INFO: it is defined here: https://github.com/taikoxyz/taiko-mono/blob/main/packages/protocol/contracts/bridge/IBridge.sol
    struct Message {
        // Message ID.
        uint256 id;
        // Message sender address (auto filled).
        address sender;
        // Source chain ID (auto filled).
        uint256 srcChainId;
        // Destination chain ID where the `to` address lives (auto filled).
        uint256 destChainId;
        // Owner address of the bridged asset.
        address owner;
        // Destination owner address.
        address to;
        // Alternate address to send any refund. If blank, defaults to owner.
        address refundAddress;
        // Deposited Ether minus the processingFee.
        uint256 depositValue;
        // callValue to invoke on the destination chain, for ERC20 transfers.
        uint256 callValue;
        // Processing fee for the relayer. Zero if owner will process themself.
        uint256 processingFee;
        // gasLimit to invoke on the destination chain, for ERC20 transfers.
        uint256 gasLimit;
        // callData to invoke on the destination chain, for ERC20 transfers.
        bytes data;
        // Optional memo.
        string memo;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    constructor(address _rewardToken, address _bridgeContract, uint256 _l1ChainId, uint256 _l2ChainId) public {
        owner = msg.sender;
        // INFO: Bridge Contract on sepolia. it must be 0x2aB7C0ab9AB47fcF370d13058BfEE28f2Ec0940c。
        bridgeContract = _bridgeContract;
        l1ChainId = _l1ChainId;
        l2ChainId = _l2ChainId;
    }

    // info: send ETH to taiko bridge contract
    function send(uint _amount) public payable {

        Message memory message = Message(
            getRandom(), // Message ID.
            msg.sender,  // Message sender address (auto filled).
            l1ChainId, // Source chain ID (auto filled).
            l2ChainId, // Destination chain ID where the `to` address lives (auto filled).
            msg.sender, // Owner address of the bridged asset. TODO: I don't think I understand well
            l2Contract, // Destination owner address.
            address(0),// Alternate address to send any refund. If blank, defaults to owner.
            _amount, // Deposited Ether minus the processingFee.
            0, // callValue to invoke on the destination chain, for ERC20 transfers.
            0, // Processing fee for the relayer. Zero if owner will process themself. // TODO: fix this value to make relayer do thir work
            0, // gasLimit to invoke on the destination chain, for ERC20 transfers.
            bytes(0), // callData to invoke on the destination chain, for ERC20 transfers.
            ""// Optional memo.
        );

        bytes memory payload = abi.encodeWithSignature("sendMessage(Message)", message);
        (bool success, bytes memory result) = bridgeContract.call(payload);
        require(success, "Call failed");
    }


    function getRandom() private returns (uint256) {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(nonce, block.timestamp, block.difficulty, msg.sender)));
        nonce++;
        return randomNumber;
    }
}