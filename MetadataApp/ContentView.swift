//
//  ContentView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-13.
//

import SwiftUI
import Photos

enum Screen {
    case main
    case detailView(PhotoItem)
}

struct ContentView: View {

    @EnvironmentObject var photosModel: PhotosModel
    @State private var currentScreen: Screen = .main
    @Namespace private var namespace
    
    private var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 80, maximum: 180)),
        GridItem(.adaptive(minimum: 80, maximum: 180)),
        GridItem(.adaptive(minimum: 80, maximum: 180))
    ]
    
    var body: some View {
        switch currentScreen {
        case .main:
            mainView
        case .detailView(let photoItem):
            PhotoDetailView(photoItem: photoItem, namespace: namespace, currentScreen: $currentScreen)
        }
    }

    private var mainView: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(photosModel.photos) { item in
                    Image(uiImage: item.thumbnail)
                        .resizable()
                        .aspectRatio(1.0, contentMode: .fit)
                        .matchedGeometryEffect(id: item.id, in: namespace)
                        .onTapGesture {
                            withAnimation {
                                currentScreen = .detailView(item)
                            }
                        }
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
