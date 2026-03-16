# Release Process

This document describes how to prepare and publish a new release of the Matrix package.

## Pre-release Checklist

1. **Ensure CI is passing** — All tests must pass on both macOS and Linux.
2. **Run tests locally:**
   ```bash
   swift test
   swift build -c release
   ```
3. **Review changes** — Read through all commits since the last release to ensure nothing was missed.
4. **Check for breaking changes** — If any public API has changed in a non-backward-compatible way, this requires a major version bump.

## Version Numbering

This project follows [Semantic Versioning](https://semver.org):

| Change Type | Version Bump | Example |
|---|---|---|
| Bug fixes, internal refactors | Patch | 1.0.0 → 1.0.1 |
| New APIs, backward-compatible changes | Minor | 1.0.0 → 1.1.0 |
| Breaking API changes | Major | 1.0.0 → 2.0.0 |

Swift Package Manager resolves versions from git tags, so there is no version number in the source code itself.

## Release Steps

### 1. Update the changelog

Move items from the `[Unreleased]` section of `CHANGELOG.md` into a new version section with today's date:

```markdown
## [Unreleased]

## [1.1.0] - 2026-04-01

### Added
- New feature description
```

Update the comparison links at the bottom of the file:

```markdown
[Unreleased]: https://github.com/lukescholefield/Matrix/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/lukescholefield/Matrix/releases/tag/v1.1.0
```

### 2. Update the README if needed

Ensure any new APIs, changed requirements, or updated examples are reflected in `README.md`.

### 3. Commit the release preparation

```bash
git add CHANGELOG.md README.md
git commit -m "Prepare release 1.1.0"
```

### 4. Tag the release

```bash
git tag 1.1.0
```

### 5. Push to GitHub

```bash
git push origin main
git push origin 1.1.0
```

### 6. Create a GitHub Release

```bash
gh release create 1.1.0 --title "1.1.0" --notes "See [CHANGELOG.md](CHANGELOG.md) for details."
```

Alternatively, create the release through the GitHub web UI at **Releases → Draft a new release**, selecting the tag you just pushed.

### 7. Verify the release

Confirm the package resolves correctly by adding it to a fresh Swift project:

```swift
.package(url: "https://github.com/lukescholefield/Matrix.git", from: "1.1.0")
```

## Post-release

After publishing, ensure the `[Unreleased]` section in `CHANGELOG.md` is ready for the next development cycle. Commit this as a follow-up:

```bash
git commit -m "Begin next development cycle"
```
