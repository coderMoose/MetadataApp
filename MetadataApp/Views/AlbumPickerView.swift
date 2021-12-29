//
//  AlbumPickerView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import SwiftUI

// This view is the root view. It allows you to open AlbumContentsView, which shows all photos.
struct AlbumPickerView: View {

    @Binding var currentScreen: Screen
    @EnvironmentObject var photosModel: PhotosModel

    var body: some View {
        VStack {
        Button {
            withAnimation {
                currentScreen = .albumContents
            }
        } label: {
            VStack {
                album
                Text("All photos")
                    .font(.title)
                    .foregroundColor(.white)
            }
        }
        .padding()
        Spacer()
        }
    }
    
    private var album: some View {
        ZStack {
            // Getting the cover image
            if let firstImage = photosModel.photos.first {
                Image(uiImage: firstImage.image)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .scaledToFit()
            } else {
                Image(systemName: "questionmark")
            }
        }
    }
}

struct AlbumPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPickerView(currentScreen: .constant(.albumPicker))
    }
}
