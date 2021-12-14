//
//  PhotoItem.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import Foundation
import Photos
import UIKit

struct PhotoItem: Identifiable {
    let id: UUID
    let asset: PHAsset
    let thumbnail: UIImage
    let image: UIImage
}
