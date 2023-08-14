import { ethers } from "hardhat";

async function main() {
    // EAS contracts
    const schemaRegistry = await ethers.deployContract("SchemaRegistry");
    await schemaRegistry.waitForDeployment();
    const eas = await ethers.deployContract("EAS", [schemaRegistry.getAddress()]);
    await eas.waitForDeployment();

    // resolvers
    // StampResolver
    const stampSchemaResolver = await ethers.deployContract("StampSchemaResolver", [eas.getAddress()]);
    await stampSchemaResolver.waitForDeployment();
    // AddStampSchemaResolver
    const addStampSchemaResolver = await ethers.deployContract("AddStampSchemaResolver", [eas.getAddress()]);
    await addStampSchemaResolver.waitForDeployment();

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