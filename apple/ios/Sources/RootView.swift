import DemoCore
import DemoShared
import SwiftUI

struct ContentView: View {
    @State private var vm: QuotesViewModel = .init()

    var body: some View {
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
