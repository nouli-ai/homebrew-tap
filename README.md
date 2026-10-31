# Nouli Homebrew tap

Homebrew package for [Nouli](https://github.com/nouli-ai/nouli). The repository is `nouli-ai/homebrew-tap`, addressed by Homebrew as `nouli-ai/tap`.

## Install

Nouli is a multi-turn decision harness. The formula installs the published executable for Apple silicon macOS, or ARM64 or x86_64 GNU/Linux. Linux requires system glibc 2.38 or newer; the release is tested on Ubuntu 24.04. Rust and provider credentials are not needed to install it.

```sh
brew install nouli-ai/tap/nouli
nouli --version
```

To update:

```sh
brew update
brew upgrade nouli-ai/tap/nouli
```

To uninstall:

```sh
brew uninstall nouli-ai/tap/nouli
```

Uninstalling preserves configuration and saved sessions in `~/.nouli` or a custom store. Follow the [Nouli user guide](https://nouli.ai/guide/) to configure a provider.

Installations from the earlier `standing-desks/tap` move to this tap on the next `brew update`. If you installed with Cargo, run `cargo uninstall nouli-cli` before switching to Homebrew. Remove any manually installed executable from your PATH too, so it does not shadow the Homebrew installation.

## Validate changes

Run the updater tests and lint tools from this checkout:

```sh
make test
actionlint
shellcheck scripts/*.sh
```

PR checks install Nouli only when the formula or tooling changes; README-only changes skip installations. Nouli is tested on macOS ARM64 and Ubuntu 24.04 ARM64 and x86_64. The required **Tap validation** check waits for all selected checks.

Run Homebrew installation checks in CI or a disposable Homebrew installation. Keep development validation separate from your installed tap. `make link-tap` registers this checkout locally and refuses to replace an existing registration pointing elsewhere. In a disposable installation:

```sh
make link-tap
brew trust --formula nouli-ai/tap/nouli
brew style Formula/nouli.rb
brew audit --formula nouli-ai/tap/nouli
brew install --formula nouli-ai/tap/nouli
brew test nouli-ai/tap/nouli
brew uninstall --formula nouli-ai/tap/nouli
```

## Release updates

Authenticate GitHub CLI, then run:

```sh
make update
make update RELEASE_TAG=v0.4.2
```

The updater selects a published stable release, verifies each platform archive against its `.sha256` sidecar, and updates the formula. It rejects incomplete releases and leaves the formula unchanged for the same or an older version.

The **Update Nouli formula** workflow receives `nouli-release-published` dispatches from Nouli's release workflow. A manual run can select a release tag or use the latest stable release. There is no timed schedule.

The updater runs on Linux, opens a formula PR, waits for **Tap validation**, and squash-merges that exact bot commit. Installation checks run in the PR, once per platform. Each automated PR may change only `Formula/nouli.rb`.

The tap needs the `TAP_APP_CLIENT_ID` repository variable and `TAP_APP_PRIVATE_KEY` Actions secret for the `nouli-tap-updater` GitHub App. The App requires Contents and Pull requests read/write access to this tap. Nouli uses the same App to dispatch release notifications, with Contents write access to the tap. Private keys belong in Actions secrets, never repository files.

Only the maintainers and update App can merge to `main`, through PRs with passing checks. Human approval is not required for the bot's verified release updates. `make protect-main APP_SLUG=nouli-tap-updater` configures those rules. Users receive packaged updates when they run `brew upgrade`.
