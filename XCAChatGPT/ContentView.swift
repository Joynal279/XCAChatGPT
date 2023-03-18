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
                    let text = try await api.sendMessage("Tell me about Appnap Technologies Limited?")
                    print(text)
                        
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
