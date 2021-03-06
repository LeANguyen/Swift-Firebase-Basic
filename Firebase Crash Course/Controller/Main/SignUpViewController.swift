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
    
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var signUpIndicator: UIActivityIndicatorView!
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOutlet()
        // Do any additional setup after loading the view.
    }
}

extension SignUpViewController {
    func setOutlet() {
        nameTextField.text = "nguyen"
        emailTextField.text = "scorcher159@gmail.com"
        passwordTextField.text = "123456"

        nameTextField.leftView = UIImageView(image: UIImage(systemName: "person.fill"))
        nameTextField.placeholder = "ENTER USERNAME"
        
        emailTextField.leftView = UIImageView(image: UIImage(systemName: "envelope.fill"))
        emailTextField.placeholder = "ENTER EMAIL"
        
        passwordTextField.leftView = UIImageView(image: UIImage(systemName: "lock.fill"))
        passwordTextField.placeholder = "ENTER PASSWORD"

        signUpButton.setImage(UIImage(systemName: "person.badge.plus.fill"), for: .normal)
    }
}

extension SignUpViewController {
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
                    // Create
                    guard let currentUser = Auth.auth().currentUser else { return }
                    guard let displayName = currentUser.displayName else { return }
                    let ref = Database.database().reference().child("users").child(currentUser.uid)
                    ref.child("name").setValue(displayName)
                    
//                    ref.child("name").setValue(displayName)
//                    // Create
//                    ref.child("users").setValue(["name": "Nguyen", "age": 22])
//
//                    // Get
//                    ref.child("student1/name").observeSingleEvent(of: .value) { (snapshot) in
//                        guard let name = snapshot.value as? String else {return}
//                        print(name)
//                    }
//
//                    // Update
//                    ref.child("student1/name").setValue("Phi")
//                    ref.child("student1").updateChildValues(["name":"Dong", "age":23])
//
//                    // Delete
//                    ref.child("student1/age").removeValue()
                    
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
