//
//  CameraViewController.swift
//  Firebase Crash Course
//
//  Created by mac on 6/9/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit
import FirebaseStorage

class ImagePickerViewController: UIViewController {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var uploadImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        uploadImageButton.isEnabled = false
        
        //        print("???")
        //        if let data = try? Data(contentsOf: URL(string: "gs://directed-symbol-223205.appspot.com/images/Down.png")!) {
        //            if let image = UIImage(data: data) {
        //                myImageView.image = image
        //            } else {
        //                print("no image")
        //            }
        //        } else {
        //            print("no data")
        //        }
        // Do any additional setup after loading the view.
    }
}

extension ImagePickerViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        
        myImageView.image = image
        
        
        print(image.size)
    }
    
    @IBAction func imagePickerButtonClicked(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func uploadImageButtonClicked(_ sender: Any) {
        let imageStorageRef = Storage.storage().reference().child("images").child("uploaded-image")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        guard let imageData = myImageView.image?.pngData() else { return }
        let uploadTask = imageStorageRef.putData(imageData, metadata: metadata)
        uploadTask.observe(.success) { (snapshot) in
            imageStorageRef.downloadURL { (url, error) in
                if let error = error {
                    print("GET DOWNLOAD URL ERROR: \(error)")
                } else {
                    print(url!)
                }
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) /
                Double(snapshot.progress!.totalUnitCount)
            print("Uploading... \(percentComplete)% complete")
        }
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print(error.localizedDescription)
            }
        }
    }
}
