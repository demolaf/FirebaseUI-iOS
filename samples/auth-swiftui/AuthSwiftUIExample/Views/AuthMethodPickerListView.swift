//
//  AuthMethodPickerListView.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

struct AuthMethodPickerListView: View {
    var onProviderSelected: (AuthProvider) -> Void
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView {
                VStack(spacing: 16) {
                    AuthProviderButton(
                        provider: .apple,
                        onClick: onProviderSelected
                    )
                    AuthProviderButton(
                        provider: .anonymous,
                        onClick: onProviderSelected
                    )
                    AuthProviderButton(
                        provider: .email,
                        onClick: onProviderSelected
                    )
                    AuthProviderButton(
                        provider: .phone,
                        onClick: onProviderSelected
                    )
                    AuthProviderButton(
                        provider: .google,
                        onClick: onProviderSelected
                    )
                    AuthProviderButton(
                        provider: .facebook,
                        onClick: onProviderSelected
                    )
                    AuthProviderButton(
                        provider: .twitter,
                        onClick: onProviderSelected
                    )
                    AuthProviderButton(
                        provider: .github,
                        onClick: onProviderSelected
                    )
                    AuthProviderButton(
                        provider: .microsoft,
                        onClick: onProviderSelected
                    )
                    AuthProviderButton(
                        provider: .yahoo,
                        onClick: onProviderSelected
                    )
                }
                .padding(.horizontal, proxy.size.width * 0.18)
            }
        }
    }
}

#Preview {
    AuthMethodPickerListView { selectedProvider in }
}
