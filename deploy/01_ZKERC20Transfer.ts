import { ethers, run } from "hardhat";
import { DeployFunction } from "hardhat-deploy/types";
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { constants } from "ethers";

const delay = (ms: number) => {
  return new Promise((resolve) => setTimeout(resolve, ms));
};

const deploy: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployments, getNamedAccounts } = hre;
  const { deployer } = await getNamedAccounts();
  const { deploy } = deployments;
  const erc20ContractAddress = "0x4a59c702Eef953Bf8E708189F9A81D8C3A544481";

  const zkerc20transfer = await deploy("zkERC20Transfer", {
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

  console.log("zkERC20Transfer deployed at: ", zkerc20transfer.address);
  await delay(5000);
  const zkerc20transferImpl = await deployments.get("zkERC20Transfer_Implementation");
  
  
  await run("verify:verify", {
    address: zkerc20transferImpl.address,
    contract: "contracts/ZKERC20Transfer.sol:zkERC20Transfer",
  });
  
};

deploy.tags = ["zkERC20Transfer"];
export default deploy;