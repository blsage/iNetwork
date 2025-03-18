//
//  iNetwork.swift
//  iNetwork
//
//  Created by Benjamin Sage on 3/17/25.
//

import SwiftUI
import Network

public enum InternetPhase: Equatable, Sendable {
    case connected
    case disconnected
}

extension EnvironmentValues {
    @Entry public var internetPhase: InternetPhase = .disconnected
}

struct OnNetworkChangeModifier: ViewModifier {
    let action: (InternetPhase, InternetPhase) -> Void
    @State private var currentPhase: InternetPhase = .disconnected

    func body(content: Content) -> some View {
        content
            .environment(\.internetPhase, currentPhase)
            .onAppear {
                Task {
                    let monitor = NWPathMonitor()
                    let queue = DispatchQueue.global(qos: .background)
                    var previousPhase = currentPhase
                    let stream = AsyncStream<InternetPhase> { continuation in
                        monitor.pathUpdateHandler = { path in
                            let newPhase = path.status == .satisfied ? InternetPhase.connected : .disconnected
                            continuation.yield(newPhase)
                        }
                        monitor.start(queue: queue)
                        continuation.onTermination = { _ in
                            monitor.cancel()
                        }
                    }
                    for await newPhase in stream {
                        let oldPhase = previousPhase
                        if oldPhase != newPhase {
                            previousPhase = newPhase
                            await MainActor.run {
                                currentPhase = newPhase
                                action(oldPhase, newPhase)
                            }
                        }
                    }
                }
            }
    }
}

extension View {
    public func onNetworkChange(
        perform action: @escaping (InternetPhase, InternetPhase) -> Void = { _, _ in }
    ) -> some View {
        modifier(OnNetworkChangeModifier(action: action))
    }

    @available(iOS, deprecated: 17.0, message: "Use the two-parameter onNetworkChange version instead")
    public func onNetworkChange(perform action: @escaping (InternetPhase) -> Void) -> some View {
        modifier(OnNetworkChangeModifier(action: { _, new in action(new) }))
    }
}

@available(iOS 14.0, *)
public struct InternetWindowGroup<Content: View>: Scene {
    let content: () -> Content

    public var body: some Scene {
        WindowGroup {
            content()
                .onNetworkChange()
        }
    }
}
