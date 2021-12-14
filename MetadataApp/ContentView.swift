//
//  ContentView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-13.
//

import SwiftUI
import Photos

struct ContentView: View {
    @StateObject var photosModel = PhotosModel()
    
    var body: some View {
        Text("Hello world")
            .onAppear {
                photosModel.load()
            }
        ForEach(photosModel.photos, id: \.self) { img in
            Image(uiImage: img)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
