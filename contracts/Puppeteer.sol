pragma solidity ^0.8.0;

interface SignalServiceInterface {
    function sendSignal(bytes32 signal) external returns (bytes32 storageSlot);
}

contract Puppeteer {

    address public SignalServiceContract;

    constructor(address _SignalServiceContract) public {
        SignalServiceContract = _SignalServiceContract;
    }

    // INFO: it sends signal to l2
    function sendSignal() public payable returns (string memory) {
        SignalServiceInterface SignalService = SignalServiceInterface(SignalServiceContract);
        bytes32 tmp = bytes32(0);
        bytes32 result = SignalService.sendSignal(tmp);
    }
}