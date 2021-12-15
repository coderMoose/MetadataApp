//
//  AlbumContentsView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-13.
//

import Photos
import SwiftUI

struct AlbumContentsView: View {

    @EnvironmentObject var photosModel: PhotosModel
    @Binding var currentScreen: Screen
    var namespace: Namespace.ID
    
    private var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: 80, maximum: 180)),
            GridItem(.adaptive(minimum: 80, maximum: 180)),
            GridItem(.adaptive(minimum: 80, maximum: 180))
        ]
    }
    
    var body: some View {
        ScrollView {
            grid
        }
    }

    private var grid: some View {
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

struct AlbumContentsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumContentsView(currentScreen: .constant(.albumContents), namespace: Namespace().wrappedValue)
            .environmentObject(PhotosModel())
    }
}
