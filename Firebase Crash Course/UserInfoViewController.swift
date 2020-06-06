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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUser = Auth.auth().currentUser {
            if let displayName = currentUser.displayName {
                nameLabel.text = displayName
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
        
        self.view.endEditing(true)
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeView") {
            let navigationController =  UINavigationController.init(rootViewController: viewController)
            keyWindow?.rootViewController = navigationController
            self.dismiss(animated: true, completion: nil)
        }
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
