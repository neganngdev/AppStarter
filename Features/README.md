# Features Guide

How to add features to your AppStarter app.

## 🎯 Overview

This guide explains how to add new features to your app following the established patterns and best practices.

## 📁 Feature Structure

Each feature should be self-contained in its own folder:

```
Features/
└── YourFeature/
    ├── Models/
    │   └── FeatureModel.swift
    ├── Views/
    │   └── FeatureView.swift
    ├── ViewModels/
    │   └── FeatureViewModel.swift
    └── Services/
        └── FeatureService.swift
```

## 🏗️ MVVM Pattern

### Model

Data structures and business entities.

```swift
// Features/Todo/Models/Todo.swift
struct Todo: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date

    init(title: String) {
        self.id = UUID()
        self.title = title
        self.isCompleted = false
        self.createdAt = Date()
    }
}
```

### ViewModel

Business logic and state management.

```swift
// Features/Todo/ViewModels/TodoViewModel.swift
@MainActor
class TodoViewModel: ObservableObject {

    // MARK: - Published Properties

    @Published var todos: [Todo] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Dependencies

    private let service: TodoService

    // MARK: - Initialization

    init(service: TodoService = TodoService()) {
        self.service = service
    }

    // MARK: - Public Methods

    func loadTodos() async {
        isLoading = true
        errorMessage = nil

        do {
            todos = try await service.fetchTodos()
            Logger.shared.info("Loaded \(todos.count) todos")
        } catch {
            errorMessage = error.localizedDescription
            Logger.shared.error("Failed to load todos: \(error)")
        }

        isLoading = false
    }

    func addTodo(title: String) async {
        let todo = Todo(title: title)

        do {
            try await service.createTodo(todo)
            todos.append(todo)

            // Track analytics
            await AnalyticsManager.shared.trackEvent("todo_created")

            // Haptic feedback
            HapticManager.shared.trigger(.success)

        // Note: When using design system in views, always use explicit prefixes:
        // Color.appPrimary, Font.appBody, etc. to avoid type ambiguity
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleTodo(_ todo: Todo) async {
        guard let index = todos.firstIndex(where: { $0.id == todo.id }) else { return }

        todos[index].isCompleted.toggle()

        do {
            try await service.updateTodo(todos[index])
            HapticManager.shared.trigger(.light)
        } catch {
            // Revert on error
            todos[index].isCompleted.toggle()
            errorMessage = error.localizedDescription
        }
    }
}
```

### View

SwiftUI view using the ViewModel.

```swift
// Features/Todo/Views/TodoView.swift
struct TodoView: View {

    @StateObject private var viewModel = TodoViewModel()
    @State private var newTodoTitle = ""
    @State private var showToast = false

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    LoadingView(text: "Loading todos...")
                } else if viewModel.todos.isEmpty {
                    EmptyStateView.emptyList(
                        title: "No Todos",
                        message: "Add your first todo to get started",
                        actionTitle: "Add Todo"
                    ) {
                        // Focus on input
                    }
                } else {
                    todoList
                }
            }
            .navigationTitle("Todos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton
                }
            }
            .toast($showToast, message: "Todo added!", type: .success)
            .task {
                await viewModel.loadTodos()
            }
        }
    }

    // MARK: - Subviews

    private var todoList: some View {
        List {
            ForEach(viewModel.todos) { todo in
                TodoRow(todo: todo) {
                    Task {
                        await viewModel.toggleTodo(todo)
                    }
                }
            }
        }
    }

    private var addButton: some View {
        Button(action: { showAddSheet = true }) {
            Image(systemName: "plus")
        }
    }
}

// MARK: - Todo Row

struct TodoRow: View {
    let todo: Todo
    let onToggle: () -> Void

    var body: some View {
        HStack {
            Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(todo.isCompleted ? Color.appSuccess : Color.appSecondaryText)
                .onTapGesture {
                    onToggle()
                }

            VStack(alignment: .leading, spacing: AppSpacing.xxSmall) {
                Text(todo.title)
                    .font(Font.appBody)
                    .foregroundColor(Color.appText)
                    .strikethrough(todo.isCompleted)

                Text(todo.createdAt.formatted())
                    .font(Font.appCaption)
                    .foregroundColor(Color.appSecondaryText)
            }
        }
        .padding(.vertical, AppSpacing.xSmall)
    }
}
```

### Service

API calls and data operations.

```swift
// Features/Todo/Services/TodoService.swift
class TodoService {

    private let networkManager = NetworkManager.shared

    func fetchTodos() async throws -> [Todo] {
        try await networkManager.request(endpoint: TodoEndpoint.list)
    }

    func createTodo(_ todo: Todo) async throws {
        try await networkManager.request(endpoint: TodoEndpoint.create(todo))
    }

    func updateTodo(_ todo: Todo) async throws {
        try await networkManager.request(endpoint: TodoEndpoint.update(todo))
    }

    func deleteTodo(_ id: UUID) async throws {
        try await networkManager.request(endpoint: TodoEndpoint.delete(id))
    }
}

// MARK: - API Endpoints

enum TodoEndpoint: APIEndpoint {
    case list
    case create(Todo)
    case update(Todo)
    case delete(UUID)

    var path: String {
        switch self {
        case .list:
            return "/todos"
        case .create:
            return "/todos"
        case .update(let todo):
            return "/todos/\(todo.id)"
        case .delete(let id):
            return "/todos/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .create:
            return .post
        case .update:
            return .put
        case .delete:
            return .delete
        }
    }
}
```

## 🎨 Using Design System

Always use design system components with **explicit type prefixes**:

```swift
// Colors - ALWAYS use Color. prefix
.foregroundColor(Color.appPrimary)
.background(Color.appSecondaryBackground)

// Fonts - ALWAYS use Font. prefix
.font(Font.appTitle)
.font(Font.appBody)

// Spacing
.padding(AppSpacing.medium)
VStack(spacing: AppSpacing.small) { }

// Components
AppButton("Save", style: .primary) { }
AppTextField("Title", text: $title)
AppCard { /* content */ }

// Modifiers
.toast($showToast, message: "Success!", type: .success)
.loading(isLoading)
.dismissKeyboardOnTap()
```

## 📊 Analytics Integration

Track important user actions:

```swift
// In ViewModel
func performAction() async {
    // Do action

    // Track event
    await AnalyticsManager.shared.trackEvent("action_performed", parameters: [
        "feature": "todos",
        "count": todos.count
    ])
}

// Add custom events in AnalyticsEvent.swift
static func todoCreated() -> AnalyticsEvent {
    AnalyticsEvent(name: "todo_created")
}
```

## 🎯 Haptic Feedback

Add haptics for better UX:

```swift
// Success feedback
HapticManager.shared.trigger(.success)

// Light tap
HapticManager.shared.trigger(.light)

// Selection change
HapticManager.shared.trigger(.selection)
```

## 💾 Data Persistence

### UserDefaults

```swift
// Simple preferences
AppStorage.hasSeenTutorial = true
```

### Keychain

```swift
// Sensitive data
try? KeychainManager.shared.save("api_token", value: token)
```

### FileStorage

```swift
// Files and images
try? await FileStorageManager.shared.save(todos, filename: "todos.json")
```

## 🧪 Testing

Create tests for ViewModels:

```swift
@MainActor
class TodoViewModelTests: XCTestCase {

    var viewModel: TodoViewModel!
    var mockService: MockTodoService!

    override func setUp() {
        mockService = MockTodoService()
        viewModel = TodoViewModel(service: mockService)
    }

    func testLoadTodos() async {
        await viewModel.loadTodos()
        XCTAssertEqual(viewModel.todos.count, 2)
    }
}
```

## ✅ Checklist for New Features

- [ ] Create feature folder in `Features/`
- [ ] Define models
- [ ] Create service for API calls
- [ ] Implement ViewModel with business logic
- [ ] Build View using design system
- [ ] Add analytics tracking
- [ ] Add haptic feedback
- [ ] Handle loading and error states
- [ ] Add to navigation (if needed)
- [ ] Test on device
- [ ] Write unit tests (optional)

## 💡 Best Practices

1. **Keep ViewModels focused** - One feature per ViewModel
2. **Use design system with explicit prefixes** - Always use `Color.appPrimary` and `Font.appBody` (not `.appPrimary` or `.appBody`)
3. **Handle errors** - Always show user-friendly errors
4. **Track analytics** - Track key user actions
5. **Add haptics** - Enhance interactions
6. **Test on device** - Simulator isn't enough
7. **Follow MVVM** - Keep Views simple, logic in ViewModels
8. **iOS 16 compatibility** - Use single-parameter `onChange` closures: `.onChange(of: value) { newValue in }`

### ⚠️ Common Mistakes to Avoid

**Don't use shorthand notation for design system:**

```swift
// ❌ Wrong - causes "Ambiguous use" errors
Text("Hello").foregroundColor(.appPrimary).font(.appBody)

// ✅ Correct - always use explicit prefixes
Text("Hello").foregroundColor(Color.appPrimary).font(Font.appBody)
```

**Don't use iOS 17+ only APIs:**

```swift
// ❌ Wrong - iOS 17+ only
.onChange(of: value) { oldValue, newValue in }

// ✅ Correct - iOS 16+ compatible
.onChange(of: value) { newValue in }
```

## 🚀 Example Features

### Simple Feature (No API)

- Settings toggle
- Local data list
- Utility screen

### Medium Feature (With API)

- User profile
- Content feed
- Search

### Complex Feature

- Chat system
- Social features
- Real-time updates

---

**Ready to build?** Start with a simple feature and grow from there!

See [ARCHITECTURE.md](ARCHITECTURE.md) for more details on patterns and structure.
