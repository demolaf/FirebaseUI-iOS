//
//  VerificationCodeInputField.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI
import UIKit

struct VerificationCodeInputField: View {
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
    
    @Binding var code: String
    let codeLength: Int
    let isError: Bool
    let errorMessage: String?
    let onCodeComplete: (String) -> Void
    let onCodeChange: (String) -> Void
    
    @State private var digitFields: [String] = []
    @State private var focusedIndex: Int? = nil
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(0..<codeLength, id: \.self) { index in
                    SingleDigitField(
                        digit: $digitFields[index],
                        isError: isError,
                        isFocused: focusedIndex == index,
                        onDigitChanged: { newDigit in
                            handleDigitChanged(at: index, newDigit: newDigit)
                        },
                        onBackspace: {
                            handleBackspace(at: index)
                        },
                        onFocusChanged: { isFocused in
                            DispatchQueue.main.async {
                                if isFocused {
                                    focusedIndex = index
                                } else if focusedIndex == index {
                                    focusedIndex = nil
                                }
                            }
                        }
                    )
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
        // Update the digit field only if it actually changed to avoid redundant state writes
        if digitFields[index] != newDigit {
            digitFields[index] = newDigit
        }

        // Update the main code string
        let newCode = digitFields.joined()
        code = newCode
        onCodeChange(newCode)
        
        // Move to next empty field if digit was entered (only when adding, not removing)
        if !newDigit.isEmpty {
            if let nextIndex = findNextEmptyField(startingFrom: index) {
                DispatchQueue.main.async {
                    focusedIndex = nextIndex
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
                focusedIndex = index - 1
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
        BackspaceAwareTextField(
            text: $digit,
            isFirstResponder: isFocused,
            onDeleteBackwardWhenEmpty: {
                if digit.isEmpty {
                    onBackspace()
                } else {
                    digit = ""
                }
            },
            onFocusChanged: { isFocused in
                onFocusChanged(isFocused)
            },
            configuration: { textField in
                textField.font = .systemFont(ofSize: 24, weight: .medium)
                textField.textAlignment = .center
                textField.keyboardType = .numberPad
                textField.textContentType = .oneTimeCode
                textField.autocapitalizationType = .none
                textField.autocorrectionType = .no
            },
            onTextChange: { newValue in
                onDigitChanged(newValue)
            }
        )
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
        .onChange(of: digit) { _, _ in
            updateBorderAppearance()
        }
        .onChange(of: isFocused) { oldValue, newValue in
            updateBorderAppearance()
        }
        .onChange(of: isError) { oldValue, newValue in
            updateBorderAppearance()
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

private struct BackspaceAwareTextField: UIViewRepresentable {
    @Binding var text: String
    var isFirstResponder: Bool
    let onDeleteBackwardWhenEmpty: () -> Void
    let onFocusChanged: (Bool) -> Void
    let configuration: (UITextField) -> Void
    let onTextChange: (String) -> Void

    func makeUIView(context: Context) -> BackspaceUITextField {
        context.coordinator.parent = self
        let textField = BackspaceUITextField()
        textField.delegate = context.coordinator
        textField.addTarget(
            context.coordinator,
            action: #selector(Coordinator.editingChanged(_:)),
            for: .editingChanged
        )
        configuration(textField)
        textField.onDeleteBackward = { [weak textField] in
            guard let textField else { return }
            if (textField.text ?? "").isEmpty {
                onDeleteBackwardWhenEmpty()
            }
        }
        return textField
    }

    func updateUIView(_ uiView: BackspaceUITextField, context: Context) {
        context.coordinator.parent = self
        if uiView.text != text {
            uiView.text = text
        }

        uiView.onDeleteBackward = { [weak uiView] in
            guard let uiView else { return }
            if (uiView.text ?? "").isEmpty {
                onDeleteBackwardWhenEmpty()
            }
        }

        if isFirstResponder && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else if !isFirstResponder && uiView.isFirstResponder {
            uiView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    final class Coordinator: NSObject, UITextFieldDelegate {
        var parent: BackspaceAwareTextField

        init(parent: BackspaceAwareTextField) {
            self.parent = parent
        }

        @objc func editingChanged(_ sender: UITextField) {
            let updatedText = sender.text ?? ""
            parent.text = updatedText
            parent.onTextChange(updatedText)
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.onFocusChanged(true)
        }

        func textFieldDidEndEditing(_ textField: UITextField) {
            parent.onFocusChanged(false)
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            if string.isEmpty {
                return true
            }

            guard string.allSatisfy({ $0.isNumber }) else {
                return false
            }

            let currentText = textField.text ?? ""
            let nsCurrent = currentText as NSString
            let updated = nsCurrent.replacingCharacters(in: range, with: string)
            return updated.count <= 1
        }
    }
}

private final class BackspaceUITextField: UITextField {
    var onDeleteBackward: (() -> Void)?

    override func deleteBackward() {
        let wasEmpty = (text ?? "").isEmpty
        super.deleteBackward()
        if wasEmpty {
            onDeleteBackward?()
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
