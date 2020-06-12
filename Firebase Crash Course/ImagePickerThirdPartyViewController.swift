//
//  ImagePickerViewController.swift
//  Firebase Crash Course
//
//  Created by mac on 6/10/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit
import ImagePicker
import FirebaseStorage

class ImagePickerThirdPartyViewController: UIViewController {
    @IBOutlet weak var myImageView: UIImageView!
    var imagePickerController = ImagePickerController()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setImagePickerControllerConfiguration()
        // Do any additional setup after loading the view.
        
        let storageReference = Storage.storage().reference().child("images").child("Down.png")
        storageReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            print("Download Error: \(error)")
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.myImageView.image = image
          }
        }
    }
    
    @IBAction func imagePickerThirdPartyButtonClicked(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension ImagePickerThirdPartyViewController: ImagePickerDelegate {
    func setImagePickerControllerConfiguration() {
        let configuration = Configuration()
        imagePickerController = ImagePickerController(configuration: configuration)
        configuration.doneButtonTitle = "Finish"
        configuration.noImagesTitle = "Sorry! There are no images here!"
        configuration.recordLocation = false
        configuration.backgroundColor = .cyan

        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 5
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("wrapper button clicked")
    }

    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("done button clicked")
        for image in images {
            print(image.size)
        }
        dismiss(animated: true, completion: nil)
    }

    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("cancel button clicked")
        dismiss(animated: true, completion: nil)
    }
}
