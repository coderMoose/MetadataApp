//
//  MapView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//
import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var photoItem: PhotoItem
    @Binding var currentScreen: Screen

    var body: some View {
        VStack {
            HStack {
                Button {
                    currentScreen = .detailView(photoItem)
                } label: {
                    Image(systemName: "arrow.left")
                        .imageScale(.large)
                }
                Spacer()
            }
            Text(photoItem.locationName)
            if photoItem.hasLocation {
                Map(coordinateRegion: $photoItem.coordinateRegion,
                    annotationItems: photoItem.annotationItems) { item in
                    MapPin(coordinate: item.coordinate)
                }
            }
            Spacer()
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(photoItem: PhotoItem(id: UUID(), asset: , thumbnail: e, image: T##eUIImage, creationDate: e, isFavorite: e, location: e), currentScreen: .constant(.map))
//    }
//}
