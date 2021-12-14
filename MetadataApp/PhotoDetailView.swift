//
//  PhotoDetailView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import SwiftUI
import Photos

struct PhotoDetailView: View {
    @ObservedObject var photoItem: PhotoItem
    
    var body: some View {
        VStack {
            Image(uiImage: photoItem.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding()
            DatePicker("Creation Date", selection: $photoItem.creationDate)
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding()
            Button {
                PhotosModel.saveMetadata(photoItem: photoItem)
            } label: {
                Text("Save")
            }

        }
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photoItem: PhotoItem(id: UUID(),
                                             asset: .init(),
                                             thumbnail: UIImage(systemName: "heart")!,
                                             image: UIImage(systemName: "heart")!,
                                             creationDate: Date()))
    }
}
