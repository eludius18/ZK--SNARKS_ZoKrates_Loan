import { ethers, run } from "hardhat";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { constants } from "ethers";
import { Address, Deployment } from "hardhat-deploy/types";
import { TokenERC20 } from "../typechain-types";


const delay = (ms: number) => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};

const deploy: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deployer } = await getNamedAccounts();
  const { deploy } = deployments;
  const erc20ContractAddress = "0x7eA9377F8CB4AA84560256f1b79a7d6c7b671E91";

  const zkerc20loan = await deploy("zkERC20Loan", {
    from: deployer,
    args: [],
    log: true,
    proxy: {
      proxyContract: "OpenZeppelinTransparentProxy",
      execute: {
        init: {
          methodName: "initialize",
          args: [
            erc20ContractAddress
          ],
        },
      },
    },
    waitConfirmations: 10,
  });

  console.log("zkERC20Loan deployed at: ", zkerc20loan.address);
  await delay(5000);
  const zkerc20loanImpl = await deployments.get("zkERC20Loan_Implementation");
  
  
  await run("verify:verify", {
    address: zkerc20loanImpl.address,
    contract: "contracts/ZKERC20Loan.sol:zkERC20Loan",
    initializerArguments: erc20ContractAddress,
  });

  const tokenERC20Deployment: Deployment = await deployments.get("TokenERC20");
  const tokenERC20Deployed: TokenERC20 = await ethers.getContractAt(
    "TokenERC20",
    tokenERC20Deployment.address
  );

  // Mint and approve tokens in zkERC20Loan contract
  const amountToMint = ethers.utils.parseEther("100000000000000000000000000000000000"); // Define the amount of tokens to mint

  // Mint new tokens to the contract address
  await tokenERC20Deployed.mint(zkerc20loan.address, amountToMint);

  // Approve the contract to spend the desired amount of tokens
  await tokenERC20Deployed.approve(zkerc20loan.address, amountToMint);
  
};

deploy.tags = ["zkERC20Loan"];
export default deploy;