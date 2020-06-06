//
//  SigninViewController.swift
//  Firebase Crash Course
//
//  Created by mac on 6/5/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit
import Firebase
class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.text = "nguyen@gmail.com"
        passwordTextField.text = "123456"
        signInIndicator.isHidden = true
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if (email == "" || password == "") {
            let alertController = UIAlertController(title: "Login Error", message: "Please make sure you provide your email and password.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        self.signInIndicator.startAnimating()
        self.signInIndicator.isHidden = false
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                self.signInIndicator.isHidden = true
                self.signInIndicator.stopAnimating()
                print("THERE IS AN ERROR")
                print(error)
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
