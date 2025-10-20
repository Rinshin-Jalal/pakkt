# Pakkt iOS Architecture

## 📐 Architecture Overview

**Pattern:** MVVM (Model-View-ViewModel) + Coordinator
**Language:** Swift 5.9+
**Minimum iOS:** 17.0
**UI Framework:** SwiftUI

---

## 🗂️ Project Structure

```
Pakkt/
├── App/
│   ├── PakktApp.swift          # App entry point
│   ├── RootView.swift          # Root navigation logic
│   └── ContentView.swift       # Legacy (to be removed)
│
├── Core/
│   ├── Network/                # Networking layer
│   │   ├── APIClient.swift
│   │   ├── SupabaseClient.swift
│   │   ├── AppleSignInService.swift
│   │   └── ...
│   │
│   ├── ViewModels/             # Base ViewModel infrastructure
│   │   └── BaseViewModel.swift
│   │
│   ├── Navigation/             # Navigation system
│   │   ├── AppCoordinator.swift
│   │   ├── NavigationDestination.swift
│   │   └── NavigationFactory.swift
│   │
│   ├── Extensions/             # Swift extensions
│   └── Data/                   # Local data/cache
│
├── Features/                   # Feature modules
│   ├── Auth/
│   │   ├── ViewModels/
│   │   │   └── AuthViewModel.swift
│   │   └── Views/
│   │       └── LoginView.swift
│   │
│   ├── Feed/
│   │   ├── ViewModels/
│   │   │   └── FeedViewModel.swift
│   │   └── Views/
│   │
│   ├── Packs/
│   │   ├── ViewModels/
│   │   │   └── PackListViewModel.swift
│   │   └── Views/
│   │
│   ├── Profile/
│   └── ...
│
└── DesignSystem/               # UI components & styling
    ├── Colors/
    ├── Fonts/
    ├── Components/
    └── Styles/
```

---

## 🏗️ Architecture Layers

### **1. View Layer (SwiftUI)**

Pure declarative UI - no business logic.

```swift
struct FeedScreen: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        ScrollView {
            // UI only - data from ViewModel
            ForEach(viewModel.feedItems) { item in
                FeedItemCard(item: item)
            }
        }
        .bindViewModel(viewModel)  // Lifecycle binding
    }
}
```

**Rules:**
- ✅ Render UI based on ViewModel state
- ✅ Forward user actions to ViewModel
- ❌ No API calls in Views
- ❌ No business logic in Views

---

### **2. ViewModel Layer**

Business logic and state management.

```swift
@MainActor
final class FeedViewModel: BaseViewModel {
    @Published var feedItems: [FeedItem] = []

    func loadFeed() async {
        await withLoading {
            let items = try await apiClient.request(
                .getFeed(packId: nil, limit: 20, offset: 0),
                responseType: [FeedItem].self
            )
            self.feedItems = items
        }
    }
}
```

**Responsibilities:**
- ✅ Fetch and transform data
- ✅ Handle user actions
- ✅ Manage loading/error states
- ✅ Expose data to Views via `@Published`

**Base Features (from `BaseViewModel`):**
- `isLoading` - Loading state
- `errorMessage` - Error handling
- `withLoading()` - Automatic loading state
- `handleError()` - Error processing
- `onAppear()` / `onDisappear()` - Lifecycle

---

### **3. Coordinator/Navigation Layer**

Centralized navigation and app flow.

```swift
@MainActor
final class AppCoordinator: ObservableObject {
    @Published var isAuthenticated: Bool
    @Published var navigationPath = NavigationPath()
    @Published var selectedTab: AppTab

    func navigate(to destination: NavigationDestination) {
        navigationPath.append(destination)
    }
}
```

**Responsibilities:**
- ✅ Manage authentication state
- ✅ Handle navigation flow
- ✅ Coordinate between features
- ✅ Deep linking

---

### **4. Network Layer**

API communication and data fetching.

```swift
// Direct API call
let packs = try await APIClient.shared.request(
    .getPacks,
    responseType: [Pack].self
)

// With SupabaseClient (auth)
let session = try await SupabaseClient.shared.signInWithApple(
    idToken: idToken,
    nonce: nonce
)
```

**Features:**
- ✅ Type-safe endpoints
- ✅ Automatic retry logic
- ✅ Error handling
- ✅ Token management
- ✅ Supabase integration

---

## 🔄 Data Flow

```
User Action
    ↓
View forwards to ViewModel
    ↓
ViewModel calls API/Service
    ↓
APIClient makes request
    ↓
Response decoded to Model
    ↓
ViewModel updates @Published properties
    ↓
View automatically re-renders
```

---

## 🧭 Navigation Flow

### **App-Level Navigation**

```swift
RootView
    ├── if !isAuthenticated → AuthFlow
    ├── if shouldShowOnboarding → OnboardingFlow
    └── else → MainTabView
```

### **Tab Navigation**

Each tab has its own `NavigationStack`:

```swift
TabView {
    NavigationStack(path: $coordinator.navigationPath) {
        FeedScreen()
            .navigationDestination(for: NavigationDestination.self) { destination in
                NavigationFactory.build(destination: destination)
            }
    }
    .tabItem { Label("Feed", systemImage: "square.grid.2x2") }
}
```

### **Navigating Between Screens**

```swift
// From anywhere with access to coordinator
coordinator.navigate(to: .packDetail(packId: "123"))

// Navigate back
coordinator.navigateBack()

// Navigate to root
coordinator.navigateToRoot()

// Switch tabs
coordinator.switchTab(to: .profile)
```

---

## 🎯 Creating New Features

### **Step 1: Define Navigation Destination**

```swift
// NavigationDestination.swift
enum NavigationDestination: Hashable {
    case myNewFeature(id: String)
}
```

### **Step 2: Create ViewModel**

```swift
// Features/MyFeature/ViewModels/MyFeatureViewModel.swift
@MainActor
final class MyFeatureViewModel: BaseViewModel {
    @Published var data: [Item] = []

    func loadData() async {
        await withLoading {
            let items = try await apiClient.request(
                .getItems,
                responseType: [Item].self
            )
            self.data = items
        }
    }

    override func onAppear() {
        Task { await loadData() }
    }
}
```

### **Step 3: Create View**

```swift
// Features/MyFeature/Views/MyFeatureView.swift
struct MyFeatureView: View {
    @StateObject private var viewModel = MyFeatureViewModel()

    var body: some View {
        List(viewModel.data) { item in
            Text(item.name)
        }
        .navigationTitle("My Feature")
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            if let error = viewModel.errorMessage {
                Text(error)
            }
        }
        .bindViewModel(viewModel)
    }
}
```

### **Step 4: Register in NavigationFactory**

```swift
// NavigationFactory.swift
case .myNewFeature(let id):
    MyFeatureView(id: id)
```

### **Step 5: Navigate to it**

```swift
coordinator.navigate(to: .myNewFeature(id: "123"))
```

---

## 🔐 Authentication Flow

```
App Launch
    ↓
restoreSession() from Keychain
    ↓
if session valid → MainTabView
if no session → AuthFlow (LoginView)
    ↓
User taps "Sign in with Apple"
    ↓
AppleSignInService handles flow
    ↓
SupabaseClient.signInWithApple()
    ↓
Session saved to Keychain
    ↓
coordinator.handleSignIn(session)
    ↓
isAuthenticated = true → MainTabView
```

---

## 📋 Best Practices

### **ViewModels**
✅ Always inherit from `BaseViewModel`
✅ Use `@MainActor` for UI updates
✅ Use `withLoading()` for async operations
✅ Handle errors with `handleError()`
✅ Implement `onAppear()` for initial data load

### **Views**
✅ Keep views dumb - no business logic
✅ Use `@StateObject` for ViewModel
✅ Use `.bindViewModel()` for lifecycle
✅ Show loading/error states
✅ Use `@EnvironmentObject` for coordinator

### **Navigation**
✅ Always navigate through `AppCoordinator`
✅ Use type-safe `NavigationDestination`
✅ Register views in `NavigationFactory`
✅ Keep navigation logic out of Views

### **Networking**
✅ Define endpoints in `PakktEndpoint`
✅ Create Codable models for responses
✅ Use async/await, not callbacks
✅ Handle errors properly

---

## 🧪 Testing

### **ViewModel Testing**

```swift
@MainActor
final class FeedViewModelTests: XCTestCase {
    func testLoadFeed() async {
        // Arrange
        let mockAPI = MockAPIClient()
        let viewModel = FeedViewModel(apiClient: mockAPI)

        // Act
        await viewModel.loadFeed()

        // Assert
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.feedItems.count, 5)
    }
}
```

### **Mock APIClient**

```swift
class MockAPIClient: APIClient {
    var mockResponse: Any?

    override func request<T: Decodable>(
        _ endpoint: Endpoint,
        responseType: T.Type
    ) async throws -> T {
        return mockResponse as! T
    }
}
```

---

## 🚀 Next Steps

1. **Implement remaining features:**
   - Goals CRUD
   - Check-ins with camera
   - Fines voting system
   - Phone Jail

2. **Add persistence:**
   - Core Data or Realm
   - Offline support
   - Caching layer

3. **Add analytics:**
   - Track user events
   - Crash reporting

4. **Add testing:**
   - Unit tests for ViewModels
   - UI tests for critical flows
   - Snapshot tests for UI

---

## 📚 Resources

- **SwiftUI:** [Apple Documentation](https://developer.apple.com/documentation/swiftui)
- **MVVM Pattern:** [iOS MVVM Guide](https://www.raywenderlich.com/34-design-patterns-by-tutorials-mvvm)
- **Coordinator Pattern:** [Navigation in SwiftUI](https://www.hackingwithswift.com/articles/216/complete-guide-to-navigationstack-in-swiftui)

---

**Architecture established! Ready for feature development.**
