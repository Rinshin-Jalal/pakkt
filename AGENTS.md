# AGENTS.md - Pakkt Development Guidelines

## Build/Lint/Test Commands
- **Build**: `xcodebuild -scheme Pakkt -sdk iphonesimulator -configuration Debug build`
- **Test**: `xcodebuild -scheme Pakkt -sdk iphonesimulator -configuration Debug test`
- **Single test**: `xcodebuild -scheme Pakkt -sdk iphonesimulator -configuration Debug -only-testing:PakktTests/TestClass/testMethod test`
- **Lint**: `swiftlint` (install via `brew install swiftlint`)
- **Format**: `swiftformat .` (install via `brew install swiftformat`)

## Code Style Guidelines

### Imports & Structure
- Group imports: Foundation, UIKit, then third-party, then local modules
- One import per line, alphabetical within groups

### Naming Conventions
- **Classes/Structs**: PascalCase (PakktViewController, UserProfile)
- **Variables/Constants**: camelCase (userName, isLoggedIn)
- **Functions**: camelCase, descriptive (createNewPack(), validateCheckInTime())
- **Enums**: PascalCase, cases camelCase (PackVisibility.public, .private)

### Types & Safety
- Use structs over classes when possible
- Prefer `let` over `var`
- Explicit types for clarity: `let count: Int = 0`
- Force unwrap only when guaranteed safe

### Error Handling
- Use Result types for async operations
- Custom errors with descriptive messages
- Avoid try! in production code

### UI & Design System
- Dark Neobrutalism: black backgrounds (#000000), neon accents (#00F0FF, #FF006E)
- Glass morphism cards with 40-60px backdrop blur
- Thick borders (3-4px) on important elements
- SF Pro fonts, ALL CAPS for headers