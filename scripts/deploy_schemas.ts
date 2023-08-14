import { ethers } from "hardhat";

import dotenv from 'dotenv';
dotenv.config();

async function main() {
    // resolvers
    // StampResolver
    const stampSchemaResolver = await ethers.deployContract("StampSchemaResolver", [String(process.env.EAS_ADDR)]);
    await stampSchemaResolver.waitForDeployment();
    // AddStampSchemaResolver
    const addStampSchemaResolver = await ethers.deployContract("AddStampSchemaResolver", [String(process.env.EAS_ADDR)]);
    await addStampSchemaResolver.waitForDeployment();

    // get SchemaRegistry
    const schemaRegistry = await ethers.getContractAt("SchemaRegistry", String(process.env.SCHEMA_REGISTRY_ADDR));

    // schemas
    // AddStamp
    const txAddSchema = await schemaRegistry.register('string uri', addStampSchemaResolver.getAddress(), false);
    const receiptAddSchema = await txAddSchema.wait()
    const [uidAddSchema,] = receiptAddSchema.logs[0].args;
    console.log("AddStampSchemaId: " + uidAddSchema);

    // Stamp
    const txStampSchema = await schemaRegistry.register('', stampSchemaResolver.getAddress(), false);
    const receiptStampSchema = await txStampSchema.wait();
    const [uidStampSchema,] = receiptStampSchema.logs[0].args;
    console.log("StampSchemaId: " + uidStampSchema);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});