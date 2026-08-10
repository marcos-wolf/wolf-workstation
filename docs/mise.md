# mise

`mise` is used to manage development tool versions independently from the Ubuntu system packages.

## Current Tools

| Tool | Version |
| :--- | :--- |
| Node.js | 24.x |
| pnpm | 11.20.0 |

## Configuration

The workstation configuration is stored in:

`mise/config.toml`

The local `mise` configuration is:

```toml
[tools]
node = "24"
pnpm = "11.20.0"
```

## Verification

Check installed tools:

```bash
mise ls
```

Check active versions:

```bash
mise current
```

Check the runtime:

```bash
node --version
```

Check pnpm:

```bash
pnpm --version
```

## Policy

* Development runtimes should preferably be managed through `mise` rather than Ubuntu's system packages.
* System packages should be used when the software is part of the operating system or when distribution integration is important.
* Project dependencies remain managed by the project's package manager.
