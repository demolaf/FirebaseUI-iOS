//
//  FirebaseAuthViewInternal.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

enum Route: Hashable {
    case emailAuth
    case phoneAuth
}

@Observable
class Navigator {
    var routes: [Route] = []
    
    func push(_ route: Route) {
        routes.append(route)
    }
    
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
    
    var body: some View {
        NavigationStack(path: $navigator.routes) {
            authMethodPicker
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .emailAuth:
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
                    case .phoneAuth:
                        PhoneAuthView { state in
                            switch state.step.wrappedValue {
                            case .enterPhoneNumber:
                                EnterPhoneNumberView(state: state)
                            case .enterVerificationCode:
                                EnterVerificationCodeView(state: state)
                            }
                        }
                        .safeAreaPadding()
                    }
                }
        }
        .interactiveDismissDisabled(interactiveDismissDisabled)
    }
    
    @ViewBuilder
    var authMethodPicker: some View {
        VStack(spacing: 36) {
            Image(.firebaseAuthLogo)
            GeometryReader { proxy in
                AuthMethodPicker { selectedProvider in
                    switch selectedProvider {
                    case .email:
                        navigator.push(.emailAuth)
                    case .phone:
                        navigator.push(.phoneAuth)
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
