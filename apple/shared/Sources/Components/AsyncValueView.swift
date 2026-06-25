//
//  AsyncValueView.swift
//  Demo
//
//  Created by ivansaul on 6/24/26.
//

import DemoCore
import SwiftUI

public struct AsyncValueView<T, Content: View, Loading: View, Error: View>: View {
    let state: AsyncValue<T>
    let content: (T) -> Content
    let loading: () -> Loading
    let error: (Swift.Error) -> Error

    // Este es el constructor público necesario
    public init(
        state: AsyncValue<T>,
        @ViewBuilder content: @escaping (T) -> Content,
        @ViewBuilder loading: @escaping () -> Loading,
        @ViewBuilder error: @escaping (Swift.Error) -> Error
    ) {
        self.state = state
        self.content = content
        self.loading = loading
        self.error = error
    }

    public var body: some View {
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

public enum AsyncValue<T> {
    case idle
    case loading
    case data(T)
    case error(Error)
}
