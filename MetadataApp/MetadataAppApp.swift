//
//  MetadataAppApp.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-13.
//

import SwiftUI

@main
struct MetadataAppApp: App {

    @StateObject var photosModel = PhotosModel()
    
    var body: some Scene {
        WindowGroup {
            DispatchView()
                .environmentObject(photosModel)
                .onAppear {
                    photosModel.load()
                }
                .background(Constants.App.backgroundColor)
        }
    }
}
