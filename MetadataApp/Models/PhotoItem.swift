//
//  PhotoItem.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import Foundation
import MapKit
import Photos
import UIKit

// This class is used by all the photos in the user's photo library
class PhotoItem: Identifiable, ObservableObject {
    struct MyAnnotationItem: Identifiable {
        var coordinate: CLLocationCoordinate2D
        let id = UUID()
    }

    @Published var id: UUID
    @Published var asset: PHAsset
    @Published var thumbnail: UIImage
    @Published var image: UIImage
    @Published var creationDate: Date
    @Published var isFavorite: Bool
    @Published var hasLocation: Bool
    @Published var location: CLLocation
    @Published var coordinateRegion: MKCoordinateRegion
    @Published var annotationItems: [MyAnnotationItem]
    @Published var locationName = "No location"
    @Published var isSelected = false
    
    init(id: UUID, asset: PHAsset, thumbnail: UIImage, image: UIImage, creationDate: Date, isFavorite: Bool, location: CLLocation?) {
        self.id = id
        self.asset = asset
        self.thumbnail = thumbnail
        self.image = image
        self.creationDate = creationDate
        self.isFavorite = isFavorite
        self.hasLocation = location != nil

        let location = location ?? CLLocation()
        self.location = location
        self.coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 50, longitudeDelta: 50))
        self.annotationItems = [MyAnnotationItem(coordinate: location.coordinate)]
        startGeocoding()
    }
    
    // This helper function finds the location of the selected photo
    func startGeocoding() {
        guard locationName == "No location" else {
            return
        }
        guard hasLocation else {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                return
            }
            DispatchQueue.main.async { [self] in
                locationName = placemark.country ?? "No location"
            }
        }
    }
}
