//
//  ContentView.swift
//  XCAChatGPT
//
//  Created by Joynal Abedin on 18/3/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            Task {
                let api = ChatGPTAPI(apiKey: "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")
                do {
//                    let stream = try await api.sendMessageStream(text: "What is James Bond?")
//                    for try await line in stream {
//                        print(line)
//                    }
                    let text = try await api.sendMessage("Tell me about c program?")
                    print(text)
                    let text1 = try await api.sendMessage("write c program how can i sum two number?")
                    print(text1)
                        
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
