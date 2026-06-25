//
//  ViewModels.swift
//  DemoShared
//
//  Created by ivansaul on 6/25/26.
//

import DemoCore
import Foundation

@MainActor
@Observable
public final class QuotesViewModel {
    @ObservationIgnored
    private let dataService: QuotesClient = .init()
    public private(set) var state: AsyncValue<Quote> = .idle

    public init() {}

    public func getRandom() async {
        state = .loading
        do {
            let randomQuote = try await dataService.randomQuote()
            state = .data(randomQuote)
            print(randomQuote)
        } catch {
            print(error)
            state = .error(error)
        }
    }
}
