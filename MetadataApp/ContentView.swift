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
        NavigationView {
            ScrollView {
                ForEach(photosModel.photos) { item in
                    NavigationLink {
                        PhotoDetailView(photoItem: item)
                    } label: {
                        Image(uiImage: item.thumbnail)
                            .resizable()
                            .frame(width: 120, height: 120)
                    }
                }
            }
        }
        .onAppear {
            photosModel.load()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
