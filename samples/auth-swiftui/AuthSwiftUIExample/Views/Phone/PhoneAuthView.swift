//
//  PhoneAuthView.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

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

struct PhoneAuthContentState {
    var step: Binding<PhoneAuthStep>
    var isLoading: Bool
    var error: String?
    var phoneNumber: Binding<String>
    var selectedCountry: Binding<CountryData>
    var verificationCode: Binding<String>
    var fullPhoneNumber: String
    var resendTimer: Int
    var onSendCodeClick: () -> Void
    var onVerifyCodeClick: () -> Void
    var onResendCodeClick: () -> Void
    var onChangeNumberClick: () -> Void
}

struct PhoneAuthView<Content: View>: View {
    @ViewBuilder let content: (PhoneAuthContentState) -> Content
    @State private var step: PhoneAuthStep = .enterPhoneNumber
    @State private var phoneNumber = ""
    @State private var verificationCode = ""
    @State private var selectedCountry: CountryData = .default
    @State private var isLoading = false
    @State private var error: String?
    @State private var resendTimer = 0

    var body: some View {
        content(createState())
            .navigationBarTitleDisplayMode(.large)
    }

    private func createState() -> PhoneAuthContentState {
        PhoneAuthContentState(
            step: $step,
            isLoading: isLoading,
            error: error,
            phoneNumber: $phoneNumber,
            selectedCountry: $selectedCountry,
            verificationCode: $verificationCode,
            fullPhoneNumber: "\(selectedCountry.dialCode) \(phoneNumber)",
            resendTimer: resendTimer,
            onSendCodeClick: handleSendCode,
            onVerifyCodeClick: handleVerifyCode,
            onResendCodeClick: handleResendCode,
            onChangeNumberClick: {
                step = .enterPhoneNumber
                verificationCode = ""
            }
        )
    }

    private func handleSendCode() {
        // TODO: Implement send code logic
        withAnimation { step = .enterVerificationCode }
    }

    private func handleVerifyCode() {
        // TODO: Implement verify code logic
    }

    private func handleResendCode() {
        // TODO: Implement resend code logic
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
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
