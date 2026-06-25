import DemoCore
import SwiftUI

struct ContentView: View {
    @State private var vm: QuotesViewModel = .init()

    var body: some View {
        @Bindable var vm2 = vm
        VStack {
            AsyncValueView(state: vm.state) { quote in
                QuoteView(quote: quote)
            } loading: {
                ProgressView()
            } error: { error in
                Text(error.localizedDescription)
            }

            Button("Random") {
                Task { await vm.getRandom() }
            }
            .buttonStyle(.bordered)
        }
        .navigationTitle("BoltFFI - Rust")
        .task { await vm.getRandom() }
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}

@MainActor
@Observable
final class QuotesViewModel {
    @ObservationIgnored
    private let dataService: QuotesClient = .init()
    private(set) var state: AsyncValue<Quote> = .idle

    func getRandom() async {
        state = .loading
        do {
            let randomQuote = try await dataService.randomQuote()
            state = .data(randomQuote)
            print(randomQuote)
        } catch {
            state = .error(error)
        }
    }
}

struct QuoteView: View {
    let quote: Quote

    var body: some View {
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
