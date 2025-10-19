//
//  FirebaseAuthView.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

struct FirebaseAuthView<Content: View>: View {
    init(
        isPresented: Binding<Bool>,
        interactiveDismissDisabled: Bool = true,
        @ViewBuilder content: @escaping () -> Content = { EmptyView() }
    ) {
        self.isPresented = isPresented
        self.interactiveDismissDisabled = interactiveDismissDisabled
        self.content = content
    }
    
    private var isPresented: Binding<Bool>
    private var interactiveDismissDisabled: Bool
    private let content: () -> Content?
    
    
    var body: some View {
        content()
            .sheet(isPresented: isPresented) {
                FirebaseAuthViewInternal(
                    interactiveDismissDisabled: interactiveDismissDisabled
                )
            }
    }
}
