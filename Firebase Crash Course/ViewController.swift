//
//  ViewController.swift
//  Firebase Crash Course
//
//  Created by mac on 6/4/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var signInIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInIndicator.isHidden = true
        if let user = Auth.auth().currentUser {
            if let name = user.displayName {
                print(name)
            } else {
                print("no name")
            }
        } else {
            print("no user")
        }
//        let ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
        
        // Create
//        ref.child("student1").setValue(["name": "Nguyen", "age": 22])
        
        // Get
//        ref.child("student1/name").observeSingleEvent(of: .value) { (snapshot) in
//            guard let name = snapshot.value as? String else {return}
//            print(name)
//        }
//
//        // Update
//        ref.child("student1/name").setValue("Phi")
//        ref.child("student1").updateChildValues(["name":"Dong", "age":23])
//
//        // Delete
//        ref.child("student1/age").removeValue()
    }
    
    @IBAction func facebookButtonClicked(_ sender: Any) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            print("ACCESS TOKEN: \(accessToken)")
            
            guard let result = result else { return }
            if (!result.isCancelled) {
                self.fbLogin(accessTokenString: accessToken.tokenString)
            }
        }
    }
    
    func fbLogin(accessTokenString: String) {
        signInIndicator.startAnimating()
        signInIndicator.isHidden = false
        let credential = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        // Perform login by calling Firebase APIs
        Auth.auth().signIn(with: credential, completion: { (result, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                self.signInIndicator.isHidden = true
                self.signInIndicator.stopAnimating()
            } else {
                self.view.endEditing(true)
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter({$0.activationState == .foregroundActive})
                    .map({$0 as? UIWindowScene})
                    .compactMap({$0})
                    .first?.windows
                    .filter({$0.isKeyWindow}).first
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                    let navigationController =  UINavigationController.init(rootViewController: viewController)
                    keyWindow?.rootViewController = navigationController
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
}

