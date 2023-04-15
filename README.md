
## TaikoPuppeteer

This app allows you to execute contracts from L1 to L2, hence the name TaikoPuppeteer.

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

However, having multiple Message structures as shown above is not very versatile. Therefore, we define an existing attribute bytes32 executeOption. The first 20 bytes represent the contract address, and the next 12 bytes represent the function name. For simplicity, we do not consider the arguments for now. To support arguments, we can use bytes executeOption and specify the number of arguments after the function name, followed by the data type and value for each argument.


注意: トークンを扱う処理をする場合はL2側で実行されるコントラクトがSignalServiceにトークンを扱えるようにapproveしておく必要がある。



しかし今回のケースではトークンを扱うと非常に難解になるためにトークンを使わない、
l1からl2のコントラクトを叩いてL2のコントラクで管理してる値を変更する様なコードを書きます。
processMessageの処理はブリッジと密接につながっており、今回のハッカソンでそちらまで対応するのは不可能だと判断したため。

今回のアプリケーションでは、
L1からsendSignalをする。
L2でsignalを受け取ったらそのシグナルをもとに実行する。
メッセージの形式は下記の様な簡単なものを扱います。

struct Message {
    address asker;
    address contract;
    bytes funcSig;
}


counterは勝手にこれを使わせてもらおう。
// https://explorer.a2.taiko.xyz/address/0x969106382BB5def3Bb17B986311ee3FbFEb77a62/contracts#address-tabs
