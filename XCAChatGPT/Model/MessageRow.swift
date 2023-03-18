//
//  MessageRow.swift
//  XCAChatGPT
//
//  Created by Joynal Abedin on 18/3/23.
//

import SwiftUI

struct MessageRow: Identifiable {
    
    let id = UUID()
    var isInteractWithChatGPT: Bool
    
    let sendImage: String
    let sendText: String
    
    let responseImage: String
    var responseText: String
    
    var responseError: String?
}
