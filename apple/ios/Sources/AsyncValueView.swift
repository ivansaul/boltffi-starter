//
//  AsyncValueView.swift
//  Demo
//
//  Created by ivansaul on 6/24/26.
//

import DemoCore
import SwiftUI

struct AsyncValueView<T, Content: View, Loading: View, Error: View>: View {
    let state: AsyncValue<T>
    @ViewBuilder let content: (T) -> Content
    @ViewBuilder let loading: () -> Loading
    @ViewBuilder let error: (Swift.Error) -> Error

    var body: some View {
        switch state {
        case .idle:
            EmptyView()
        case .loading:
            loading()
        case .data(let data):
            content(data)
        case .error(let err):
            error(err)
        }
    }
}

#Preview {
    let state: AsyncValue<String> = .error(DemoCoreError.quotesError(QuotesError.invalidResponse))

    AsyncValueView(state: state) { data in
        Text(data)
    } loading: {
        ProgressView()
    } error: { error in
        ContentUnavailableView(
            "Error",
            systemImage: "exclamationmark.triangle",
            description: Text(error.localizedDescription)
        )
    }
}

enum AsyncValue<T> {
    case idle
    case loading
    case data(T)
    case error(Error)
}
