//
//  ContentView.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 07/09/2025.
//

import SwiftUI
import FirebaseAuthSwiftUI

struct ContentView: View {
    @State private var isPresented: Bool = true
    
    var body: some View {
        FirebaseAuthView(
            isPresented: $isPresented
        ) {
            NavigationStack {
                VStack {
                    Text("Body")
                }
                .navigationTitle("Firebase UI Demo")
            }
        }
    }
}

#Preview {
    ContentView()
}
