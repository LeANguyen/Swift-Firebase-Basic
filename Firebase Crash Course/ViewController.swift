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
    
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var menuView: UIView!
    
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
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemIndigo.cgColor, UIColor.systemGreen.cgColor]
        menuView.layer.insertSublayer(gradientLayer, at: 0)
        sideView.backgroundColor = UIColor(patternImage: UIImage(named: "light1.jpeg")!)
        self.view.backgroundColor = .systemIndigo
        
        welcomeLabel.textColor = .white
        welcomeLabel.font = UIFont(name: "ArialRoundedMTBold", size: 30)
        
        logoImageView.image = UIImage(systemName: "camera.circle")
        logoImageView.tintColor = .white
        
        signInIndicator.isHidden = true
        signInIndicator.style = .large
        signInIndicator.color = .white
        
        signInButton.tintColor = .white
        signInButton.layer.borderWidth = 2
        signInButton.layer.borderColor = UIColor.white.cgColor
        signInButton.frame.size.height = 50
        signInButton.contentEdgeInsets.top = 15
        signInButton.contentEdgeInsets.bottom = 15
        signInButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        signInButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        signInButton.layer.cornerRadius = signInButton.frame.height / 2
        signInButton.clipsToBounds = true
        
        signUpButton.tintColor = .white
        signUpButton.layer.borderWidth = 2
        signUpButton.layer.borderColor = UIColor.white.cgColor
        signUpButton.frame.size.height = 50
        signUpButton.contentEdgeInsets.top = 15
        signUpButton.contentEdgeInsets.bottom = 15
        signUpButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        signUpButton.setImage(UIImage(systemName: "person.badge.plus.fill"), for: .normal)
        signUpButton.layer.cornerRadius = signUpButton.frame.height / 2
        signUpButton.clipsToBounds = true
        
        googleButton.tintColor = .white
        googleButton.backgroundColor = .systemRed
        googleButton.frame.size.height = 50
        googleButton.contentEdgeInsets.top = 15
        googleButton.contentEdgeInsets.bottom = 15
        googleButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        googleButton.setImage(UIImage(systemName: "g.circle.fill"), for: .normal)
        googleButton.layer.cornerRadius = googleButton.frame.height / 2
        googleButton.clipsToBounds = true
        
        facebookButton.tintColor = .white
        facebookButton.backgroundColor = .systemIndigo
        facebookButton.frame.size.height = 50
        facebookButton.contentEdgeInsets.top = 15
        facebookButton.contentEdgeInsets.bottom = 15
        facebookButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        facebookButton.setImage(UIImage(systemName: "f.circle.fill"), for: .normal)
        facebookButton.layer.cornerRadius = facebookButton.frame.height / 2
        facebookButton.clipsToBounds = true
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

