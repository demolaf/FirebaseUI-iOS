//
//  EmailResetPasswordView.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

struct EmailResetPasswordView: View {
    let state: EmailAuthContentState

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                if state.resetLinkSent {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.green)

                        Text("Password reset link sent!")
                            .font(.headline)

                        Text("Check your email at \(state.email.wrappedValue) for a link to reset your password.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                } else {
                    VStack(spacing: 16) {
                        Text("Enter your email address and we'll send you a link to reset your password.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        AuthTextField(
                            text: state.email,
                            localizedTitle: "Email",
                            prompt: "Enter your email",
                            keyboardType: .emailAddress,
                            contentType: .emailAddress
                        )

                        Button {
                            state.onSendResetLinkClick()
                        } label: {
                            if state.isLoading {
                                ProgressView()
                                    .frame(height: 32)
                                    .frame(maxWidth: .infinity)
                            } else {
                                Text("Send Reset Link")
                                    .frame(height: 32)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(state.isLoading)

                        if let error = state.error {
                            Text(error)
                                .foregroundStyle(.red)
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .navigationTitle("Reset Password")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavigationStack {
        EmailResetPasswordView(state: EmailAuthContentState(
            isLoading: false,
            error: nil,
            email: .constant(""),
            password: .constant(""),
            confirmPassword: .constant(""),
            displayName: .constant(""),
            resetLinkSent: false,
            onSignInClick: {},
            onSignUpClick: {},
            onSendResetLinkClick: {},
            onGoToSignUp: {},
            onGoToSignIn: {},
            onGoToResetPassword: {},
            navigator: Navigator()
        ))
        .safeAreaPadding()
    }
}
