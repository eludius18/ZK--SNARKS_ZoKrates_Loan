# Bank Transfer zkSNARKs ZoKrates
## Build ZoKrates

```shell
git clone git@github.com:Zokrates/ZoKrates.git
cd ZoKrates
export ZOKRATES_STDLIB=$PWD/zokrates_stdlib/stdlib
cargo +nightly build --release
```
## Creates zkBank.code

```shell
cd ZoKrates/target/release
mkdir code
cd code && touch zkBank.code
```

## zkBank.code
```shell
def main(private field amountToTransfer) {
    assert(amountToTransfer >= 100, "amount is less than 100");
}
```

## Execute all in zoKrates

```shell
cd ZoKrates/target/release
./zokrates compile -i code/zkBank.code
./zokrates setup
./zokrates compute-witness -a <value for witness>
./zokrates generate-proof
./zokrates export-verifier
```

## Set Proof.json in tuple

```shell
[["0x2d6c3f4c6301b129bcd912ece230ed77f0bbff6c19712bc743252079c1751851","0x1ee0a2eb1fba458af5eeb5d20c7245171aa464975e982c665a4e150568760f0e"],[["0x1ce3c990ebde26fef517f78069450702cbe5ccb8ba838dc7d5d55c0a89047eb8","0x1b928d7814d6094831ef7eae0c27f3e2735c97dd5f817a557bf1700778828fee"],["0x02dcf617e9b0784e58eb50d3de843cd2eceefe02a56a1a0549e28e3b54c31c3a","0x1d285f8e2059bdb3f32d01e757d93dd5adb002d3dff928acad8060ce76c59da7"]],["0x1f08dd63073709becc285a046fb82925e5a0cf61f171709f2ed5cee7a69ddded","0x08b17e3a733d435682bace1472eef9875f47b678f4de21e552d968fc4dd8b3a1"]]
```
## Create new Proofs using new Witness values

```shell
./zokrates compute-witness -a <value for witness>
./zokrates generate-proof
```

## Deploy TokenERC20 Smart Contract

```shell
npx hardhat deploy --network <blockchain-network> --tags TokenERC20
```

## Deploy zkERC20Transfer Smart Contract

```shell
npx hardhat deploy --network <blockchain-network> --tags zkERC20Transfer
```
