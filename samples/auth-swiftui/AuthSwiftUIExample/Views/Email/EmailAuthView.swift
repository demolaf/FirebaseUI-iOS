//
//  EmailAuthView.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

enum EmailAuthMode {
    case signIn
    case signUp
    case resetPassword
}

struct EmailAuthContentState {
    var mode: Binding<EmailAuthMode>
    var isLoading: Bool
    var error: String?
    var email: Binding<String>
    var password: Binding<String>
    var confirmPassword: Binding<String>
    var displayName: Binding<String>
    var resetLinkSent: Bool
    var onSignInClick: () -> Void
    var onSignUpClick: () -> Void
    var onSendResetLinkClick: () -> Void
    var onGoToSignUp: () -> Void
    var onGoToSignIn: () -> Void
    var onGoToResetPassword: () -> Void
}

struct EmailAuthView<Content: View>: View {
    @ViewBuilder let content: (EmailAuthContentState) -> Content

    @State private var mode: EmailAuthMode = .signIn
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var displayName = ""
    @State private var isLoading = false
    @State private var error: String?
    @State private var resetLinkSent = false

    var body: some View {
        content(createState())
            .navigationBarTitleDisplayMode(.large)
    }

    private func createState() -> EmailAuthContentState {
        EmailAuthContentState(
            mode: $mode,
            isLoading: isLoading,
            error: error,
            email: $email,
            password: $password,
            confirmPassword: $confirmPassword,
            displayName: $displayName,
            resetLinkSent: resetLinkSent,
            onSignInClick: handleSignIn,
            onSignUpClick: handleSignUp,
            onSendResetLinkClick: handleSendResetLink,
            onGoToSignUp: { changeEmailAuthMode(.signUp) },
            onGoToSignIn: { changeEmailAuthMode(.signIn) },
            onGoToResetPassword: { changeEmailAuthMode(.resetPassword) }
        )
    }
    
    private func changeEmailAuthMode(_ newMode: EmailAuthMode) {
        email = ""
        password = ""
        confirmPassword = ""
        displayName = ""
        withAnimation { mode = newMode }
    }

    private func handleSignIn() {
        // TODO: Implement sign-in logic
    }

    private func handleSignUp() {
        // TODO: Implement sign-up logic
    }

    private func handleSendResetLink() {
        // TODO: Implement password reset logic
    }
}

#Preview {
    NavigationStack {
        EmailAuthView { state in
            switch state.mode.wrappedValue {
            case .signIn:
                EmailSignInView(state: state)
            case .signUp:
                EmailSignUpView(state: state)
            case .resetPassword:
                EmailResetPasswordView(state: state)
            }
        }
        .safeAreaPadding()
    }
}
