import DemoCore
import SwiftUI

struct ContentView: View {
    @State private var joke: String = ""

    var body: some View {
        Text("Hello, from Rust!!")
            .padding()

        Text(joke)
            .padding()

        Button("Random") {
            load_joke()
        }
    }
}

extension ContentView {
    func load_joke() {
        Task {
            let res = try? await JokeManager().randomJoke2()
            joke = res?.setup ?? "..."
        }
    }
}

#Preview {
    ContentView()
}
