# dev-tools

A shared developer tooling environment for initializing and managing .NET and other projects.

## Features

- **Project Initialization**: Quickly scaffold .NET (webapi, xunit) or Vue3 projects with standardized structure and templates.
- **Central Package Management**: Migrate .NET projects to use Directory.Packages.props for package version centralization.
- **Devbox Integration**: Uses [Devbox](https://www.jetpack.io/devbox/) for reproducible development environments.
- **Customizable Templates**: Easily extend or modify project templates in the `templates/` directory.

## Getting Started

### Prerequisites

- [Git](https://git-scm.com/)
- [Devbox](https://www.jetpack.io/devbox/) (auto-installed if missing)
- [Nushell](https://www.nushell.sh/) (for running the CLI)

### Installation

Run the install script to set up the tools and environment:

```sh
./install.sh
```

This will:
- Clone or update the dev-tools repository to `~/.dev-tools`
- Ensure Devbox is installed
- Add the tools to your `PATH`

### Usage

#### Initialize a new .NET project

```sh
dev init --type dotnet --name MyProject
```

- Prompts for a solution name if `--name` is omitted.
- Sets up solution, src, test, and supporting files using templates.

#### Centralize Package Versions

From within a .NET solution directory:

```sh
dev to-cpm
```

- Scans all `.csproj` files, extracts package versions, and generates a `Directory.Packages.props` file.

### Directory Structure

- `dev` - Nushell CLI script for project management.
- `install.sh` - Bootstrapper for installing/updating dev-tools and dependencies.
- `templates/` - Project and file templates for new solutions.
- `.devbox/` - Devbox environment configuration.

## Customization

You can modify or add templates in the `templates/` directory to fit your team's standards.

## License

MIT (see [LICENSE](https://github.com/pmdevers/dev-tools/blob/main/LICENSE))
