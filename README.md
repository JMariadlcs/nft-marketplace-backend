# NFT MARKETPLACE BACKEND 🦄

This is a backend implementation of a NFT Marketplace from Patrick Alpha's fcc.

The workshop followed to complete this repo is [this one](https://github.com/PatrickAlphaC/hardhat-nft-marketplace-fcc).

The repo that we are going to implement is like [this one](https://www.youtube.com/watch?v=gyMwXuJrbJQ&t=15996s).

## PROJECT

1. Create a Decentralized MarketPlace ✅
    1. `listItem`: List NFTs on the Marketplace.
    2. `buyItem`: Buy NFTs directly on the Marketplace.
    3. `cancelItem`: Cancel item listing.
    4. `updateListing`: Update listing price.
    5. `withdrawProceeds`: Withdraw funds from sold NFTs.

## CREATE SIMILAR PROJECT FROM SCRATCH

-   Install yarn and start hardhat project:

```bash
yarn
yarn add --dev hardhat
yarn hardhat
```

-   Install ALL the dependencies:

```bash
yarn add --dev @nomiclabs/hardhat-waffle@^2.0.0 ethereum-waffle@^3.0.0 chai@^4.2.0 @nomiclabs/hardhat-ethers@^2.0.0 ethers@^5.0.0 @nomiclabs/hardhat-etherscan@^3.0.0 dotenv@^16.0.0 eslint@^7.29.0 eslint-config-prettier@^8.3.0 eslint-config-standard@^16.0.3 eslint-plugin-import@^2.23.4 eslint-plugin-node@^11.1.0 eslint-plugin-prettier@^3.4.0 eslint-plugin-promise@^5.1.0 hardhat-gas-reporter@^1.0.4 prettier@^2.3.2 prettier-plugin-solidity@^1.0.0-beta.13 solhint@^3.3.6 solidity-coverage@^0.7.16 @nomiclabs/hardhat-ethers@npm:hardhat-deploy-ethers ethers @chainlink/contracts hardhat-deploy hardhat-shorthand @aave/protocol-v2
```

-   Install OpenZeppelin dependencies (contracts):

```bash
yarn add --dev @openzeppelin/contracts
```

## HOW TO COMPILE

```bash
yarn hardhat compile
```

or

```bash
npx hardhat compile
```

## HOW TOT DEPLOY

If you want to use [Hardhat shorthand](https://hardhat.org/guides/shorthand):

```bash
yarn global add hardhat-shorthand
```

-   Deploy to local network (Harhat by default):

```bash
hh compile
hh deploy
```

-   Deploy to a TESTNET (Rinkeby):
    You can not deploy all scripts at the same time because you can deploy [mint.js](https://github.com/JMariadlcs/nfts-fullrepo/blob/main/deploy/04-mint.js) script without firtly add randomNFT to ConsumerBase.

To deploy every script expect [mint.js](https://github.com/JMariadlcs/nfts-fullrepo/blob/main/deploy/04-mint.js):

```bash
yarn hardhat deploy --network rinkeby --tags main
```

## HOW TO TEST

Two types of tests are created for this project:

1. "Unit tests" inside [unit](https://github.com/JMariadlcs/nfts-fullrepo/tree/main/test/unit): used to test functions separately

To execute tests **unit tests** (on development chain):

```bash
yarn hardhat test
```

and to see test coverage:

```bash
yarn hardhat coverage
```

## REMINDERS

**NOTICE**: most of the below mentioned dependencies are already installed, just check it and include the corresponding `requires` inside [hardhat.config.js](https://github.com/JMariadlcs/nfts-fullrepo/blob/main/hardhat.config.js).

-   If you want to execute solhint to search for potential Solidity errors
    Execute:

```bash
yarn solhint contracts/*.sol
```

-   If you want to use a text formarter:
    Check [.prettierrc](https://github.com/JMariadlcs/nfts-fullrepo/blob/main/.prettierrc) and [.prettierignore](https://github.com/JMariadlcs/nfts-fullrepo/blob/main/.prettierignore).

-   To automatically verify our contract on etherscan:

```bash
yarn add --dev @nomiclabs/hardhat-etherscan
```

Then, include inside [hardhat.config.js](https://github.com/JMariadlcs/nfts-fullrepo/blob/main/hardhat.config.js):

```bash
require("@nomiclabs/hardhat-etherscan");
```

Add `ETHERSCAN_API_KEY` inside `.env` file.

-   Use Hardhat Gas Reporter:

```bash
yarn add --dev hardhat-gas-reporter
```

Then, include inside [hardhat.config.js](https://github.com/JMariadlcs/nfts-fullrepo/blob/main/hardhat.config.js):

```bash
require("hardhat-gas-reporter");
```

-   Use Solidity Coverage:

```bash
yarn add --dev solidity-coverage
```

Then, include inside [hardhat.config.js](https://github.com/JMariadlcs/nfts-fullrepo/blob/main/hardhat.config.js):

```bash
require("solidity-coverage");
```

In order to execute it:

```bash
yarn hardhat coverage
```

-   Use Hardhat Waffle:

```bash
yarn add @nomiclabs/hardhat-waffle
```

Then, include inside [hardhat.config.js](https://github.com/JMariadlcs/nfts-fullrepo/blob/main/hardhat.config.js):

```bash
require("@nomiclabs/hardhat-waffle");
```

## RESOURCES

-   [Artion-Contracts](https://github.com/Fantom-foundation/Artion-Contracts): Open Source Marketplace backend implementation.
-   [Patrick's repo](https://github.com/PatrickAlphaC/hardhat-nft-marketplace-fcc): Repo from Patricks ffc
-   [Patrick's fcc video](https://www.youtube.com/watch?v=gyMwXuJrbJQ&t=15996s)
