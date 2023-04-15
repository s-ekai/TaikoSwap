pragma solidity ^0.8.0;

interface BridgeInterface {
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
    function sendMessage( BridgeInterface.Message memory message ) external payable returns (bytes32 msgHash);
}

contract Superposition {

    address public owner;
    address public bridgeContract;
    uint256 public currentMessageId;
    uint256 private nonce;
    uint256 public l1ChainId;
    uint256 public l2ChainId;
    address public l2Contract;

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

    function send() public payable returns (string memory) {
        BridgeInterface bridgeContractInstance = BridgeInterface(bridgeContract);

        BridgeInterface.Message memory message = BridgeInterface.Message(
            534334320,
            msg.sender,
            l1ChainId,
            l2ChainId,
            msg.sender,
            msg.sender,
            address(0),
            msg.value,
            0,
            0,
            0,
            new bytes(0),
            ""
        );
        try bridgeContractInstance.sendMessage(message) returns (bytes32 msgHash) {
            return 'success';
        } catch Error(string memory errorMessage) {
            return errorMessage;
        }

    }


    function getRandom() private returns (uint256) {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(nonce, block.timestamp, block.difficulty, msg.sender)));
        nonce++;
        return randomNumber;
    }
}