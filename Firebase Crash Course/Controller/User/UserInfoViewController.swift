//
//  UserInfoViewController.swift
//  Firebase Crash Course
//
//  Created by mac on 6/5/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit
import Firebase
class UserInfoViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Main View")
        userImageView.image = UIImage(systemName: "person.fill")
        userImageView.tintColor = .white
        if let currentUser = Auth.auth().currentUser {
            if let displayName = currentUser.displayName {
                nameLabel.text = displayName
                print(currentUser.uid)
            } else {
                print("THERE IS NO NAME TO BE DISPLAYED")
            }
        } else {
            print("THERE IS NO CURRENT USER")
        }
        // Do any additional setup after loading the view.
    }
    

    @IBAction func signOutButtonClicked(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            let alertController = UIAlertController(title: "Logout Error", message: error.localizedDescription, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        switchNavigationController(storyBoardId: "Main", viewControllerId: "MainView")
    }
}
