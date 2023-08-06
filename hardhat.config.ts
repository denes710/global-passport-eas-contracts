import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

import "@ethereum-attestation-service/eas-contracts";
import "@ethereum-attestation-service/eas-sdk";

const config: HardhatUserConfig = {
  solidity: "0.8.19",
};

export default config;
