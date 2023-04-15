## TaikoPuppeteer

The project aims to enable cross-chain swaps between Ethereum and Taiko using Taiko's cross-chain messaging. When a user wants to swap L1 USDC for L2 USDT, the USDC is first sent to TaikoSwap on L1, and then TaikoSwap sends that information to SignalService. If the signal is confirmed on TaikoSwap on L2, TaikoSwap sends USDT to the user.


The current message format for the bridge is as follows, but it will be changed to a format suitable for cross-chain swaps.


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


The message contains information on which tokens to swap and at what rate.

The basic configuration for creating a prototype is as follows:

- [ ] Create a simple DEX on L1.
- [ ] Create a feature on the DEX to enable cross-chain swaps.
- [ ] Specifically, the DEX will hold the tokens before the swap and convert that information into the message format and then save it as a signal in the SignalService.
- [ ] Create a simple DEX on L2.
- [ ] When the L2 DEX contract receives the above signal, it will send the user the swapped tokens.
- [ ] The above process is similar to proccessMessage and can be executed by either the user or a relayer.
- [ ] Note that if the L1 DEX does not confirm that the processing on L2 has been executed correctly, it will store the tokens in the vault within the DEX.
- [ ] If the process fails, the tokens will be returned to the user from the vault.

