//
//  InternetWindowGroup.swift
//  union-network
//
//  Created by Ben Sage on 4/9/25.
//

import SwiftUI

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
