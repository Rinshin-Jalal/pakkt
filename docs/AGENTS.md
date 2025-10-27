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
- Use `@import` sparingly; prefer explicit imports
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
- Dark backgrounds (#000000)
- Glass morphism cards with backdrop blur
- Borders on important elements
- SF Pro fonts, ALL CAPS for headers

### Voice & Tone
- Direct, no-bullshit communication
- Aggressive but supportive ("Your boys won't let this slide 💀")
- No corporate speak or gentle encouragement

## Interaction Guidance
- Always ask clarifying questions if an instruction is ambiguous or open-ended.
- List potential alternative approaches before choosing one for implementation.
- If context or requirements are missing, ask for further details.
- After completing a task, ask "Is there anything that needs improvement or refinement?"

## Project Context
Pakkt is an iOS social accountability app where friend groups enforce real consequences (fines/phone jail) for missed goals. Target: college-aged males.