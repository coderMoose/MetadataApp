//
//  PhotoDetailView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import SwiftUI
import Photos

struct PhotoDetailView: View {
    @StateObject var photosModel = PhotosModel()
    let photoItem: PhotoItem
    
    var body: some View {
        VStack {
            Image(uiImage: photoItem.image)
                .resizable()
                .frame(width: 400, height: 400)
            Text("\(photosModel.getMetadata(for: photoItem.asset))")
        }
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photoItem: PhotoItem(id: UUID(), asset: .init(), thumbnail: UIImage(systemName: "heart")!, image: UIImage(systemName: "heart")!))
    }
}
