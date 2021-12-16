//
//  PhotoDetailView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import SwiftUI
import Photos

struct PhotoDetailView: View {

    var photoItems: [PhotoItem]
    var namespace: Namespace.ID
    @Binding var currentScreen: Screen
    @EnvironmentObject var photosModel: PhotosModel
    var onExit: () -> Void
    @State private var nextFavoriteValue = false
    @State private var newCreationDate = Date()
    
    var body: some View {
        VStack {
            backButton
            Spacer()
            ZStack {
                ForEach(0..<photoItems.count, id: \.self) { i in
                    Image(uiImage: photoItems[i].image)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(1.0, contentMode: .fit)
                        .matchedGeometryEffect(id: photoItems[i].id, in: namespace)
                        .offset(x: -CGFloat(2 * i), y: i % 2 == 0 ? -2 : 2)
                        .shadow(color: .black, radius: 3, x: 1, y: 1)
                        .frame(maxWidth: 250)
                        .rotationEffect(photoItems.count > 1 ? Angle.degrees(i % 2 == 0 ? -5 : 5) : Angle.degrees(0))
                }
            }
            Spacer()
            Button {
                nextFavoriteValue.toggle()
                for item in photoItems {
                    item.isFavorite = nextFavoriteValue
                }
            } label: {
                Image(systemName: nextFavoriteValue ? "heart.fill" : "heart")
            }
            mapButton
            Spacer()
            DatePicker("Creation Date:", selection: $newCreationDate)
                .datePickerStyle(CompactDatePickerStyle())
                .padding()
            saveButton
        }
        .padding()
        .onAppear {
            newCreationDate = photoItems.first!.creationDate
        }
    }
    
    private var saveButton: some View {
        Button {
            for item in photoItems {
                item.creationDate = newCreationDate
            }
            PhotosModel.saveMetadata(photoItems: photoItems)
        } label: {
            Text("Save")
        }
    }
    
    private var backButton: some View {
        HStack {
            Button {
                withAnimation {
                    onExit()
                    currentScreen = .albumContents
                    photosModel.resetAllToUnselected()
                }
            } label: {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
            }
            Spacer()
        }
    }

    @ViewBuilder
    private var mapButton: some View {
        if photoItems.count == 1 {
            Button {
                withAnimation {
                    let firstItem = photoItems.first!
                    firstItem.startGeocoding()
                    currentScreen = .map(firstItem, onExit)
                }
            } label: {
                Image(systemName: "map.circle")
            }
        }
    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    
    static var photoItem: PhotoItem {
        PhotoItem(id: UUID(),
                  asset: .init(),
                  thumbnail: UIImage(systemName: "heart")!,
                  image: UIImage(systemName: "heart")!,
                  creationDate: Date(),
                  isFavorite: true,
                  location: CLLocation())
    }
    
    static var previews: some View {
        PhotoDetailView(photoItems: [photoItem],
                        namespace: Namespace().wrappedValue,
                        currentScreen: .constant(.detailView([photoItem], { })), onExit: { })
    }
}
