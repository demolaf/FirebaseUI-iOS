//
//  EnterPhoneNumberView.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

struct EnterPhoneNumberView: View {
    let state: PhoneAuthContentState
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Enter your phone number to get started")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Phone number input with country selector
            AuthTextField(
                text: state.phoneNumber,
                localizedTitle: "Phone Number",
                prompt: "Enter your phone number",
                keyboardType: .phonePad,
                contentType: .telephoneNumber,
                onChange: { _ in }
            ) {
                CountrySelector(
                    selectedCountry: state.selectedCountry,
                    enabled: !state.isLoading
                )
            }
            
            Button {
                state.onSendCodeClick()
            } label: {
                if state.isLoading {
                    ProgressView()
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                } else {
                    Text("Send Code")
                        .frame(height: 32)
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(state.isLoading || state.phoneNumber.wrappedValue.isEmpty)
            
            if let error = state.error {
                Text(error)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .navigationTitle("Sign in with phone")
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    NavigationStack {
        EnterPhoneNumberView(state: PhoneAuthContentState(
            isLoading: false,
            error: nil,
            phoneNumber: .constant(""),
            selectedCountry: .constant(.default),
            verificationCode: .constant(""),
            fullPhoneNumber: "+1 ",
            resendTimer: 0,
            onSendCodeClick: {},
            onVerifyCodeClick: {},
            onResendCodeClick: {},
            onChangeNumberClick: {}
        ))
        .safeAreaPadding()
    }
}
