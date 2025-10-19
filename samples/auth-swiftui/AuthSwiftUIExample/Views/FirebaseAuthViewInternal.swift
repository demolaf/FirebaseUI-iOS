//
//  FirebaseAuthViewInternal.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

enum Route: Hashable {
    case emailAuth(EmailAuthMode)
    case phoneAuth(PhoneAuthStep)
}

enum EmailAuthMode {
    case signIn
    case signUp
    case resetPassword
}

enum PhoneAuthStep {
    case enterPhoneNumber
    case enterVerificationCode
}

struct CountryData {
    let name: String
    let dialCode: String
    let code: String
    
    var flag: String {
        // Convert country code to flag emoji
        let base: UInt32 = 127397
        var emoji = ""
        for scalar in code.unicodeScalars {
            if let unicodeScalar = UnicodeScalar(base + scalar.value) {
                emoji.append(String(unicodeScalar))
            }
        }
        return emoji
    }
    
    static let `default` = CountryData(name: "United States", dialCode: "+1", code: "US")
}

struct EmailAuthContentState {
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
    var navigator: Navigator
}

struct PhoneAuthContentState {
    var isLoading: Bool
    var error: String?
    var phoneNumber: Binding<String>
    var selectedCountry: CountryData
    var onCountrySelected: (CountryData) -> Void
    var onSendCodeClick: () -> Void
    var verificationCode: Binding<String>
    var onVerificationCodeChange: (String) -> Void
    var onVerifyCodeClick: () -> Void
    var fullPhoneNumber: String
    var onResendCodeClick: () -> Void
    var resendTimer: Int
    var onChangeNumberClick: () -> Void
    var navigator: Navigator
}

@Observable
class Navigator {
    var routes: [Route] = []
    
    func push(_ route: Route) {
        routes.append(route)
    }
    
    @discardableResult
    func pop() -> Route? {
        routes.popLast()
    }
}

struct FirebaseAuthViewInternal: View {
    init(
        interactiveDismissDisabled: Bool = true
    ) {
        self.interactiveDismissDisabled = interactiveDismissDisabled
    }
    
    private var interactiveDismissDisabled: Bool
    @State private var navigator = Navigator()
    
    // Email Auth State
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var displayName = ""
    @State private var emailIsLoading = false
    @State private var emailError: String?
    @State private var resetLinkSent = false
    
    // Phone Auth State
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var selectedCountry: CountryData = .default
    @State private var phoneIsLoading = false
    @State private var phoneError: String?
    @State private var resendTimer = 0
    
    var body: some View {
        NavigationStack(path: $navigator.routes) {
            authMethodPicker
            
                .navigationBarTitleDisplayMode(.large)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .emailAuth(let mode):
                        switch mode {
                        case .signIn:
                            EmailSignInView(state: createEmailAuthState())
                                .safeAreaPadding()
                        case .signUp:
                            EmailSignUpView(state: createEmailAuthState())
                                .safeAreaPadding()
                        case .resetPassword:
                            EmailResetPasswordView(state: createEmailAuthState())
                                .safeAreaPadding()
                        }
                    case .phoneAuth(let step):
                        switch step {
                        case .enterPhoneNumber:
                            EnterPhoneNumberView(state: createPhoneAuthState())
                                .safeAreaPadding()
                        case .enterVerificationCode:
                            EnterVerificationCodeView(state: createPhoneAuthState())
                                .safeAreaPadding()
                        }
                    }
                }
        }
        .interactiveDismissDisabled(interactiveDismissDisabled)
    }
    
    // MARK: - State Creation
    
    private func createEmailAuthState() -> EmailAuthContentState {
        EmailAuthContentState(
            isLoading: emailIsLoading,
            error: emailError,
            email: $email,
            password: $password,
            confirmPassword: $confirmPassword,
            displayName: $displayName,
            resetLinkSent: resetLinkSent,
            onSignInClick: handleEmailSignIn,
            onSignUpClick: handleEmailSignUp,
            onSendResetLinkClick: handleSendResetLink,
            onGoToSignUp: {
                clearEmailForm()
                navigator.push(.emailAuth(.signUp))
            },
            onGoToSignIn: {
                clearEmailForm()
                navigator.push(.emailAuth(.signIn))
            },
            onGoToResetPassword: {
                clearEmailForm()
                navigator.push(.emailAuth(.resetPassword))
            },
            navigator: navigator
        )
    }
    
    private func createPhoneAuthState() -> PhoneAuthContentState {
        PhoneAuthContentState(
            isLoading: phoneIsLoading,
            error: phoneError,
            phoneNumber: $phoneNumber,
            selectedCountry: selectedCountry,
            onCountrySelected: { country in
                selectedCountry = country
            },
            onSendCodeClick: handleSendCode,
            verificationCode: $verificationCode,
            onVerificationCodeChange: { code in
                verificationCode = code
            },
            onVerifyCodeClick: handleVerifyCode,
            fullPhoneNumber: "\(selectedCountry.dialCode) \(phoneNumber)",
            onResendCodeClick: handleResendCode,
            resendTimer: resendTimer,
            onChangeNumberClick: {
                verificationCode = ""
                navigator.pop()
            },
            navigator: navigator
        )
    }
    
    // MARK: - Email Auth Handlers
    
    private func clearEmailForm() {
        email = ""
        password = ""
        confirmPassword = ""
        displayName = ""
    }
    
    private func handleEmailSignIn() {
        // TODO: Implement email sign-in logic
    }
    
    private func handleEmailSignUp() {
        // TODO: Implement email sign-up logic
    }
    
    private func handleSendResetLink() {
        // TODO: Implement password reset logic
    }
    
    // MARK: - Phone Auth Handlers
    
    private func handleSendCode() {
        // TODO: Implement send code logic
        navigator.push(.phoneAuth(.enterVerificationCode))
    }
    
    private func handleVerifyCode() {
        // TODO: Implement verify code logic
    }
    
    private func handleResendCode() {
        // TODO: Implement resend code logic
    }
    
    @ViewBuilder
    var authMethodPicker: some View {
        VStack(spacing: 36) {
            Image(.firebaseAuthLogo)
            GeometryReader { proxy in
                AuthMethodPicker { selectedProvider in
                    switch selectedProvider {
                    case .email:
                        navigator.push(.emailAuth(.signIn))
                    case .phone:
                        navigator.push(.phoneAuth(.enterPhoneNumber))
                    case .google:
                        break
                    case .facebook:
                        break
                    }
                }
                .padding(.horizontal, proxy.size.width * 0.18)
            }
            tosAndPPFooter
        }
        .padding(.top, 24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    var tosAndPPFooter: some View {
        AnnotatedString(
            fullText: "By continuing, you accept our Terms of Service and Privacy Policy.",
            links: [
                ("Terms of Service", "https://example.com/terms"),
                ("Privacy Policy", "https://example.com/privacy")
            ]
        )
    }
}

#Preview {
    FirebaseAuthViewInternal()
}
