//
//  DispatchView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import SwiftUI

// Enum of all the different screens we'll need to switch to
enum Screen {
    case dispatchView
    case albumPicker
    case albumContents
    
    // Use enum with associated values to pass values to the views
    case detailView([PhotoItem], () -> Void)
    case map(PhotoItem, () -> Void)
    
    var isAlbumPicker: Bool {
        if case .albumPicker = self {
            return true
        }
        return false
    }
}

// This view handles all of the other views by stacking them on each other.
struct DispatchView: View {
    @State private var currentScreen: Screen = .albumContents
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
            if case let .detailView(photoItems, onExit) = currentScreen {
                PhotoDetailView(photoItems: photoItems, namespace: namespace, currentScreen: $currentScreen, onExit: onExit)
                    .background(Constants.App.backgroundColor)
            }

            if case let .map(photoItem, onExit) = currentScreen {
                MapView(photoItem: photoItem, currentScreen: $currentScreen, onExit: onExit)
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
