//
//  ContentView.swift
//  XCAChatGPT
//
//  Created by Joynal Abedin on 18/3/23.
//

/*
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
 */

import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var vm = ViewModel(api: ChatGPTAPI(apiKey: "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"))
    @FocusState var isTextFieldFocused: Bool
    
    var body: some View {
        chatListView
            .navigationTitle("Ask Me Anything!")
    }
    
    var chatListView: some View {
        ScrollViewReader { proxy in
            VStack(spacing: 0) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(vm.messages) { message in
                            MessageRowView(message: message) { message in
                                Task { @MainActor in
                                    await vm.retry(message: message)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        isTextFieldFocused = false
                    }
                }
                Divider()
                bottomView(image: "profile", proxy: proxy)
                Spacer()
            }
            .onChange(of: vm.messages.last?.responseText) { _ in
                scrollToBottom(proxy: proxy)
            }
        }
        .background(colorScheme == .light ? .white : Color(red: 52/255, green: 53/255, blue: 65/255, opacity: 0.5))
    }
    
    func bottomView(image: String, proxy: ScrollViewProxy) -> some View {
        HStack(alignment: .top, spacing: 8) {
            if image.hasPrefix("http"), let url = URL(string: image) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .frame(width: 30, height: 30)
                } placeholder: {
                    ProgressView()
                }
            }
            else {
                Image(image)
                    .resizable()
                    .frame(width: 30, height: 30)
            }
            
            TextField("Send Mesaage", text: $vm.inputMessage, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .focused($isTextFieldFocused)
                .disabled(vm.isInteractingWithChatGPT)
            
            if vm.isInteractingWithChatGPT {
                DotLoadingView()
                    .frame(width: 60, height: 30)
            }else{
                Button {
                    Task { @MainActor in
                        isTextFieldFocused = false
                        scrollToBottom(proxy: proxy)
                        await vm.sendTapped()
                    }
                } label: {
                    Image(systemName: "paperplane.circle.fill")
                        .rotationEffect(.degrees(45))
                        .font(.system(size: 30))
                }
                .disabled(vm.inputMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                
                
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    private func scrollToBottom(proxy: ScrollViewProxy) {
        guard let id = vm.messages.last?.id else {
            return
        }
        proxy.scrollTo(id, anchor: .bottomTrailing)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView()
        }
    }
}
