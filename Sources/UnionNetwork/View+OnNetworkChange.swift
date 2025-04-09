//
//  View+OnNetworkChange.swift
//  union-network
//
//  Created by Ben Sage on 4/9/25.
//

import SwiftUI

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
