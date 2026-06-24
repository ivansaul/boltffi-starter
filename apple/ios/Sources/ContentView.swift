import DemoCore
import SwiftUI

struct ContentView: View {
    @State private var vm: QuotesViewModel = .init()

    var body: some View {
        Text("Hello, from Rust!!")
            .padding()
            .task { await vm.getRandom() }

        Text(vm.quote.content)
            .padding()

        Button("Random") {
            print("DEBUG: random")
            Task { await vm.getRandom() }
        }
    }
}

#Preview {
    ContentView()
}

@MainActor
@Observable
final class QuotesViewModel {
    @ObservationIgnored
    private let dataService: QuotesClient = .init()

    private(set) var quote: Quote = .placeHolder()
    private(set) var errorMessage: String?

    func getRandom() async {
        print("DEBUG: ffi")
        do {
            quote = try await dataService.randomQuote()
            print(quote)
        } catch let error as DemoCoreError {
            print("DEBUG: \(error.localizedDescription)")
            errorMessage = error.localizedDescription
        } catch {}
    }
}
