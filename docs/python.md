# Python Development Environment

Python projects in the Wolf Workstation use `uv` for Python version management, virtual environments, dependency management, locking, and project execution.

---

## Runtime

Python project runtimes are managed with `uv`.

The validation project currently targets:
- **Python 3.13**
- **`uv`**
- **PEP 621 `pyproject.toml`**
- **`uv.lock`**

Python versions are selected per project rather than relying on the system Python installation.

---

## Project Structure

Python projects should follow a conventional `src` layout:

```text
project/
├── pyproject.toml
├── uv.lock
├── .python-version
├── README.md
├── src/
│   └── package_name/
└── tests/
```

Virtual environments are created locally by `uv` and must **not** be committed:
`.venv/`

---

## Creating a Project

Create a package project with:

```bash
uv init --python 3.13 --package projects/python/project-name
```

Enter the project:

```bash
cd projects/python/project-name
```

Create or update the environment:

```bash
uv sync
```

---

## Python Version

The project declares its supported Python version in `pyproject.toml`:

```toml
requires-python = ">=3.13,<3.14"
```

The `.python-version` file selects the local interpreter:

```text
3.13
```

This keeps the project runtime independent from the system Python version. Verify it with:

```bash
uv run python --version
```

---

## Dependencies

Runtime dependencies should be declared in `pyproject.toml`.

Add a dependency with:

```bash
uv add package-name
```

Development dependencies should use dependency groups:

```bash
uv add --dev pytest
uv add --dev ruff
```

The `uv.lock` file records the resolved dependency graph and must be committed.

For reproducible installation, use:

```bash
uv sync --locked
```

---

## Running the Project

Commands should normally be executed through `uv`:

```bash
uv run python
```

For an exposed project command:

```bash
uv run project-command
```

This ensures the project's selected Python interpreter and dependencies are used.

---

## Testing

The standard test runner is `pytest`.

Run the complete test suite:

```bash
uv run pytest
```

The validation project contains its tests under: `tests/`

---

## Linting and Formatting

Ruff is the standard Python linter and formatter.

Run linting:

```bash
uv run ruff check .
```

Check formatting:

```bash
uv run ruff format --check .
```

Apply formatting:

```bash
uv run ruff format .
```

The validation project uses rules:
- `E`
- `F`
- `I`
- `UP`
- `B`

Ruff targets **Python 3.13**.

---

## Reproducibility

A Python project **should commit**:
- `pyproject.toml`
- `uv.lock`
- `.python-version`
- Source code
- Tests
- Project documentation

A Python project **should NOT commit**:
- `.venv/`
- `__pycache__/`
- `.pytest_cache/`
- `.ruff_cache/`
- Build artifacts
- Generated distributions

> Dependencies and virtual environments should be recreated from the project configuration rather than backed up.

---

## CI

Python projects are validated in GitHub Actions.

The workstation's Python validation pipeline currently performs:

```bash
uv sync --locked
uv run ruff check .
uv run pytest
```

The CI environment installs Python 3.13 using `astral-sh/setup-uv`.

---

## Validation Project

The workstation repository contains a Python validation project at:
`projects/python/wolf-python-test/`

It validates:
- Python 3.13
- `uv` project initialization
- Isolated virtual environments
- Dependency locking
- `pytest`
- `Ruff`
- Python package execution
- Reproducible dependency installation

Run the complete local validation with:

```bash
cd projects/python/wolf-python-test

uv sync --locked
uv run ruff check .
uv run ruff format --check .
uv run pytest
```
