# Metadata App
#### Video: 
#### Description: This app lets users edit the metadata of their photos.


# Files In My App
## DispatchView
- The dispatch view handles the navigation through the app by stacking them. Whenever a view is selected, the dispatch view shows that selected view by stacking it on top.

## AlbumPickerView
- The album picker view is the root view that leads to AlbumContentsView, the main view.


## AlbumContentsView
** The album contents view takes care of multiple things:**
- displays all of the photos in the user's photo library
- switches to the camera view when the camera icon is clicked
- switches to the detail view when the user selects a photo
- compatible with landscape and portrait mode

## PhotoDetailView
- This view shows the metadata info of a selected photo and lets the user edit it.

## MapView
- This view shows the location of a selected photo on a map.
- Uses MapKit to display a map

## CameraView
- This view lets the user take photos.
- It uses UIViewControllerRepresentable to show a UIViewController with SwiftUI.

## PhotoItem
- This class is used by the photos we get from the user's photo library. It contains the metadata (location and date), asset, and actual image of the photo.

## PhotosModel
- PhotosModel contains all of the methods necessary to get and edit photos from the user's photo library (e.g. loading the photos, saving the metadata of the photos...)

## Constants
- This file contains constants used all around the app to make these constants easier to use and change.

# Features
- Lets users see a photo's metadata
- Lets users edit a photo's metadata
- Able to multiselect photos
- ScrollView that lets the user scroll through their photo library
- Works on iPhone and iPad and automatically adjusts layout based on size

# Things I learned
- SwiftUI
- Git
- Xcode
- How to modify photos in ios' photo library

# Credits
- This article from RayWenderlich really helped me:
https://www.raywenderlich.com/11764166-getting-started-with-photokit

- This article from Jeeva Tamilselvan really helped me:
https://medium.com/swlh/how-to-open-the-camera-and-photo-library-in-swiftui-9693f9d4586b

Create a README.md text file in your ~/project folder that explains your project. This file should include your Project Title, the URL of your video (created in step 1 above) and a description of your project. You may use the below as a template.

Your README.md file should be minimally multiple paragraphs in length, and should explain what your project is, what each of the files you wrote for the project contains and does, and if you debated certain design choices, explaining why you made them. Ensure you allocate sufficient time and energy to writing a README.md that you are proud of and that documents your project thoroughly. Be proud of it!
