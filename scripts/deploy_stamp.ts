import { ethers, userConfig } from "hardhat";

import dotenv, { parse } from 'dotenv';
dotenv.config();

async function main() {
    // constants
    const ZERO_BYTES32 = '0x0000000000000000000000000000000000000000000000000000000000000000';
    const ZERO_ADDRESS = '0x0000000000000000000000000000000000000000';

    // create signer
    const provider = ethers.provider;
    const privKey = String(process.env.PRIVATE_KEY);
    const signer_wallet = new ethers.Wallet(privKey, provider);
    const signer = signer_wallet.connect(provider);

    const addStampSchemaId = String(process.env.ADD_STAMP_SCHEMA_ID);
    const stampSchemaId = String(process.env.STAMP_SCHEMA_ID);

    // Stamper
    const stamperContract = await ethers.deployContract("Stamper",
        [String(process.env.EAS_ADDR), "Stamper", "1.0.0", addStampSchemaId, stampSchemaId], signer);
    await stamperContract.waitForDeployment();

    // add stamp as an attestation
    const attestationRequestData = {
        recipient: ZERO_ADDRESS,
        expirationTime: 0,
        revocable: false,
        refUID: String(ZERO_BYTES32),
        data: ethers.hexlify(ethers.toUtf8Bytes("localhost:something")),
        value: 0
    };

    const attestation = {
        schema: String(addStampSchemaId),
        data: attestationRequestData
    };

    const txAddStamp = await stamperContract.connect(signer).addStamp(attestation);
    const receiptAddStamp = await txAddStamp.wait();

    const intrfc = new ethers.Interface((await hre.artifacts.readArtifact("EAS")).abi);
    let parsedLog = intrfc.parseLog(receiptAddStamp.logs[0]);
    const [recipient, attester, uid, schema] = parsedLog.args;
    console.log("Stamp attestation id: " + uid);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});