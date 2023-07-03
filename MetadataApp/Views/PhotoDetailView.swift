//
//  PhotoDetailView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import SwiftUI
import Photos

// This view is called when the user either taps an image or selects multiple images. This view shows the metadata of the image that was selected
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
            // Show the images the user selected
            ZStack {
                ForEach(0..<photoItems.count, id: \.self) { i in
                    Image(uiImage: photoItems[i].image)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(1.0, contentMode: .fit)
                        .matchedGeometryEffect(id: photoItems[i].id, in: namespace)
                        .offset(x: -CGFloat(1 * i), y: i % 2 == 0 ? -2 : 2)
                        .shadow(color: .black, radius: (i < 4) ? 5 : 0, x: 1, y: 1)
                        .frame(maxWidth: 250)
                        .rotationEffect(photoItems.count > 1 ? Angle.degrees(i % 2 == 0 ? -5 : 5) : Angle.degrees(0))
                }
            }
            Spacer()
            HStack {
                Button {
                    nextFavoriteValue.toggle()
                    for item in photoItems {
                        item.isFavorite = nextFavoriteValue
                    }
                } label: {
                    Image(systemName: nextFavoriteValue ? "heart.fill" : "heart")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding()
                }
                Spacer()
                mapButton
            }
            
            Spacer()
            DatePicker("Creation Date:", selection: $newCreationDate)
                .datePickerStyle(CompactDatePickerStyle())
                .colorMultiply(.white)
                .environment(\.colorScheme, .dark)
                .foregroundColor(.white)
                .padding()
            saveButton
            Spacer()
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
                item.isFavorite = nextFavoriteValue
            }
            PhotosModel.saveMetadata(photoItems: photoItems)
        } label: {
            Text("Save")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(15)
        }
    }
    
    private var backButton: some View {
        HStack {
            Button {
                withAnimation {
                    // If the back button is pressed, switch to AlbumContentsView, which shows the photos in the user's photo library
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
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
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
