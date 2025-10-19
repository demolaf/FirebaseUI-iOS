//
//  AuthMethodPicker.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

enum AuthProvider {
    case email
    case phone
    case google
    case facebook

    var displayName: String {
        switch self {
        case .email:
            return "Sign in with email"
        case .phone:
            return "Sign in with phone"
        case .google:
            return "Sign in with Google"
        case .facebook:
            return "Sign in with Facebook"
        }
    }

    var icon: ImageResource {
        switch self {
        case .email:
            return .fuiIcMail
        case .phone:
            return .fuiIcPhone
        case .google:
            return .fuiIcGoogleg
        case .facebook:
            return .fuiIcFacebook
        }
    }
}

struct AuthMethodPicker: View {
    var onProviderSelected: (AuthProvider) -> Void

    var body: some View {
        VStack(spacing: 16) {
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
        }
    }
}

struct AuthProviderButton: View {
    let provider: AuthProvider
    let onClick: (AuthProvider) -> Void
    var enabled: Bool = true

    var body: some View {
        Button {
            onClick(provider)
        } label: {
            HStack {
                Image(provider.icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(provider.displayName)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!enabled)
    }
}

#Preview {
    AuthMethodPicker { selectedProvider in }
}
