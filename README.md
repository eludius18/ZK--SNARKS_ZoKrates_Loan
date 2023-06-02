# Bank Transfer zkSNARKs ZoKrates
## Install Dependencies

```shell
npm install
```

## Build ZoKrates

```shell
git clone git@github.com:Zokrates/ZoKrates.git
cd ZoKrates
npm i
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
def main(private field debtToIR, private field incomeRatio, private field Age) {
    assert(debtToIR >= 700, "Debt-to-Income Ratio must be above 700");
    assert(incomeRatio >= 36, "Income Ratio must be above 36%");
    assert(Age >= 18, "You must be at least 18 years old");
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

## Compute Witness 

debtToIR = 700
incomeRatio = 38
Age = 21

```shell
./zokrates compute-witness -a 700 38 21
./zokrates generate-proof
```

```shell
[["0x230aa99c4ff7ee82c3ede7e344533f745393e57c6e6cf7fe5f43f3395458e736","0x15b108a55493d3b8498620d27948a7c420f5bc404341689b7c93fbcc1ff21b0e"],[["0x09b10634a5d936dfa744bd0d00bbce1dfc1b7778793456f0b1840f5989d761a9","0x141a09eec51719e17ee06f2a806f0de673c1bee7c56ebbae30dadbe08988a9b3"],["0x24f28baa0291a5e29f0999c28e32a10753b2aeb1cfe1f5edfa82e9a691a04b4b","0x170f13c6126f76630e16e419d2d0a59975a0715c28d54c77f0cd203abecefb33"]],["0x29870e69d5c6ba62d71c849e227ed0a19e047aa4a1eba3e39b97c53cc0c8aa6c","0x1a863e0c89ac4491bdf6dcde8ce857d586d8ca39db11026269828b51eed09df1"]]
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
npx hardhat deploy --network <blockchain-network> --tags zkERC20Loan
```
