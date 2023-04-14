pragma solidity ^0.8.0;


contract Superposition {

    address public owner;
    address public bridgeContract;
    uint256 public currentMessageId;
    uint256 private nonce;
    uint256 public l1ChainId;
    uint256 public l2ChainId;
    address public l2Contract;

    struct Message {
        uint256 id;
        address sender;
        uint256 srcChainId;
        uint256 destChainId;
        address owner;
        address to;
        address refundAddress;
        uint256 depositValue;
        uint256 callValue;
        uint256 processingFee;
        uint256 gasLimit;
        bytes data;
        string memo;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    constructor(address _bridgeContract, uint256 _l1ChainId, uint256 _l2ChainId) public {
        owner = msg.sender;
        bridgeContract = _bridgeContract;
        l1ChainId = _l1ChainId;
        l2ChainId = _l2ChainId;

        l2Contract = msg.sender;
    }

    function send(uint _amount) public payable {

        Message memory message = Message(
            getRandom(),
            msg.sender,
            l1ChainId,
            l2ChainId,
            msg.sender,
            msg.sender,
            address(0),
            _amount,
            0,
            0,
            0,
            new bytes(0),
            ""
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