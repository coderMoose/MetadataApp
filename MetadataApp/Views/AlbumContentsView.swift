//
//  AlbumContentsView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-13.
//

import Photos
import SwiftUI

struct AlbumContentsView: View {

    @EnvironmentObject var photosModel: PhotosModel
    @Binding var currentScreen: Screen
    @State private var selectionMode = false
    @State private var imageOpacity = 1.0

    var namespace: Namespace.ID
    
    private var columns: [GridItem] {
        [
            GridItem(.adaptive(minimum: 80, maximum: 180)),
            GridItem(.adaptive(minimum: 80, maximum: 180)),
            GridItem(.adaptive(minimum: 80, maximum: 180))
        ]
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    backButton
                    Text("All photos")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                        .offset(x: selectionMode ? geometry.size.width * -0.15 : 0)
                        .animation(.spring(), value: selectionMode)
                    topRightCornerButtons
                }
                ScrollView {
                    grid
                }
            }
        }
    }
    
    private var backButton: some View {
        HStack {
            Button {
                withAnimation {
                    currentScreen = .albumPicker
                }
            } label: {
                Image(systemName: "arrow.backward.square.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    .padding(.leading)
            }
            Spacer()
        }
    }
    
    private var topRightCornerButtons: some View {
        HStack {
            Spacer()
            Button {
                if !selectionMode {
                    // User clicked Select
                    photosModel.resetAllToUnselected()
                }
                selectionMode.toggle()
            } label: {
                Text(selectionMode ? "Cancel" : "Select")
                    .foregroundColor(.white)
            }
            if selectionMode {
                Button {
                    selectionMode = false
                    withAnimation {
                        startFadeOutAnimation()
                        currentScreen = .detailView(photosModel.selectedPhotos, startFadeInAnimation)
                    }
                } label: {
                    Text("Done")
                        .bold()
                        .foregroundColor(.white)
                }
            }
        }.padding(.trailing)
    }

    func startFadeInAnimation() {
        withAnimation(.easeIn(duration: 0.7), {
            imageOpacity = 1.0
        })
    }
    
    func startFadeOutAnimation() {
        withAnimation(.easeIn(duration: 0.7), {
            imageOpacity = 0.0
        })
    }
    
    private var grid: some View {
        LazyVGrid(columns: columns) {
            ForEach(photosModel.photos) { item in
                SelectableImageView(item: item,
                                    selectionMode: $selectionMode,
                                    currentScreen: $currentScreen,
                                    namespace: namespace,
                                    fadeOutAnimation: startFadeOutAnimation,
                                    onExit: startFadeInAnimation)
                    .opacity(item.isSelected ? 1.0 : imageOpacity)
            }
        }
        .padding()
    }
}

private struct SelectableImageView: View {
    
    @ObservedObject var item: PhotoItem
    @Binding var selectionMode: Bool
    @Binding var currentScreen: Screen
    var namespace: Namespace.ID
    var fadeOutAnimation: () -> Void
    var onExit: () -> Void

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(uiImage: item.thumbnail)
                .resizable()
                .aspectRatio(1.0, contentMode: .fit)
                .matchedGeometryEffect(id: item.id, in: namespace)
                .onTapGesture {
                    if selectionMode {
                        withAnimation {
                            item.isSelected.toggle()
                        }
                    } else { // tapped a single image
                        withAnimation {
                            item.isSelected = true
                            fadeOutAnimation()
                            currentScreen = .detailView([item], onExit)
                        }
                    }
                }
                .opacity(selectionMode ? 0.9 : 1)
            
            if selectionMode {
                ZStack {
                    Image(systemName: item.isSelected ? "checkmark.circle.fill" : "circlebadge") 
                        .animation(.none, value: item.isSelected)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

struct AlbumContentsView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumContentsView(currentScreen: .constant(.albumContents), namespace: Namespace().wrappedValue)
            .environmentObject(PhotosModel())
    }
}
