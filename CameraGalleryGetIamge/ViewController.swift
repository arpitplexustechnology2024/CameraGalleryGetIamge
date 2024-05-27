//
//  ViewController.swift
//  CameraGalleryGetIamge
//
//  Created by Arpit iOS Dev. on 27/05/24.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageVIew: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imgPicke = info[.editedImage] ?? info[.originalImage] {
            if let img = imgPicke as? UIImage {
                self.imageVIew.image = img
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func btnCameraTapped(_ sender: UIButton) {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                switch cameraAuthorizationStatus {
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            self.showImagePicker(for: .camera)
                        } else {
                            self.showPermissionAlert(for: "camera")
                        }
                    }
                case .authorized:
                    showImagePicker(for: .camera)
                case .restricted, .denied:
                    showPermissionAlert(for: "camera")
                @unknown default:
                    fatalError("Unknown authorization status")
                }
    }
    
    
    @IBAction func btnGalleryTapped(_ sender: UIButton) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
               switch photoAuthorizationStatus {
               case .notDetermined:
                   PHPhotoLibrary.requestAuthorization { status in
                       if status == .authorized {
                           self.showImagePicker(for: .photoLibrary)
                       } else {
                           self.showPermissionAlert(for: "photo library")
                       }
                   }
               case .authorized:
                   showImagePicker(for: .photoLibrary)
               case .restricted, .denied:
                   showPermissionAlert(for: "photo library")
               case .limited:
                   showImagePicker(for: .photoLibrary)
               @unknown default:
                   fatalError("Unknown authorization status")
               }
    }
    
    func showImagePicker(for sourceType: UIImagePickerController.SourceType) {
           if UIImagePickerController.isSourceTypeAvailable(sourceType) {
               let imagePicker = UIImagePickerController()
               imagePicker.delegate = self
               imagePicker.sourceType = sourceType
               imagePicker.allowsEditing = true
               DispatchQueue.main.async {
                   self.present(imagePicker, animated: true, completion: nil)
               }
           } else {
               print("\(sourceType) is not available")
           }
       }
    
    func showPermissionAlert(for feature: String) {
           let alert = UIAlertController(title: "Permission Required",
                                         message: "Please grant permission to access your \(feature).",
                                         preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
               if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                   UIApplication.shared.open(appSettings)
               }
           })
           alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
           DispatchQueue.main.async {
               self.present(alert, animated: true, completion: nil)
           }
       }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
          dismiss(animated: true, completion: nil)
      }

}

