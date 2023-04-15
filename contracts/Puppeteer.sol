pragma solidity ^0.8.0;

interface ISignalService {
    function isSignalReceived(uint256 srcChainId, address app, bytes32 signal, bytes calldata proof) external view returns (bool);
}

contract Puppeteer {

    ISignalService private iSignalService;

    struct Message {
        address asker;
        address distContract;
        bytes32 funcSig;
    }

    constructor(address _SignalServiceContract) public {
        iSignalService = ISignalService(_SignalServiceContract);
    }

    // INFO: make message hashed and send it as a signal
    function execute(uint256 srcChainId, address app, Message memory message, bytes calldata proof) public returns (bytes32) {

        bytes32 signal = keccak256(abi.encode("TAIKO_BRIDGE_MESSAGE", message));
        bool isSignalReceived = iSignalService.isSignalReceived(srcChainId, app, signal, proof);

        if (isSignalReceived) {
        }

        // bytes32 funcSig = bytes4(keccak256(abi.encodePacked(functionName)));

        // Message memory message = Message({
        //     asker: msg.sender,
        //     distContract: distContract,
        //     funcSig: funcSig
        // });

        // bytes32 signal = keccak256(abi.encode("TAIKO_BRIDGE_MESSAGE", message));
        // bytes32 result = iSignalService.sendSignal(signal);
        // return result;
    }
}