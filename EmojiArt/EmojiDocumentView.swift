//
//  ContentView.swift
//  EmojiArt
//
//  Created by shehan karunarathna on 2022-01-29.
//

import SwiftUI

struct EmojiDocumentView: View {
    @ObservedObject var document : EmojiArtDoc
    let defaultfontSize :CGFloat = 40
    private let testEmojies = "😀🥳🐱🐷🍎🍔⚽️🥋🥎🚗🚌📷📀"
    var body: some View {
        VStack{
            documetBody
            palate
        }
    }
    
    var documetBody: some View{
        GeometryReader{
            geometry in
            ZStack{
                Color.yellow
                ForEach(document.emojies) {
                    emoji in
                    Text(emoji.text)
                        .font(.system(size: getfontSize(emoji: emoji)))
                        .position(getPosition(emoji: emoji,geometry: geometry))
                }
            }
            .onDrop(of: [.plainText], isTargeted: nil){
                providers, location in
                return drop(providers: providers, location: location, geometry: geometry)
            }
        }
       
       
    }
    
    func drop(providers: [NSItemProvider], location:CGPoint, geometry: GeometryProxy) -> Bool {
        return providers.loadObjects(ofType: String.self) {
            string in
            if let emoji = string.first, emoji.isEmoji {
                document.addEmoji(emoji: String(emoji), location: convertoemojicordinates(location, geometry: geometry), size: defaultfontSize)
            }
        }
    }
    
    func convertoemojicordinates(_ location: CGPoint, geometry: GeometryProxy) -> (x:Int, y: Int){
        let center = geometry.frame(in: .local).center
        let location = CGPoint( x: location.x - center.x,
                                y: location.y - center.y)
        return (Int(location.x), Int(location.y))
    }
    
    func getPosition(emoji: EmojiArtModel.Emoji, geometry: GeometryProxy) -> CGPoint {
        return convertPosition(location: (x: emoji.x, y: emoji.y), geometry: geometry)
    }
    
    func convertPosition (location:(x:Int, y:Int), geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(location.x), y: center.y + CGFloat(location.y))
        
    }
    
    func getfontSize(emoji: EmojiArtModel.Emoji) -> CGFloat {
        return CGFloat(emoji.size)
    }
  
    var palate: some View{
        ScrolingEmojiView(emojis: testEmojies)
            .font(.system(size: defaultfontSize))
    }
}

struct ScrolingEmojiView:View{
    let emojis: String
    var body: some View{
        ScrollView(.horizontal){
            HStack{
                ForEach(emojis.map{String($0)}, id: \.self){
                    emoji in
                    Text(emoji)
                        .onDrag {
                            NSItemProvider(object: emoji as NSString)
                            
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let documet = EmojiArtDoc()
        EmojiDocumentView(document: documet)
    }
}
