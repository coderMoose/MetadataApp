//
//  PhotoItem.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import Foundation
import Photos
import UIKit

class PhotoItem: Identifiable, ObservableObject {
    @Published var id: UUID
    @Published var asset: PHAsset
    @Published var thumbnail: UIImage
    @Published var image: UIImage
    @Published var creationDate: Date
    @Published var isFavorite: Bool
    
    init(id: UUID, asset: PHAsset, thumbnail: UIImage, image: UIImage, creationDate: Date, isFavorite: Bool) {
        self.id = id
        self.asset = asset
        self.thumbnail = thumbnail
        self.image = image
        self.creationDate = creationDate
        self.isFavorite = isFavorite
    }
}
