//
//  EmailSignInView.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

struct EmailSignInView: View {
    let state: EmailAuthContentState

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Group {
                    AuthTextField(
                        text: state.email,
                        localizedTitle: "Email",
                        prompt: "Enter your email",
                        keyboardType: .emailAddress,
                        contentType: .emailAddress
                    )
                    AuthTextField(
                        text: state.password,
                        localizedTitle: "Password",
                        prompt: "Enter your password",
                        contentType: .password,
                        sensitive: true
                    )
                }

                Button {
                    state.onGoToResetPassword()
                } label: {
                    Text("Forgot password?")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }

                Button {
                    state.onSignInClick()
                } label: {
                    if state.isLoading {
                        ProgressView()
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Sign in")
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

            Button {
                state.onGoToSignUp()
            } label: {
                Text("Create an Account")
                    .frame(maxWidth: .infinity)
            }
            .disabled(state.isLoading)
        }
        .navigationTitle("Sign in with email")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavigationStack {
        EmailSignInView(state: EmailAuthContentState(
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
            onGoToResetPassword: {}
        ))
        .safeAreaPadding()
    }
}
