# UnionNetwork

SwiftUI-first reachability monitoring – surface current connectivity as an environment value and react to changes with a single modifier.

## Simple Usage

```swift
import SwiftUI
import UnionNetwork

struct ContentView: View {
    var body: some View {
        Text("Monitoring Network")
            .onNetworkChange { oldPhase, newPhase in
                print("Connectivity changed: \(oldPhase) → \(newPhase)")
            }
    }
}
```

## Features

Environment‑driven: access internetPhase anywhere in your view hierarchy just like scenePhase.

Declarative callbacks: handle connectivity transitions with the onNetworkChange view modifier.

Drop‑in wrapper: use InternetWindowGroup to start monitoring automatically.

Swift‑modern: written in Swift 5.10, requires iOS 17.0+, macOS 14.0+, tvOS 17.0+, or watchOS 10.0+.

No third‑party dependencies.

## Installation

In Xcode choose File ▸ Add Packages…

Enter the URL of this repository:
https://github.com/unionst/UnionNetwork.git

Select Add Package – that's it.

## Quick Start

```swift
import SwiftUI
import UnionNetwork

struct ContentView: View {
    @Environment(\.internetPhase) private var internetPhase
    
    var body: some View {
        VStack(spacing: 24) {
            Text(internetPhase == .connected ? "Online" : "Offline")
                .font(.largeTitle)
                .bold()
            
            Button("Retry") {
                // trigger a network call
            }
            .disabled(internetPhase == .disconnected)
        }
        .onNetworkChange { oldPhase, newPhase in
            print("Connectivity changed: \(oldPhase) → \(newPhase)")
        }
        .padding()
    }
}
```

Or enable monitoring for your entire application with a single wrapper:

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

## API Reference

### InternetPhase

```swift
enum InternetPhase: Equatable {
    case connected      // device currently has internet access
    case disconnected   // no active internet connection detected
}
```

### Environment Key

Access the current phase from any view:

```swift
@Environment(\.internetPhase) private var internetPhase: InternetPhase
```

### onNetworkChange Modifier

Receive a callback whenever connectivity changes:

```swift
.onNetworkChange { previous, current in
    // react to transition
}
```

### InternetWindowGroup

A convenience WindowGroup replacement that starts and stops monitoring with the app life‑cycle.

## Requirements

- Swift 5.10+
- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / watchOS 10.0+

## Contributing

Pull requests are welcome. Please open an issue first to discuss what you would like to change.

## License

UnionNetwork is released under the MIT License. See LICENSE for details.
