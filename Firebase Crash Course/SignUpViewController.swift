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
//        setOutlet()
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
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemIndigo.cgColor, UIColor.systemGreen.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        self.view.backgroundColor = .systemIndigo
        
        signUpLabel.textColor = .white
        signUpLabel.font = UIFont(name: "ArialRoundedMTBold", size: 30)
        
        nameTextField.leftViewMode = UITextField.ViewMode.always
        nameTextField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        nameTextField.backgroundColor = UIColor.clear
        nameTextField.tintColor = .white
        nameTextField.textColor = .white
        let nameBottomLine = CALayer()
        nameBottomLine.frame = CGRect(x: 0, y: nameTextField.frame.height, width: self.view.frame.width - 40, height: 1)
        nameBottomLine.backgroundColor = UIColor.white.cgColor
        nameTextField.borderStyle = UITextField.BorderStyle.none
        nameTextField.layer.addSublayer(nameBottomLine)
        nameTextField.leftView = UIImageView(image: UIImage(systemName: "person.fill"))
        nameTextField.attributedPlaceholder = NSAttributedString(string: "ENTER USERNAME", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        emailTextField.leftViewMode = UITextField.ViewMode.always
        emailTextField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        emailTextField.backgroundColor = UIColor.clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        let emailBottomLine = CALayer()
        emailBottomLine.frame = CGRect(x: 0, y: emailTextField.frame.height, width: self.view.frame.width - 40, height: 1)
        emailBottomLine.backgroundColor = UIColor.white.cgColor
        emailTextField.borderStyle = UITextField.BorderStyle.none
        emailTextField.layer.addSublayer(emailBottomLine)
        emailTextField.leftView = UIImageView(image: UIImage(systemName: "envelope.fill"))
        emailTextField.attributedPlaceholder = NSAttributedString(string: "ENTER EMAIL", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        passwordTextField.placeholder = "Password"
        passwordTextField.leftViewMode = UITextField.ViewMode.always
        passwordTextField.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        passwordTextField.backgroundColor = UIColor.clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
        let passwordBottomLine = CALayer()
        passwordBottomLine.frame = CGRect(x: 0, y: passwordTextField.frame.height, width: self.view.frame.width - 40, height: 1)
        passwordBottomLine.backgroundColor = UIColor.white.cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.layer.addSublayer(passwordBottomLine)
        passwordTextField.leftView = UIImageView(image: UIImage(systemName: "lock.fill"))
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "ENTER PASSWORD", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        signUpIndicator.isHidden = true
        signUpIndicator.style = .large
        signUpIndicator.color = .white
        
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
