# Features Directory

This directory is where you'll build your app-specific features. Each feature should be self-contained and follow the MVVM architecture pattern.

## 📁 Recommended Folder Structure

Organize each feature in its own directory with the following structure:

```
Features/
├── FeatureName/
│   ├── Models/
│   │   └── FeatureModel.swift
│   ├── ViewModels/
│   │   └── FeatureViewModel.swift
│   ├── Views/
│   │   ├── FeatureView.swift
│   │   └── FeatureDetailView.swift
│   └── Services/
│       └── FeatureService.swift
└── AnotherFeature/
    └── ...
```

## 🏗️ MVVM Architecture Guidelines

### Model
- **Purpose**: Represents data and business logic
- **Responsibilities**:
  - Define data structures
  - Data validation
  - Business rules
- **Example**:
```swift
struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
}
```

### View
- **Purpose**: UI presentation layer
- **Responsibilities**:
  - Display data
  - Handle user interactions
  - Delegate actions to ViewModel
- **Best Practices**:
  - Keep views dumb (no business logic)
  - Use `@StateObject` for owned ViewModels
  - Use `@ObservedObject` for passed ViewModels
- **Example**:
```swift
struct TaskListView: View {
    @StateObject private var viewModel = TaskListViewModel()
    
    var body: some View {
        List(viewModel.tasks) { task in
            TaskRow(task: task)
        }
        .onAppear {
            viewModel.loadTasks()
        }
    }
}
```

### ViewModel
- **Purpose**: Presentation logic and state management
- **Responsibilities**:
  - Prepare data for display
  - Handle user actions
  - Coordinate with services
  - Manage view state
- **Best Practices**:
  - Conform to `ObservableObject`
  - Use `@Published` for properties that trigger UI updates
  - Keep ViewModels testable (no direct UIKit dependencies)
  - Use `@MainActor` for UI-related ViewModels
- **Example**:
```swift
@MainActor
class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let taskService: TaskService
    
    init(taskService: TaskService = TaskService()) {
        self.taskService = taskService
    }
    
    func loadTasks() {
        isLoading = true
        Task {
            do {
                tasks = try await taskService.fetchTasks()
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    func addTask(title: String) {
        let task = Task(id: UUID(), title: title, isCompleted: false, createdAt: Date())
        tasks.append(task)
        // Save to service
    }
}
```

### Service
- **Purpose**: Data access and business operations
- **Responsibilities**:
  - API calls
  - Database operations
  - Data persistence
  - Business logic
- **Example**:
```swift
actor TaskService {
    func fetchTasks() async throws -> [Task] {
        // Fetch from API or local storage
        []
    }
    
    func saveTask(_ task: Task) async throws {
        // Save to API or local storage
    }
}
```

## 🎯 Best Practices

### 1. Separation of Concerns
- **Models**: Pure data, no UI dependencies
- **Views**: Pure UI, no business logic
- **ViewModels**: Bridge between Views and Services
- **Services**: Data operations, no UI dependencies

### 2. Naming Conventions
- **Models**: Noun (e.g., `Task`, `User`, `Product`)
- **Views**: `<Feature>View` (e.g., `TaskListView`, `TaskDetailView`)
- **ViewModels**: `<Feature>ViewModel` (e.g., `TaskListViewModel`)
- **Services**: `<Feature>Service` (e.g., `TaskService`, `AuthService`)

### 3. File Organization
```
TaskManagement/
├── Models/
│   ├── Task.swift
│   └── TaskCategory.swift
├── ViewModels/
│   ├── TaskListViewModel.swift
│   └── TaskDetailViewModel.swift
├── Views/
│   ├── TaskListView.swift
│   ├── TaskDetailView.swift
│   └── Components/
│       ├── TaskRow.swift
│       └── TaskCard.swift
└── Services/
    └── TaskService.swift
```

### 4. Dependency Injection
Always inject dependencies to make code testable:

```swift
class TaskListViewModel: ObservableObject {
    private let taskService: TaskService
    
    // Inject service (allows mocking in tests)
    init(taskService: TaskService = TaskService()) {
        self.taskService = taskService
    }
}
```

### 5. Error Handling
Use proper error handling patterns:

```swift
@Published var errorMessage: String?
@Published var showError = false

func loadData() {
    Task {
        do {
            data = try await service.fetch()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
```

### 6. Loading States
Always show loading states for async operations:

```swift
@Published var isLoading = false

func loadData() {
    isLoading = true
    defer { isLoading = false }
    // Fetch data
}
```

## 🚀 Quick Start Example

Here's a complete minimal feature example:

### 1. Create the Model
```swift
// Features/Counter/Models/CounterModel.swift
struct CounterModel {
    var count: Int = 0
}
```

### 2. Create the ViewModel
```swift
// Features/Counter/ViewModels/CounterViewModel.swift
@MainActor
class CounterViewModel: ObservableObject {
    @Published var model = CounterModel()
    
    func increment() {
        model.count += 1
    }
    
    func decrement() {
        model.count -= 1
    }
    
    func reset() {
        model.count = 0
    }
}
```

### 3. Create the View
```swift
// Features/Counter/Views/CounterView.swift
struct CounterView: View {
    @StateObject private var viewModel = CounterViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("\(viewModel.model.count)")
                .font(.largeTitle)
            
            HStack(spacing: 20) {
                Button("−") { viewModel.decrement() }
                Button("Reset") { viewModel.reset() }
                Button("+") { viewModel.increment() }
            }
        }
    }
}
```

## 📚 Additional Resources

- [Apple's SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [MVVM Pattern in SwiftUI](https://www.hackingwithswift.com/books/ios-swiftui/introducing-mvvm-into-your-swiftui-project)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

## 💡 Tips

1. **Start Simple**: Begin with a minimal feature and expand as needed
2. **Test Early**: Write unit tests for ViewModels and Services
3. **Reuse Components**: Put reusable UI components in `UI/Components/`
4. **Stay Consistent**: Follow the same patterns across all features
5. **Document Complex Logic**: Add comments for non-obvious code

---

**Ready to build?** Create your first feature directory and start coding! 🎉
