# Node.js Development Environment

## Runtime

- Node.js: managed with mise
- Package manager: pnpm
- TypeScript
- Vitest
- Biome

## Version management

Node.js is managed with mise rather than the Ubuntu system packages.

This keeps project runtimes independent from the operating system and allows different projects to use different Node.js versions.

Current workstation version:

- Node.js 24.x
- pnpm 11.x

## Project structure

Node.js validation projects are stored under:

~/Projects/wolf-workstation/projects/node/

Example:

~/Projects/wolf-workstation/projects/node/wolf-node-test/

## Package management

pnpm is the preferred package manager for Node.js projects.

Example:

bash
pnpm install


Install a development dependency:

bash
pnpm add -D <package>


Run a project script:

bash
pnpm run <script>


## TypeScript

TypeScript projects should use a project-local installation.

Example:

bash
pnpm add -D typescript


Compile:

bash
pnpm run build


## Code quality

Biome is currently used for formatting and linting.

Format:

bash
pnpm run format


Check:

bash
pnpm run check


## Testing

Vitest is used for automated tests.

Run tests:

bash
pnpm run test


## Example project scripts

A typical TypeScript/Node.js project should expose scripts similar to:

json
{
  "scripts": {
    "build": "tsc",
    "start": "node dist/index.js",
    "check": "biome check src",
    "format": "biome format --write src",
    "test": "vitest run"
  }
}


## Reproducibility

Projects must commit:

- package.json
- pnpm-lock.yaml
- tsconfig.json
- biome.json
- source code
- tests

Projects should not commit:

- node_modules/
- dist/
- .env
- log files

The lockfile is important because it records the exact dependency resolution used by the project.

## Validation

The workstation was validated with a TypeScript project containing:

- Node.js runtime
- TypeScript compiler
- pnpm
- Biome
- Vitest

The complete development cycle was successfully tested:

text
source
  ↓
Biome format
  ↓
Biome check
  ↓
TypeScript build
  ↓
Vitest
  ↓
Node.js execution
