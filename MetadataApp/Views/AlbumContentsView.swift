//
//  AlbumContentsView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-13.
//

import Photos
import SwiftUI

// This view shows all the photos in the user's photo library
struct AlbumContentsView: View {

    @EnvironmentObject var photosModel: PhotosModel
    @Binding var currentScreen: Screen
    @State private var isInSelectionMode = false
    @State private var imageOpacity = 1.0
    @State private var imageFromCamera: UIImage?
    @State private var isShowingCamera = false

    var namespace: Namespace.ID
    
    // Restrict the grid to three columns
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
                    
                        // This is why we need a geometry reader. It gives the "All photos" title a slide animation relative to the screen's width
                        .offset(x: isInSelectionMode ? geometry.size.width * -0.15 : 0)
                    
                        // Gives our slide a nice animation
                        .animation(.spring(), value: isInSelectionMode)
                    topRightCornerButtons
                }
                ScrollView {
                    grid
                }
                bottomCameraBar
            }
        }
        // This sheet brings up the CameraView, which is used to take a photo
        .sheet(isPresented: $isShowingCamera) {
            if let imageFromCamera = imageFromCamera {
                // Adds the picture that the user took to the user's photo library
                photosModel.addImageToPhotoLibrary(image: imageFromCamera)
            }
        } content: {
            CameraView(cameraImage: $imageFromCamera)
        }

    }
    
    private var bottomCameraBar: some View {
        // Camera button
        HStack {
            Spacer()
            Button {
                isShowingCamera = true
            } label: {
                cameraButtonImage
            }
            .disabled(isInSelectionMode)
        }
    }
    
    private var cameraButtonImage: some View {
        Image(systemName: "camera")
            .resizable()
            .scaledToFit()
            .aspectRatio(0.1, contentMode: .fit)
            .foregroundColor(.white)
            .padding(.trailing)
    }
    
    private var backButton: some View {
        // Back button that takes us to the album picker view
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
                if !isInSelectionMode {
                    // User clicked Select
                    photosModel.resetAllToUnselected()
                }
                isInSelectionMode.toggle()
            } label: {
                Text(isInSelectionMode ? "Cancel" : "Select")
                    .foregroundColor(.white)
            }
            if isInSelectionMode {
                Button {
                    // Done acts as a cancel button when the user hasn't selected any photos
                    if photosModel.selectedPhotos.isEmpty {
                        withAnimation {
                            isInSelectionMode = false
                        }
                        return
                    }
                    
                    // If the user did select a photo, switch the screen to DetailView, which lets the users edit their photos' metadata
                    isInSelectionMode = false
                    withAnimation {
                        // Fade out animation to make it look nice
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
    
    // This animation is called when the user clicks the back button in DetailView
    func startFadeInAnimation() {
        withAnimation(.easeIn(duration: 0.7), {
            imageOpacity = 1.0
        })
    }
    
    // This animation is called when the user clicks done after selecting some photos
    func startFadeOutAnimation() {
        withAnimation(.easeIn(duration: 0.7), {
            imageOpacity = 0.0
        })
    }
    
    // The user's photo library
    private var grid: some View {
        LazyVGrid(columns: columns) {
            ForEach(photosModel.photos) { item in
                SelectableImageView(item: item,
                                    selectionMode: $isInSelectionMode,
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
                    if selectionMode { // selected an image
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
