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
                Color.yellow.overlay(OptionalImage(uiImage: document.backgroundImage)
                                        .scaleEffect(zoomScale)
                                        .position(convertPosition(location: (0,0), geometry: geometry)))
                    .gesture(doubleTapToZoom(in: geometry.size))
                if document.backgroundImageFetchStatus == .fetching {
                    ProgressView().scaleEffect(2)
                } else {
                    ForEach(document.emojies) {
                        emoji in
                        Text(emoji.text)
                            .font(.system(size: getfontSize(emoji: emoji)))
                            .scaleEffect(zoomScale)
                            .position(getPosition(emoji: emoji,geometry: geometry))
                    }
                }
               
            }
            .clipped()
            .onDrop(of: [.plainText,.url,.image], isTargeted: nil){
                providers, location in
                return drop(providers: providers, location: location, geometry: geometry)
            }
            .gesture(zoomGesture())
        }
       
       
    }
    
    func drop(providers: [NSItemProvider], location:CGPoint, geometry: GeometryProxy) -> Bool {
        
        var found = providers.loadObjects(ofType: URL.self) {
            url in
            document.setBackground(EmojiArtModel.Background.url(url.imageURL))
            
        }
        
        found = providers.loadObjects(ofType: UIImage.self) {
            image in
            if let data = image.jpegData(compressionQuality: 1.0) {
                document.setBackground(.imageData(data))
            }
            
        }
        
        found =  providers.loadObjects(ofType: String.self) {
            string in
            if let emoji = string.first, emoji.isEmoji {
                document.addEmoji(emoji: String(emoji), location: convertoemojicordinates(location, geometry: geometry), size: defaultfontSize)
            }
        }
        
        return found
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
    
    
    
    // MARK: - Zooming
    
    @State private var steadyStateZoomScale: CGFloat = 1
    @GestureState private var gestureZoomScale: CGFloat = 1
    
    private var zoomScale: CGFloat {
        steadyStateZoomScale * gestureZoomScale
    }
    
    private func zoomGesture() -> some Gesture {
        MagnificationGesture()
            .updating($gestureZoomScale) { latestGestureScale, gestureZoomScale, _ in
                gestureZoomScale = latestGestureScale
            }
            .onEnded { gestureScaleAtEnd in
                steadyStateZoomScale *= gestureScaleAtEnd
            }
    }
    
    private func doubleTapToZoom(in size: CGSize) -> some Gesture {
        TapGesture(count: 2)
            .onEnded {
                withAnimation {
                    zoomToFit(document.backgroundImage, in: size)
                }
            }
    }
    
    private func zoomToFit(_ image: UIImage?, in size: CGSize) {
        if let image = image, image.size.width > 0, image.size.height > 0, size.width > 0, size.height > 0  {
            let hZoom = size.width / image.size.width
            let vZoom = size.height / image.size.height
//            steadyStatePanOffset = .zero
            steadyStateZoomScale = min(hZoom, vZoom)
        }
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
