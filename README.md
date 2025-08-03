# 🚀 Git-Go

<div align="center">

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)
[![Made with Bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/)

**Intelligent Git Repository Manager**

Create and manage git repositories with smart sync scripts, VS Code integration, and AI-assisted development support.

[Features](#features) • [Installation](#installation) • [Usage](#usage) • [Configuration](#configuration) • [Contributing](#contributing)

</div>

## ✨ Features

- 🎯 **Smart Repository Creation** - Initialize new repos with sensible defaults
- 🔄 **Intelligent Sync Scripts** - Generated scripts handle upstream syncing, stashing, and multi-remote push
- 📝 **AI-Ready** - Automatically creates CLAUDE.md files for AI-assisted development
- 🎨 **VS Code Integration** - Built-in tasks for one-key synchronization (Ctrl+Shift+B)
- ⚙️ **Highly Configurable** - Customize git hosts, templates, and behaviors
- 🎭 **Fork-Aware** - Special handling for forked repositories with upstream tracking
- 🌈 **Beautiful CLI** - Colorful, informative output with progress indicators

## 📦 Installation

### Quick Install

The easiest way to install Git-Go is using our install script:

```bash
curl -sSL https://raw.githubusercontent.com/PowerAppsDarren/git-go/main/install.sh | bash
```

This will:
- Download Git-Go to `~/.local/share/git-go`
- Create the `git-go` command in `~/.local/bin`
- Set up your initial configuration

### Manual Install

If you prefer to review the install script first:

```bash
# Download and review the script
curl -sSL https://raw.githubusercontent.com/PowerAppsDarren/git-go/main/install.sh -o install.sh
less install.sh

# Run it when ready
bash install.sh
```

Or clone and install from source:

```bash
git clone https://github.com/PowerAppsDarren/git-go.git
cd git-go
./install.sh
```

### Requirements

- Git 2.0+
- Bash 4.0+
- Optional: VS Code for IDE integration

### Post-Installation

If `git-go` is not found after installation, add `~/.local/bin` to your PATH:

```bash
# For bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# For zsh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## 🚀 Usage

### Create a New Repository

```bash
git-go new --name my-awesome-project
```

Or interactively:
```bash
git-go new
```

### Fork an Existing Repository

```bash
git-go fork --url https://github.com/torvalds/linux
```

### Sync Your Repository

After creating or forking:
```bash
cd my-project
./scripts/sync.sh
```

Or in VS Code: Press `Ctrl+Shift+B`

## ⚙️ Configuration

Git-Go can be configured via `~/.config/git-go/config`. Run:

```bash
git-go config
```

### First-Time Setup

On first run, Git-Go will automatically launch a setup wizard:

```bash
git-go new --name my-project
# No configuration found. Running setup wizard...
```

Or run setup manually:

```bash
git-go setup
```

The wizard will guide you through:
- Choosing your git hosting service (GitHub, GitLab, Bitbucket, etc.)
- Setting up your username
- Configuring optional secondary remotes
- Enabling features like VS Code integration and AI assistance

## 📁 Generated Repository Structure

```
my-project/
├── README.md            # Project readme with template
├── LICENSE              # MIT license
├── .gitignore           # Smart gitignore based on project type
├── CLAUDE.md            # AI assistant instructions
├── scripts/
│   └── sync.sh          # Intelligent sync script
└── .vscode/
    └── tasks.json       # VS Code integration
```

## 🎯 Command Reference

| Command | Description | Example |
|---------|-------------|---------|
| `new` | Create a new repository | `git-go new --name my-project` |
| `fork` | Fork an existing repository | `git-go fork --url https://github.com/user/repo` |
| `config` | Edit configuration | `git-go config` |
| `setup` | Run setup wizard | `git-go setup` |
| `version` | Show version | `git-go version` |
| `help` | Show help | `git-go help` |

## 🤝 Contributing

We love contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Development

```bash
# Clone the repo
git clone https://github.com/yourusername/git-go.git
cd git-go

# Open in your favorite editor
cursor .  # or: code .

# The main script to edit is:
# bin/git-go

# Deploy locally and run tests
./deploy.sh

# Test your changes
git-go new --name test-project

# When ready to release a new version
./release.sh
```

#### Development Workflow

1. **Edit the code** - The main script is `bin/git-go`. Open it in Cursor or VS Code:
   ```bash
   cursor bin/git-go  # or: code bin/git-go
   ```

2. **Deploy locally** - This installs git-go to ~/bin and runs tests:
   ```bash
   ./deploy.sh
   ```

3. **Test manually** - Try out your changes:
   ```bash
   git-go new --name test-repo
   ```

4. **Release** - When ready to publish a new version:
   ```bash
   ./release.sh
   ```

#### Key Files

- `bin/git-go` - Main executable script (this is what you edit!)
- `lib/colors.sh` - Color output functions
- `lib/git-utils.sh` - Git utility functions
- `tests/` - Test suite
- `deploy.sh` - Local deployment script (runs tests automatically)
- `release.sh` - Version release script

## 📝 License

MIT © [Your Name](https://github.com/yourusername)

---

<div align="center">

**If you find Git-Go useful, please ⭐ this repository!**

</div>