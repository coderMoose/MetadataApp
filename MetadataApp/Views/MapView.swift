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
    var onExit: () -> Void

    var body: some View {
        VStack {
            HStack {
                Button {
                    // If the back button is pressed, then switch to the DetailView, which contains the metadata of the selected photo
                    withAnimation {
                        currentScreen = .detailView([photoItem], onExit)
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .imageScale(.large)
                }
                Spacer()
            }
            Text(photoItem.locationName)
                .foregroundColor(.white)
            // Get the location of the selected photo
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

struct MapView_Previews: PreviewProvider {
    
    static var photoItem: PhotoItem {
        .init(id: .init(), asset: .init(), thumbnail: .init(), image: .init(), creationDate: Date(), isFavorite: true, location: nil)
    }
    
    static var previews: some View {
        MapView(photoItem: photoItem, currentScreen: .constant(.map(photoItem, { })), onExit: { })
    }
}
