# Backup and Recovery

## Purpose

The Wolf Workstation is designed to be reproducible from a clean Ubuntu installation. Backup is therefore divided into reproducible configuration, credentials, and persistent user data.

A backup must not simply copy the entire home directory.

## Backup Categories

### 1. Version-controlled configuration

Stored in the `wolf-workstation` Git repository:

- Provisioning scripts
- APT package list
- User-tool versions
- `mise` configuration
- Shell configuration
- Development projects
- Documentation
- CI configuration

The repository is the source of truth for workstation configuration.

### 2. Credentials and secrets

Credentials are machine-specific and must not be stored in the repository.

Examples:
- SSH private keys
- GitHub authentication
- Cloud credentials
- GPG private keys
- API tokens
- Other secrets

These require a separate secure backup and recovery procedure.

Credential backup should use encrypted external storage or another appropriately secured backup mechanism.

# SSH Credentials

The workstation currently uses an Ed25519 SSH key for GitHub authentication.

The private key is machine-specific and must never be committed to the `wolf-workstation` repository.

Current SSH identity:

- Private key: `~/.ssh/id_ed25519`
- Public key: `~/.ssh/id_ed25519.pub`
- SSH configuration: no custom `~/.ssh/config`
- SSH agent: used to load the private key
- GitHub authentication: verified successfully

---

## Secure Backup

The SSH private key must be backed up separately using a secure storage mechanism.

The backup must contain:

- `~/.ssh/id_ed25519`

The public key does not need to be backed up independently because it can be regenerated from the private key:

```bash
ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub
```

### Unsafe Storage Locations

The private key backup must **not** be stored in:

- The `wolf-workstation` repository
- Git history
- Public cloud storage without appropriate protection
- Unencrypted removable media

---

## Recovery

After a clean Ubuntu installation, follow these steps to restore the key:

1. **Restore the private key to:**
   `~/.ssh/id_ed25519`

2. **Set the correct permissions:**
   ```bash
   chmod 700 ~/.ssh
   chmod 600 ~/.ssh/id_ed25519
   ```

3. **Regenerate the public key if necessary:**
   ```bash
   ssh-keygen -y -f ~/.ssh/id_ed25519 > ~/.ssh/id_ed25519.pub
   chmod 644 ~/.ssh/id_ed25519.pub
   ```

4. **Start the SSH agent and load the key:**
   ```bash
   eval "$(ssh-agent -s)"
   ssh-add ~/.ssh/id_ed25519
   ```

5. **Verify the key:**
   ```bash
   ssh-add -l
   ```

6. **Test GitHub authentication:**
   ```bash
   ssh -T git@github.com
   ```
   *A successful authentication should report that the GitHub account was successfully authenticated and that GitHub does not provide shell access.*

---

## Alternative: Generate a New SSH Key

If the original private key cannot be recovered, generate a new Ed25519 key:

```bash
ssh-keygen -t ed25519 -C "mgwolf2002@gmail.com"
```

Then add the new public key to the GitHub account before attempting SSH-based Git operations.

> **Note:** Generating a new key is preferable to attempting to recover an unavailable private key from insecure or unknown locations.

### 3. Persistent user data

Personal data requires an independent backup strategy.

Examples:
- Documents
- Pictures
- Music
- Videos
- Other personal files

The workstation repository does not replace a personal data backup.

### 4. Regenerable state

The following should normally not be backed up:

- Package manager caches
- Build directories
- `node_modules`
- Python virtual environments
- `mise`-installed runtimes
- `pnpm` stores
- `uv` caches
- Docker development volumes
- Temporary files

This state should be recreated from the workstation configuration.

## Credential Recovery

Credentials are intentionally excluded from the Git repository.

### SSH

The workstation uses an Ed25519 SSH key for Git operations.

The private key may be stored in an encrypted external backup.

If the private key is unavailable, generate a new key:

```bash
ssh-keygen -t ed25519 -C "mgwolf2002@gmail.com"
```

The resulting public key must be registered with GitHub before SSH-based Git operations can be used.

Test the connection with:

```bash
ssh -T git@github.com
```

### GitHub CLI

GitHub CLI authentication is machine-specific and must not be stored in the `wolf-workstation` repository.

The current configuration uses:

- GitHub account: `marcos-wolf`
- Git operations protocol: SSH
- Authentication storage: system keyring
- GitHub CLI configuration: `~/.config/gh/`
- Authentication token: stored in the system keyring

The authentication token must never be copied into the repository or included in a workstation backup.

The following files contain GitHub CLI configuration but not the authentication token:

```text
~/.config/gh/config.yml
~/.config/gh/hosts.yml
```

These files are considered regenerable configuration and do not require credential backup.

### AWS CLI

AWS CLI is currently installed, but no AWS credentials are configured on this workstation.

The `~/.aws/` directory does not currently exist, and
`aws sts get-caller-identity` reports `NoCredentials`.

Therefore, there are currently no AWS credentials to include in the secure
credential backup.

If AWS credentials are configured in the future, they must not be committed to
the repository. The authentication and recovery procedure must be documented
here according to the credential mechanism being used, such as IAM Identity
Center (SSO), environment-based credentials, or another supported mechanism.

#### Recovery

After reinstalling Ubuntu and installing GitHub CLI, authenticate the GitHub account again:

```bash
gh auth login
```

Select:

1. GitHub.com
2. SSH for Git operations
3. Authenticate through the browser when prompted

Then verify the authentication:

```bash
gh auth status
```

The expected state is:

- the `marcos-wolf` account is authenticated
- the account is active
- Git operations use SSH

Finally, verify SSH independently:

```bash
ssh -T git@github.com
```

The GitHub CLI token is intentionally regenerated through the authentication process rather than restored from backup.

### GPG

No GPG secret keys are currently configured on this workstation.

If GPG is introduced later, the private key must be included in the encrypted credential backup and its restoration procedure must be documented here.

### Git Identity

Git identity is configuration rather than a secret.

Current identity:
- **Name:** Marcos Wolf
- **Email:** MGWOLF2002@GMAIL.COM

It can be restored with:

```bash
git config --global user.name "Marcos Wolf"
git config --global user.email "mgwolf2002@gmail.com"
```

### Docker Data

Docker volumes used exclusively for development are considered regenerable.

The current PostgreSQL test environment uses a named Docker volume:
`wolf-infra-test_postgres_data`

The volume is not part of the workstation backup.

If a future project contains important persistent data, it must define an explicit database/file backup procedure.

## Recovery Principle

A successful recovery should follow this order:

1. Install Ubuntu.
2. Update the system.
3. Clone `wolf-workstation`.
4. Run the core provisioning scripts.
5. Restore required credentials through the secure credential procedure.
6. Restore persistent user data.
7. Recreate project dependencies.
8. Recreate Docker development environments.
9. Run the system and project validation checks.

## Recovery Test

A backup strategy is considered valid only when the documented recovery procedure has been successfully tested on a clean system.

The recovery test should verify that:
- The workstation can be provisioned from the repository;
- Required development tools are installed at the declared versions;
- Shell configuration is restored correctly;
- Git and GitHub authentication can be restored;
- Development projects can be rebuilt;
- Docker services can be recreated;
- Persistent user data can be restored;
- System and project validation checks pass.

## Current Status

- The workstation configuration is version-controlled and reproducible.
- Credential backup and personal-data backup are not yet automated.
- Docker development data is considered regenerable.
- A complete clean-system recovery test has not yet been performed.
