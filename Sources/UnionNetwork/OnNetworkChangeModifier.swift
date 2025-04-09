//
//  OnNetworkChangeModifier.swift
//  union-network
//
//  Created by Ben Sage on 4/9/25.
//

import SwiftUI
import Network

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
