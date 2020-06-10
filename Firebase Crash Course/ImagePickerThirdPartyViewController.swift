//
//  ImagePickerViewController.swift
//  Firebase Crash Course
//
//  Created by mac on 6/10/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit
import ImagePicker

class ImagePickerThirdPartyViewController: UIViewController, ImagePickerDelegate {

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
    

    var imagePickerController: ImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let configuration = Configuration()
        imagePickerController = ImagePickerController(configuration: configuration)
        configuration.doneButtonTitle = "Finish"
        configuration.noImagesTitle = "Sorry! There are no images here!"
        configuration.recordLocation = false
        configuration.backgroundColor = .cyan

        let imagePickerController = ImagePickerController(configuration: configuration)
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 5
        // Do any additional setup after loading the view.
    }
    

    @IBAction func imagePickerThirdPartyButtonClicked(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
