//
//  CameraViewController.swift
//  Firebase Crash Course
//
//  Created by mac on 6/9/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ImagePickerViewController: UIViewController {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var photoLibraryButton: CustomButton!
    @IBOutlet weak var cameraButton: CustomButton!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var uploadProgressView: UIProgressView!
    @IBOutlet weak var percentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        percentLabel.isHidden = true
        percentLabel.textColor = .white
        
        myImageView.image = UIImage(systemName: "photo")
        myImageView.tintColor = .white
        
        photoLibraryButton.setImage(UIImage(systemName: "photo"), for: .normal)
        cameraButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        uploadImageButton.setImage(UIImage(systemName: "icloud.and.arrow.up"), for: .normal)
        uploadImageButton.isEnabled = false
        
        uploadProgressView.tintColor = .white
        uploadProgressView.progress = 0.0
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
        uploadImageButton.isEnabled = true
        
        print(image.size)
    }
    
    @IBAction func photoLibraryButtonClicked(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func cameraButtonClicked(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @IBAction func uploadImageButtonClicked(_ sender: Any) {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let displayName = currentUser.displayName else { return }
        
        // Get
        Database.database().reference().child("users").child(currentUser.uid).child("uploaded").observeSingleEvent(of: .value) { (snapshot) in
            guard let name = snapshot.value as? String else {return}
            print(name)
        }
        
        let imageStorageRef = Storage.storage().reference().child("images").child(currentUser.uid).child("uploaded-image")
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
                    let ref = Database.database().reference().child("posts").childByAutoId()
                    ref.setValue(["userId": Auth.auth().currentUser?.uid, "url": "\(url!)", "description": "We will put something here"])
                }
            }
        }
        uploadTask.observe(.progress) { (snapshot) in
            let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount) /
                Double(snapshot.progress!.totalUnitCount)
            print("Uploading... \(percentComplete)% complete")
            self.uploadProgressView.setProgress(Float(percentComplete / 100), animated: true)
            self.percentLabel.isHidden = false
            self.percentLabel.text = "\(Int(percentComplete))%"
        }
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                self.uploadProgressView.progress = 0.0
                self.percentLabel.text = "Upload Failed"
                print(error.localizedDescription)
            }
        }
    }
}
