pragma solidity ^0.8.0;

interface SignalServiceInterface {
    function sendSignal(bytes32 signal) external returns (bytes32 storageSlot);
}

contract Puppeteer {

    address public SignalServiceContract;

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
        bytes32 executeOption;
    }

    constructor(address _SignalServiceContract) public {
        SignalServiceContract = _SignalServiceContract;
    }

    // INFO: make message hashed and send it as a signal
    function sendSignal(Message memory message) public payable returns (string memory) {
        bytes32 signal = keccak256(abi.encode("TAIKO_BRIDGE_MESSAGE", message));
        SignalServiceInterface SignalService = SignalServiceInterface(SignalServiceContract);
        bytes32 result = SignalService.sendSignal(signal);
    }
}