//
//  EnterVerificationCodeView.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

struct EnterVerificationCodeView: View {
    let state: PhoneAuthContentState

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                VStack(spacing: 8) {
                    Text("We sent a code to \(state.fullPhoneNumber)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button {
                        state.onChangeNumberClick()
                    } label: {
                        Text("Change number")
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.bottom)
                .frame(maxWidth: .infinity, alignment: .leading)

                // Verification code input
                VerificationCodeInputField(
                    code: state.verificationCode,
                    isError: state.error != nil,
                    errorMessage: state.error,
                    onCodeComplete: { _ in
                        state.onVerifyCodeClick()
                    },
                    onCodeChange: { newCode in
                        state.onVerificationCodeChange(newCode)
                    }
                )

                Button {
                    state.onVerifyCodeClick()
                } label: {
                    if state.isLoading {
                        ProgressView()
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Verify Code")
                            .frame(height: 32)
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(state.isLoading || state.verificationCode.wrappedValue.count != 6)
            }

            // Resend code section
            VStack(spacing: 8) {
                if state.resendTimer > 0 {
                    Text("Resend code in \(state.resendTimer)s")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Button {
                        state.onResendCodeClick()
                    } label: {
                        Text("Resend Code")
                            .font(.caption)
                    }
                    .disabled(state.isLoading)
                }
            }
        }
        .navigationTitle("Verify Phone Number")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavigationStack {
        PhoneAuthView { state in
            EnterVerificationCodeView(state: state)
        }
        .safeAreaPadding()
    }
}
