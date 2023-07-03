# Metadata App
#### Video: 
#### Description: This app lets users edit the metadata of their photos. 

For example, let's say a user has a box of old photos sitting in their attic. They start sorting them, and use their camera to take a picture to store it digitally on their phone. This is great in that they now have an online backup of it, but iOS will store the photo's "date" as today. But imagine this is a memory from Christmas 2004. Now when scrolling through photos, their photos will be out of order.

Also, the "location" of the photo will now be where they were at this very moment, not in perhaps Brazil where they were on vacation.

This app gives users more control over their photos, and allows them to sort and organize them however they like. They can also mark whether or not photos are "favorites" or not.

# Files In My App
This app is built using the Swift programming language in Xcode. The UI framework it uses is called "SwiftUI". SwiftUI works on the concept of "views", which basically corresponds to either a whole screen, or a piece of a screen.

Here are the main views in the app.

## MetadataAppApp
- This is the root of the app, since it is marked with "@main", which is SwiftUI's equivalent to a main method in C. The code in this struct will run first when the app is launched.
- When "onAppear" runs, we call PhotosModel.load to load in all the photos from the user's library.
- I also attach the PhotosModel to the view as an "environment object", which means views attached later on can access it (without having to manually pass it down each level as a parameter).

## DispatchView
- The dispatch view handles the navigation through the app by stacking the various views (i.e. screens). 
- Whenever a view is selected, the dispatch view shows that selected view by stacking it on top.

How does this work? The key is this line:
    @State private var currentScreen: Screen
    
'Screen' is an enum I've defined that has one case per screen in the app. When I modify 'currentScreen', SwiftUI will automatically redraw in any part of the screen that depends on the "state" of this variable. 

So when I change it from .detailView to .mapView, the if statement on line 49 of that file evaluates to true, which cause the MapView to be displayed. Swift enums can also have associated values, which is how I'm passing data from one screen to another. 

## AlbumPickerView
- The album picker view is the main view that leads to AlbumContentsView, which is where the user will likely spend most of their time. 
- It contains a button that shows the first (i.e. most recent) image of the user's photo library as a cover image. It gets this image from the PhotosModel class.

## AlbumContentsView
** The album contents view takes care of multiple things:**
- displays all of the photos in the user's photo library
- switches to the camera view when the camera icon is clicked
- switches to the detail view when the user selects a photo
- is compatible with landscape and portrait mode

The key functionality on this screen comes from LazyVGrid and the ForEach inside of it. It loops through all of the photos in the PhotosModel, and draws a view on the screen for each one.

When the user taps on one of these images, I need to be able to change "currentScreen" from DispatchView, so it's passed in to SelectableImageView as a "binding", which seems like SwiftUI's equivalent of a pointer in C.

When the user taps the camera button, I'm showing it as a SwiftUI "sheet" which makes it animate up from the bottom and mostly (but not completely) cover the screen. When the sheet is dismissed, I call photosModel.addImageToPhotoLibrary which will write it to disk.

## PhotoDetailView
- This view shows the metadata info of a selected photo and lets the user edit it. 
- It has a button that leads to the MapView, where you can see the location of the selected photo. 
- It has a date picker to edit the photo's date.
- It has a button that allows you to favorite that selected photo.
- And finally, it has a save button that saves that selected photo's new metadata

The animation/transition from AlbumContentsView to this screen is handled by SwiftUI's "matchedGeometryEffect" method. It's applied to the image on both screens, and so when the screen changes, SwiftUI will automatically animate it.

## MapView
- This view shows the location of a selected photo on a map.
- Uses MapKit to display a map
- Makes an annotation item with the coordinates of the selected photo to show a pin on the map 

## CameraView
- This view lets the user take photos.
- It uses UIViewControllerRepresentable to show a UIViewController with SwiftUI.
- After a picture has been taken, it's moved into the AlbumContentsView with an animation. 

## PhotoItem
- This class is used by the photos we get from the user's photo library. 
- It contains the metadata (location and date), asset, and actual image of the photo.

## PhotosModel
** PhotosModel contains all of the methods necessary to get and edit photos from the user's photo library. Here are some and what they do: **
- selectedPhotos is an array of all the selected photos 
- load is a function that loads all of the photos from the user's photo library by calling fetchAssets
- fetchAssets is a function that gets the assets from the user's photo library by looping through them and making them conform to the PhotoItem struct.
- fetchAllPhotos is a function that appends all of the user's photos to an array called allPhotos.
- getAssetThumbnail allocates a photo with a width of 150 and a height of 150.
- getAssetImage does the same but requests a photo with a width of 400 and a height of 400 instead.
- getPermissionIfNecessary checks if the user allowed access to his or her photo library.
- saveMetadata sends a PHAssetChangeRequest for all the the user's photos and proceeds to set the location and date of the selected photo to the edited metadata.


## Constants
- This file contains constants used all around the app to make these constants easier to use and change.
- Currently, it only has one constant; the black background color used by all of the views. 

# Features
- See and edit a photo's metadata
- Able to multiselect photos and edit the metadata for all of them at once
- ScrollView that lets the user scroll through their photo library
- Works on iPhone and iPad and automatically adjusts layout based on size
- Take pictures in real life
- Shows a map with a pin so a user can see where a photo was taken
- Cool animation when they select a photo and move to a new screen, and when they come back

# Design Decisions
The app loads all photos from the photo library immediately after it is launched. This allows the app to run fast once the photos have finished loading (for example, while the user is scrolling their photos). But, it makes the app take longer to launch. The user sees a delay of a few seconds.

I thought about having this happen after the app is launched, but decided the user shouldn't have to click an extra button to load. In the future, I'd like to extend this app to only load the photos it needs one screen at a time - that should make the launch much faster.

The other major design decision I had to think through was how to pass data between all the various screens. I ended up creating a first view called "Dispatch" view that is kind of like a ViewController from the old way of building iOS apps in UIKit (before SwiftUI came out). It uses an enum and Swift's feature called associated values to control what the current screen is. One thing that was a bit tricky on this screen was I had to use a ZStack to ensure that the first two screens are still shown on the screen even if they're underneath. This is because SwiftUI's "matchedGeometryEffect" animation needs the previous view to still be on the screen when navigating backwards.

# Things I learned
- SwiftUI
- Git
- Xcode
- How to modify photos in iOS' photo library

# Credits
- This article from RayWenderlich really helped me:
https://www.raywenderlich.com/11764166-getting-started-with-photokit

- This article from Jeeva Tamilselvan really helped me:
https://medium.com/swlh/how-to-open-the-camera-and-photo-library-in-swiftui-9693f9d4586b
