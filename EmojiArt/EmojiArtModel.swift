//
//  EmojiArtModel.swift
//  EmojiArt
//
//  Created by shehan karunarathna on 2022-01-29.
//

import Foundation
struct EmojiArtModel {
    var background =  Background.blank
    var emojis = [Emoji]()
    private var emojiId = 0
    
    struct Emoji:Identifiable , Hashable{
        let text : String
        var x :Int
        var y : Int
        var size : Int
        var id: Int
        
        fileprivate init (text : String, x :Int, y : Int, size : Int,id: Int) {
            self.id = id
            self.x = x
            self.y = y
            self.text = text
            self.size = size
        }
    
    }
    
    init () {}
    
   
    
    mutating func addEmoji(text:String, location:(x:Int,y:Int), size: Int) {
        emojiId += 1
        emojis.append(Emoji(text: text, x: location.x, y: location.y, size: size, id: emojiId))
    }
}
