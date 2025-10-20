# Git Hooks Setup - Pakkt Project

## Overview

Pre-commit hooks have been configured to automatically validate code quality before allowing commits. This ensures consistent code standards across the entire codebase.

## Pre-Commit Hook Location

**File**: `.git/hooks/pre-commit`
**Status**: Installed and executable

## What Gets Checked

### 1. Swift Code (iOS App)

**SwiftLint Integration**:
- Automatically runs SwiftLint on all staged `.swift` files
- Requires SwiftLint to be installed: `brew install swiftlint`
- Blocks commits if SwiftLint errors are found
- Configurable via `.swiftlint.yml` file (to be created)

**Common Issues Detection**:
- ⚠️ **Print Statements**: Warns about `print()` usage (use proper logging instead)
- ⚠️ **Force Unwrapping**: Warns about force unwrap operator `!.` (use safe unwrapping)

### 2. TypeScript/JavaScript Code (Backend)

**ESLint Integration**:
- Runs ESLint on all staged `.ts`, `.tsx`, `.js`, `.jsx` files
- Requires ESLint to be installed in `workers/` directory
- Blocks commits if ESLint errors are found
- Zero warnings policy: `--max-warnings 0`

**Common Issues Detection**:
- ⚠️ **Console.log Statements**: Warns about `console.log()` usage (use proper logging)

### 3. General Security & Quality Checks

**Merge Conflict Detection**:
- ❌ **Blocks commits** containing merge conflict markers
- Checks for: `<<<<<<<`, `=======`, `>>>>>>>`

**Secret Scanning**:
- ❌ **Blocks commits** containing potential secrets
- Patterns detected:
  - `password = "value"`
  - `api_key = "value"` or `apiKey = "value"`
  - `secret = "value"`
  - `token = "value"`
  - `sk_live_` (Stripe secret keys)
  - `pk_live_` (Stripe public keys)
  - `AKIA[0-9A-Z]{16}` (AWS access keys)

**File Size Warnings**:
- ⚠️ **Warns about large files** (>1MB)
- Prevents accidentally committing large binaries or assets
- Use Git LFS for large files if needed

**TODO/FIXME Comments**:
- ⚠️ **Warns about TODO/FIXME comments** in staged files
- Reminds developers to track tasks properly in GitHub Issues

## Hook Behavior

### Exit Codes
- **Exit 0**: All checks passed → Commit proceeds
- **Exit 1**: Critical checks failed → Commit blocked

### Color-Coded Output
- 🟢 **Green**: Checks passed successfully
- 🔴 **Red**: Critical failures (commit blocked)
- 🟡 **Yellow**: Warnings (commit proceeds with notice)

### Bypassing Hooks (Not Recommended)

If absolutely necessary, you can bypass the pre-commit hook:

```bash
git commit --no-verify -m "commit message"
```

**⚠️ Warning**: Only use `--no-verify` in exceptional circumstances. Bypassing hooks can introduce code quality issues and security vulnerabilities.

## Installation for New Developers

The pre-commit hook is already installed in this repository. New developers need to:

### 1. Install SwiftLint (for iOS development)
```bash
brew install swiftlint
```

### 2. Install ESLint (for backend development)
```bash
cd workers
npm install
# ESLint will be installed as a dev dependency
```

### 3. Verify Hook is Executable
```bash
ls -la .git/hooks/pre-commit
# Should show: -rwxr-xr-x (executable permissions)
```

If not executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Configuration Files

### SwiftLint Configuration (To Be Created)

Create `.swiftlint.yml` in project root:

```yaml
# Example SwiftLint configuration
disabled_rules:
  - trailing_whitespace
opt_in_rules:
  - empty_count
  - closure_spacing
included:
  - Pakkt
excluded:
  - Pods
  - build
line_length:
  warning: 120
  error: 200
```

### ESLint Configuration (To Be Created)

ESLint configuration should be in `workers/` directory as part of backend setup.

## Testing the Hook

### Test with Swift File
1. Create a Swift file with intentional issues (print statements, force unwrapping)
2. Stage the file: `git add file.swift`
3. Attempt commit: `git commit -m "test"`
4. Verify hook detects issues

### Test with TypeScript File
1. Create a TypeScript file with `console.log()` statements
2. Stage the file: `git add file.ts`
3. Attempt commit: `git commit -m "test"`
4. Verify hook detects issues

### Test Secret Detection
1. Create a file with fake API key: `api_key = "sk_test_123456"`
2. Stage and attempt commit
3. Verify hook blocks commit

## Troubleshooting

### "SwiftLint not installed"
**Solution**: Install SwiftLint with Homebrew
```bash
brew install swiftlint
```

### "ESLint not installed"
**Solution**: Install dependencies in workers directory
```bash
cd workers
npm install
```

### Hook Not Running
**Solution**: Verify hook is executable
```bash
chmod +x .git/hooks/pre-commit
```

### Hook Runs But Doesn't Detect Issues
**Solution**: Check that linters are properly configured and installed

## Integration with CI/CD

This pre-commit hook is the first line of defense. GitHub Actions workflows (to be set up) will provide additional validation:

1. **Pre-commit Hook**: Local developer validation
2. **GitHub Actions**: CI validation on pull requests
3. **Required Status Checks**: Enforce passing CI before merge

## Related Documentation

- Issue #5: Establish CI/CD Pipeline (Phase 0)
- `/todos/01_TECHNICAL_ARCHITECTURE.md`: Technical architecture details
- `/todos/06_TESTING_QA.md`: Testing and QA requirements

## Maintenance

### Adding New Checks
Edit `.git/hooks/pre-commit` to add new validation rules. Consider:
- Performance impact (hook should complete quickly)
- False positive rate
- Developer experience

### Updating Linter Rules
- **SwiftLint**: Edit `.swiftlint.yml`
- **ESLint**: Edit `workers/.eslintrc.js` or `workers/eslint.config.js`

## Status

✅ **Completed**: Pre-commit hook installed, tested, and documented
⏳ **Next Steps**:
- Create `.swiftlint.yml` configuration
- Set up ESLint in `workers/` directory
- Configure GitHub Actions workflows
- Add commit-msg hook for conventional commits (optional)

---

**Created**: October 20, 2025
**Last Updated**: October 20, 2025
**Related Issue**: #5 - Establish CI/CD Pipeline
