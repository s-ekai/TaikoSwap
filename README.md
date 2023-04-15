
## PuppeteerTaiko

This app allows you to execute contracts from L1 to L2, hence the name PuppeteerTaiko.

By using cross-chain messaging, it is possible to execute contracts from L1 to L2. The following struct is the current Message being used, but by adding information about which contract and which function to execute, any function can be executed.

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

For example, the following structs can be used to execute functions in the L2 dex:
struct MessageSwap {}
struct MessageProvideLiquidity {}
struct MessageRemoveLiquidity {}

This information is hashed on L1 and sent to L2. On L2, the function on L2 is executed upon receiving this information. The function, such as processMessage, receives the message and executes the function depending on the type of the message. The relayer will ultimately execute the functions mentioned above (and will be incentivized accordingly). By defining such functionality, cross-chain swaps can be achieved, for example.