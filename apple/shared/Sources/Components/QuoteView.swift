//
//  QuoteView.swift
//  DemoShared
//
//  Created by ivansaul on 6/25/26.
//

import DemoCore
import SwiftUI

public struct QuoteView: View {
    let quote: Quote

    public init(quote: Quote) {
        self.quote = quote
    }

    public var body: some View {
        VStack {
            Text(quote.content)
                .italic()
                .font(.title3)

            Text(quote.author)
                .italic()
                .bold()
                .font(.callout)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.top, 5.0)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 2)
        )
        .padding()
    }
}

#Preview {
    QuoteView(quote: Quote(
        id: "123",
        content: "Do Something. If it works, do more of it. If it doesn't, do something else.",
        author: "Franklin D. Roosevelt",
        tags: []
    ))
}
