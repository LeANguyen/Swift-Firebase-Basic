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
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class ViewController: UIViewController {
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var signInIndicator: UIActivityIndicatorView!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        for familyName in UIFont.familyNames {
//            print("\n-- \(familyName) \n")
//            for fontName in UIFont.fontNames(forFamilyName: familyName) {
//                print(fontName)
//            }
//        }
        setOutlet()
        setGIDSignIn()
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
}

extension ViewController {
    func setOutlet() {
        logoImageView.image = UIImage(systemName: "camera.circle")
        logoImageView.tintColor = .white
        
        signInButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        signUpButton.setImage(UIImage(systemName: "person.badge.plus.fill"), for: .normal)
        
        googleButton.backgroundColor = .systemRed
        googleButton.setImage(UIImage(systemName: "g.circle.fill"), for: .normal)
        
        facebookButton.backgroundColor = .systemIndigo
        facebookButton.setImage(UIImage(systemName: "f.circle.fill"), for: .normal)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tap1))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(tap2))
    }
    
    @objc func tap1() {
        self.view.endEditing(true)
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "PostView") {
            let navigationController =  UINavigationController.init(rootViewController: viewController)
            keyWindow?.rootViewController = navigationController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func tap2() {
        
    }
}

extension ViewController {
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

extension ViewController: GIDSignInDelegate {
    func setGIDSignIn() {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            return
        }
        guard let authentication = user.authentication else {
            return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        signInIndicator.startAnimating()
        signInIndicator.isHidden = false
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                
                self.signInIndicator.isHidden = true
                self.signInIndicator.stopAnimating()
                return
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
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    @IBAction func googleButtonClicked(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
}

