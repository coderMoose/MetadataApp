//
//  AlbumPickerView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-14.
//

import SwiftUI

struct AlbumPickerView: View {

    @Binding var currentScreen: Screen

    var body: some View {
        VStack {
            Button {
                withAnimation {
                    currentScreen = .albumContents
                }
            } label: {
                Text("Smart Albums")
            }
            Button {
                withAnimation {
                    currentScreen = .albumContents
                }
            } label: {
                Text("All Photos")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AlbumPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumPickerView(currentScreen: .constant(.albumPicker))
    }
}
