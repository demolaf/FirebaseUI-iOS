//
//  VerificationCodeInputField.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

struct VerificationCodeInputField: View {
    @Binding var code: String
    let codeLength: Int
    let isError: Bool
    let errorMessage: String?
    let onCodeComplete: (String) -> Void
    let onCodeChange: (String) -> Void
    
    @State private var digitFields: [String] = []
    @State private var focusedIndex: Int? = nil
    @FocusState private var focusedField: Int?
    
    init(
        code: Binding<String>,
        codeLength: Int = 6,
        isError: Bool = false,
        errorMessage: String? = nil,
        onCodeComplete: @escaping (String) -> Void = { _ in },
        onCodeChange: @escaping (String) -> Void = { _ in }
    ) {
        self._code = code
        self.codeLength = codeLength
        self.isError = isError
        self.errorMessage = errorMessage
        self.onCodeComplete = onCodeComplete
        self.onCodeChange = onCodeChange
        self._digitFields = State(initialValue: Array(repeating: "", count: codeLength))
    }
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(0..<codeLength, id: \.self) { index in
                    SingleDigitField(
                        digit: $digitFields[index],
                        isError: isError,
                        isFocused: focusedField == index,
                        onDigitChanged: { newDigit in
                            handleDigitChanged(at: index, newDigit: newDigit)
                        },
                        onBackspace: {
                            handleBackspace(at: index)
                        },
                        onFocusChanged: { isFocused in
                            if isFocused {
                                focusedField = index
                            }
                        }
                    )
                    .focused($focusedField, equals: index)
                }
            }
            
            if isError, let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .onAppear {
            // Initialize digit fields from the code binding
            updateDigitFieldsFromCode()
        }
    }
    
    private func updateDigitFieldsFromCode() {
        let codeArray = Array(code)
        for i in 0..<codeLength {
            if i < codeArray.count {
                digitFields[i] = String(codeArray[i])
            } else {
                digitFields[i] = ""
            }
        }
    }
    
    private func handleDigitChanged(at index: Int, newDigit: String) {
        // Update the digit field
        digitFields[index] = newDigit
        
        // Update the main code string
        let newCode = digitFields.joined()
        code = newCode
        onCodeChange(newCode)
        
        // Move to next empty field if digit was entered (only when adding, not removing)
        if !newDigit.isEmpty {
            let nextEmptyIndex = findNextEmptyField(startingFrom: index)
            if let nextIndex = nextEmptyIndex {
                DispatchQueue.main.async {
                    focusedField = nextIndex
                }
            }
        }
        
        // Check if code is complete
        if newCode.count == codeLength {
            DispatchQueue.main.async {
                onCodeComplete(newCode)
            }
        }
    }
    
    private func handleBackspace(at index: Int) {
        // If current field is empty, move to previous field and clear it
        if digitFields[index].isEmpty && index > 0 {
            digitFields[index - 1] = ""
            DispatchQueue.main.async {
                focusedField = index - 1
            }
        } else {
            // Clear current field
            digitFields[index] = ""
        }
        
        // Update the main code string
        let newCode = digitFields.joined()
        code = newCode
        onCodeChange(newCode)
    }
    
    private func findNextEmptyField(startingFrom index: Int) -> Int? {
        // Look for the next empty field after the current index
        for i in (index + 1)..<codeLength {
            if digitFields[i].isEmpty {
                return i
            }
        }
        // If no empty field found after current index, look from the beginning
        for i in 0..<index {
            if digitFields[i].isEmpty {
                return i
            }
        }
        return nil
    }
}

private struct SingleDigitField: View {
    @Binding var digit: String
    let isError: Bool
    let isFocused: Bool
    let onDigitChanged: (String) -> Void
    let onBackspace: () -> Void
    let onFocusChanged: (Bool) -> Void
    
    @State private var borderWidth: CGFloat = 1
    @State private var borderColor: Color = Color(.systemFill)
    
    var body: some View {
        TextField("", text: $digit)
            .font(.system(size: 24, weight: .medium, design: .default))
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .textContentType(.oneTimeCode)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .frame(width: 48, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
            )
            .frame(maxWidth: .infinity)
            .onChange(of: digit) { oldValue, newValue in
                // Only allow single digit
                if newValue.count > 1 {
                    digit = String(newValue.prefix(1))
                }
                
                // Only allow digits
                if !digit.isEmpty && !digit.allSatisfy({ $0.isNumber }) {
                    digit = ""
                }
                
                onDigitChanged(digit)
            }
            .onChange(of: isFocused) { oldValue, newValue in
                updateBorderAppearance()
                onFocusChanged(newValue)
            }
            .onChange(of: isError) { oldValue, newValue in
                updateBorderAppearance()
            }
            .onChange(of: digit) { oldValue, newValue in
                updateBorderAppearance()
            }
            .onKeyPress(.delete) {
                if digit.isEmpty {
                    // If current field is empty, move to previous field and clear it
                    onBackspace()
                } else {
                    // Clear current field
                    digit = ""
                }
                return .handled
            }
            .onAppear {
                updateBorderAppearance()
            }
    }
    
    private func updateBorderAppearance() {
        withAnimation(.easeInOut(duration: 0.15)) {
            if isError {
                borderWidth = 2
                borderColor = .red
            } else if isFocused || !digit.isEmpty {
                borderWidth = 3
                borderColor = .accentColor
            } else {
                borderWidth = 1
                borderColor = Color(.systemFill)
            }
        }
    }
}

// MARK: - Preview

#Preview("Normal State") {
    @Previewable @State var code = ""
    
    return VStack(spacing: 32) {
        Text("Enter Verification Code")
            .font(.title2)
            .fontWeight(.semibold)
        
        VerificationCodeInputField(
            code: $code,
            onCodeComplete: { completedCode in
                print("Code completed: \(completedCode)")
            },
            onCodeChange: { newCode in
                print("Code changed: \(newCode)")
            }
        )
        
        Text("Current code: \(code)")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
}

#Preview("Error State") {
    @Previewable @State var code = "12345"
    
    return VStack(spacing: 32) {
        Text("Enter Verification Code")
            .font(.title2)
            .fontWeight(.semibold)
        
        VerificationCodeInputField(
            code: $code,
            isError: true,
            errorMessage: "Invalid verification code",
            onCodeComplete: { completedCode in
                print("Code completed: \(completedCode)")
            },
            onCodeChange: { newCode in
                print("Code changed: \(newCode)")
            }
        )
        
        Text("Current code: \(code)")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
}

#Preview("Custom Length") {
    @Previewable @State var code = ""
    
    return VStack(spacing: 32) {
        Text("Enter 4-Digit Code")
            .font(.title2)
            .fontWeight(.semibold)
        
        VerificationCodeInputField(
            code: $code,
            codeLength: 4,
            onCodeComplete: { completedCode in
                print("Code completed: \(completedCode)")
            },
            onCodeChange: { newCode in
                print("Code changed: \(newCode)")
            }
        )
        
        Text("Current code: \(code)")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
}
