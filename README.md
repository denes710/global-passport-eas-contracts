Run a local blockchain:
```
npx hardhat node
```

In another terminal, deploy eas and your stamp:
```
npx hardhat run --network localhost scripts/deploy_schemas_with_eas.ts
npx hardhat run --network localhost scripts/deploy_stamp.ts
```
But you should provide your own .env! You can use the .env.example for that.
