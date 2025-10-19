//
//  EmailSignUpView.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

struct EmailSignUpView: View {
    let state: EmailAuthContentState

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Group {
                    AuthTextField(
                        text: state.displayName,
                        localizedTitle: "Display Name",
                        prompt: "Enter your name",
                        contentType: .name
                    )

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
                        contentType: .newPassword,
                        sensitive: true
                    )

                    AuthTextField(
                        text: state.confirmPassword,
                        localizedTitle: "Confirm Password",
                        prompt: "Re-enter your password",
                        contentType: .newPassword,
                        sensitive: true
                    )
                }

                Button {
                    state.onSignUpClick()
                } label: {
                    if state.isLoading {
                        ProgressView()
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Create Account")
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
                state.onGoToSignIn()
            } label: {
                Text("Already have an account? Sign In")
                    .frame(maxWidth: .infinity)
            }
            .disabled(state.isLoading)
        }
        .navigationTitle("Create an account")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavigationStack {
        EmailAuthView { state in
            EmailSignUpView(state: state)
        }
        .safeAreaPadding()
    }
}
