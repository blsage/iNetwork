# iNetwork

iNetwork is a Swift package that monitors network connectivity changes and provides a custom environment value—`internetPhase`—that behaves similarly to SwiftUI’s built-in `scenePhase`.

## Installation

Add iNetwork to your project via Swift Package Manager.

## API

### Custom Environment Value

Access the current network status anywhere in your view hierarchy using the custom environment key:

```swift
@Environment(\.internetPhase) private var internetPhase: InternetPhase
```

The `InternetPhase` enum has two cases:

```swift
enum InternetPhase: Equatable {
    case connected
    case disconnected
}

### `onNetworkChange` Modifier

Attach the `onNetworkChange` view modifier to any view to receive network change notifications.

```swift
Text("Hello, iNetwork!")
    .onNetworkChange { oldPhase, newPhase in
        // Handle network phase change from oldPhase to newPhase
    }
```

### `InternetWindowGroup` (Optional)

For convenience, wrap your app's main content with `InternetWindowGroup` to automatically enable network monitoring:

```swift
@main
struct MyApp: App {
    var body: some Scene {
        InternetWindowGroup {
            ContentView()
        }
    }
}
```

## License

Distributed under the MIT License. See `LICENSE` for details.
