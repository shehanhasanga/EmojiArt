//
//  EmojiArtDoc.swift
//  EmojiArt
//
//  Created by shehan karunarathna on 2022-01-29.
//

import SwiftUI

class EmojiArtDoc:ObservableObject{
    @Published private(set) var emojiArt : EmojiArtModel
    init(){
        emojiArt = EmojiArtModel()
        emojiArt.addEmoji(text: "😀", location: (x: -200, y: -100), size: 80)
        emojiArt.addEmoji(text: "😄", location: (x: -200, y: -10), size: 40)
    }
    
    var emojies: [EmojiArtModel.Emoji] {emojiArt.emojis}
    var background: EmojiArtModel.Background {emojiArt.background}
    
    func addEmoji(emoji:String, location: (x:Int, y:Int), size:CGFloat){
        emojiArt.addEmoji(text: emoji, location: (location.x, location.y), size: Int(size))
    }
    
    func moveEmoji(emoji: EmojiArtModel.Emoji, offset: CGSize){
        if let index = emojiArt.emojis.index(matching: emoji){
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(emoji:EmojiArtModel.Emoji, scale:CGFloat){
        if let index = emojiArt.emojis.index(matching: emoji){
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
}
