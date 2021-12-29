//
//  CameraView.swift
//  MetadataApp
//
//  Created by Daniel on 2021-12-16.
//

import UIKit
import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var picker: CameraView
        
        init(picker: CameraView) {
            self.picker = picker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.picker.cameraImage = selectedImage
            self.picker.isPresented.wrappedValue.dismiss()
        }
    }
    
    @Binding var cameraImage: UIImage?
    @Environment(\.presentationMode) var isPresented
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        Coordinator(picker: self)
    }
}


struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(cameraImage: .constant(nil))
    }
}
