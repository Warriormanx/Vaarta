FROM node:18-alpine
WORKDIR /app

COPY package.json ./
COPY package-lock.json ./

RUN npm install --omit=optional --legacy-peer-deps

RUN npm install --save-dev \
  "@nomicfoundation/hardhat-network-helpers@^1.0.0" \
  "@nomicfoundation/hardhat-chai-matchers@^1.0.0" \
  "@nomiclabs/hardhat-ethers@^2.0.0" \
  "@nomiclabs/hardhat-etherscan@^3.0.0" \
  "@types/chai@^4.2.0" \
  "@types/mocha@>=9.1.0" \
  "@typechain/ethers-v5@^10.1.0" \
  "@typechain/hardhat@^6.1.2" \
  "chai@^4.2.0" \
  "hardhat-gas-reporter@^1.0.8" \
  "solidity-coverage@^0.8.1" \
  "ts-node@>=8.0.0" 

COPY . .

RUN npx hardhat clean && npx hardhat compile

RUN npm run build

# 3000 for next.js and 8545 for hardhat
EXPOSE 3000 8545

CMD ["sh", "-c", "npx hardhat node & sleep 10 && npx hardhat run scripts/deploy.js --network localhost && npm run start"]
