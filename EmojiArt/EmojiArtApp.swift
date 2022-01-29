//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by shehan karunarathna on 2022-01-29.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    var body: some Scene {
        let documet = EmojiArtDoc()
        WindowGroup {
            EmojiDocumentView(document: documet)
        }
    }
}
