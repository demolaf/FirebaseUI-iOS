//
//  ProviderStyle.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 19/10/2025.
//

import SwiftUI

struct ProviderStyle {
    let icon: ImageResource?
    let backgroundColor: Color
    let contentColor: Color
    var iconTint: Color? = nil
    let shape: AnyShape = AnyShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
    let elevation: CGFloat = 2
    
    static let empty = ProviderStyle(
        icon: nil,
        backgroundColor: .white,
        contentColor: .black
    )
    
    static var `default`: [String: ProviderStyle] {
        Dictionary(uniqueKeysWithValues: AuthProvider.allCases.map { provider in
            (provider.id, provider.providerStyle)
        })
    }
}
