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
    var namespace: Namespace.ID
    @Binding var currentScreen: Screen
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        currentScreen = .main
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .imageScale(.large)
                }
                Spacer()
            }
            Spacer()
            Image(uiImage: photoItem.thumbnail)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .matchedGeometryEffect(id: photoItem.id, in: namespace)
            Spacer()
                Button {
                    photoItem.isFavorite.toggle()
                } label: {
                    Image(systemName: photoItem.isFavorite ? "heart.fill" : "heart")
                }
            Spacer()
            DatePicker("Creation Date:", selection: $photoItem.creationDate)
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding()
            Button {
                PhotosModel.saveMetadata(photoItem: photoItem)
            } label: {
                Text("Save")
            }
        }
        .padding()
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(photoItem: PhotoItem(id: UUID(),
                                             asset: .init(),
                                             thumbnail: UIImage(systemName: "heart")!,
                                             image: UIImage(systemName: "heart")!,
                                             creationDate: Date(), isFavorite: true),
                        namespace: Namespace().wrappedValue, currentScreen: .constant(.main))
    }
}
