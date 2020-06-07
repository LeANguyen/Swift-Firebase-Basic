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
        nameTextField.text = "nguyen"
        emailTextField.text = "scorcher159@gmail.com"
        passwordTextField.text = "123456"
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
            } else {
                self.createProfileChangeRequest()
            }
        })
    }
    
    func createProfileChangeRequest() {
        let name = nameTextField.text!
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.displayName = name
            changeRequest.commitChanges(completion: { (error) in
                if let error = error {
                    let alertController = UIAlertController(title: "Change Username Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.signUpIndicator.isHidden = true
                    self.signUpIndicator.stopAnimating()
                } else {
                    self.sendEmailVerification()
                }
            })
        }
    }
    
    func sendEmailVerification() {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            let title = (error == nil) ? "Email Verification" : "Email Verification Error"
            let message = (error == nil) ? "We've just sent a confirmation email to your email address. Please check your inbox and click the verification link in that email to complete the sign up." : error!.localizedDescription
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                // Dismiss keyboard
                self.view.endEditing(true)
                // Return to the login screen
                if let navigationController = self.navigationController {
                    navigationController.popViewController(animated: true)
                }
            })
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
}
