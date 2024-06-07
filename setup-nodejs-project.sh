#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Initialize a new Node.js project
echo "Initializing new Node.js project..."
npm init -y

# Install TypeScript and its dependencies
echo "Installing TypeScript..."
npm install --save-dev typescript @types/node ts-node

# Create tsconfig.json file
echo "Creating tsconfig.json..."
cat <<EOL > tsconfig.json
{
  "compilerOptions": {
    "target": "ES6",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules", "**/*.test.ts"]
}
EOL

# Install ESLint and Prettier
echo "Installing ESLint and Prettier..."
npm install --save-dev eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin prettier eslint-config-prettier eslint-plugin-prettier

# Create ESLint configuration file
echo "Creating .eslintrc.js..."
cat <<EOL > .eslintrc.js
module.exports = {
  parser: '@typescript-eslint/parser',
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended'
  ],
  parserOptions: {
    ecmaVersion: 2020,
    sourceType: 'module'
  },
  rules: {
    'prettier/prettier': 'error'
  }
};
EOL

# Create Prettier configuration file
echo "Creating .prettierrc..."
cat <<EOL > .prettierrc
{
  "singleQuote": true,
  "trailingComma": "all"
}
EOL

# Install Jest and its dependencies
echo "Installing Jest..."
npm install --save-dev jest @types/jest ts-jest

# Create Jest configuration file
echo "Creating jest.config.js..."
cat <<EOL > jest.config.js
module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  testMatch: ['**/?(*.)+(spec|test).[tj]s?(x)']
};
EOL

# Create a basic test file
mkdir -p src/__tests__
cat <<EOL > src/__tests__/sample.test.ts
import { sum } from '../sum';

test('adds 1 + 2 to equal 3', () => {
  expect(sum(1, 2)).toBe(3);
});
EOL

# Create a basic implementation file
mkdir -p src
cat <<EOL > src/sum.ts
export const sum = (a: number, b: number): number => {
  return a + b;
};
EOL

# Install Winston for logging
echo "Installing Winston..."
npm install winston

# Create a basic logger file
cat <<EOL > src/logger.ts
import { createLogger, format, transports } from 'winston';

const logger = createLogger({
  level: 'info',
  format: format.combine(
    format.colorize(),
    format.timestamp(),
    format.printf(({ timestamp, level, message }) => {
      return \`\${timestamp} [\${level}]: \${message}\`;
    })
  ),
  transports: [
    new transports.Console(),
    new transports.File({ filename: 'error.log', level: 'error' }),
    new transports.File({ filename: 'combined.log' })
  ]
});

export default logger;
EOL

# Add useful npm scripts to package.json
echo "Adding npm scripts..."
npx json -I -f package.json -e '
  this.scripts = {
    "build": "tsc",
    "start": "node dist/sum.js",
    "dev": "ts-node src/sum.ts",
    "lint": "eslint . --ext .ts",
    "format": "prettier --write .",
    "test": "jest"
  }
'

echo "Setup complete!"
