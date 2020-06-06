//
//  SignupViewController.swift
//  Firebase Crash Course
//
//  Created by mac on 6/5/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpIndicator.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpButtonClicked(_ sender: Any) {
        let name = nameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if (name == "" || email == "" || password == "") {
            let alertController = UIAlertController(title: "Registration Error", message: "Please make sure you provide your username, email and password.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        signUpIndicator.startAnimating()
        signUpIndicator.isHidden = false
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Registration Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                self.signUpIndicator.isHidden = true
                self.signUpIndicator.stopAnimating()
                print("THERE IS AN ERROR")
                print(error)
                return
            }
            
            if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        print("Failed to change the display name: \(error.localizedDescription)")
                    }
                })
            }
            
            self.view.endEditing(true)
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "MainView") {
                UIApplication.shared.keyWindow?.rootViewController = viewController
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
}
