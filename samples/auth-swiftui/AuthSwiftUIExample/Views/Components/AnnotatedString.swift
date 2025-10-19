//
//  AnnotatedString.swift
//  AuthSwiftUIExample
//
//  Created by Ademola Fadumo on 18/10/2025.
//

import SwiftUI

struct AnnotatedString: View {
    let fullText: String
    let links: [(label: String, url: String)]
    
    init(
        fullText: String,
        links: [(String, String)],
    ) {
        self.fullText = fullText
        self.links = links
    }
    
    var body: some View {
        let text = makeAttributedText()
        Text(text)
            .multilineTextAlignment(.center)
            .tint(.accentColor) // Use theme color
            .onOpenURL { url in
                // Handle URL tap (optional custom handling)
                UIApplication.shared.open(url)
            }
    }
    
    private func makeAttributedText() -> AttributedString {
        let template = fullText
        var attributed = AttributedString(template)
        
        for (label, urlString) in links {
            guard let range = attributed.range(of: label),
                  let url = URL(string: urlString)
            else { continue }
            
            attributed[range].link = url
            attributed[range].foregroundColor = UIColor.tintColor
            attributed[range].underlineStyle = Text.LineStyle.single
        }
        
        return attributed
    }
}
