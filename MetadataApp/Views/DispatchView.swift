//
//  DispatchView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import SwiftUI

enum Screen {
    case dispatchView
    case albumPicker
    case albumContents
    case detailView(PhotoItem)
    case map(PhotoItem)
    
    var isAlbumPicker: Bool {
        if case .albumPicker = self {
            return true
        }
        return false
    }
}

struct DispatchView: View {
    @State private var currentScreen: Screen = .albumPicker
    @Namespace private var namespace
    
    var body: some View {
        ZStack {
            AlbumPickerView(currentScreen: $currentScreen)
                .background(Constants.App.backgroundColor)

            AlbumContentsView(currentScreen: $currentScreen, namespace: namespace)
                .background(Constants.App.backgroundColor)
                // By using a ZStack and this opacity trick, we keep AlbumContentsView on the screen and prevent
                // the list from scrolling back to the top. This also makes the matchGeometryEffect (with
                // PhotoDetailView) below look much better.
                .opacity(currentScreen.isAlbumPicker ? 0.0 : 1.0)
            if case .detailView(let photoItem) = currentScreen {
                PhotoDetailView(photoItem: photoItem, namespace: namespace, currentScreen: $currentScreen)
                    .background(Constants.App.backgroundColor)
            }

            if case .map(let photoItem) = currentScreen {
                MapView(photoItem: photoItem, currentScreen: $currentScreen)
                    .background(Constants.App.backgroundColor)
            }
        }
    }
}

struct DispatchView_Previews: PreviewProvider {
    static var previews: some View {
        DispatchView()
    }
}
