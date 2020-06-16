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

    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOutlet()
    }
}

extension SignInViewController {
    func setOutlet() {
        emailTextField.text = "scorcher159@gmail.com"
        passwordTextField.text = "123456"
        
        emailTextField.leftView = UIImageView(image: UIImage(systemName: "envelope.fill"))
        emailTextField.placeholder = "ENTER EMAIL"
        
        passwordTextField.leftView = UIImageView(image: UIImage(systemName: "lock.fill"))
        passwordTextField.placeholder = "ENTER PASSWORD"

        signInButton.setImage(UIImage(systemName: "person.fill"), for: .normal)
        resetPasswordButton.setImage(UIImage(systemName: "lock.fill"), for: .normal)
    }
}

extension SignInViewController {
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
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                self.signInIndicator.isHidden = true
                self.signInIndicator.stopAnimating()
            } else {
                guard let result = result, result.user.isEmailVerified else {
                    let alertController = UIAlertController(title: "Login Error", message:
                        "You haven't confirmed your email address yet. We sent you a confirmation email when you sign up. Please click the verification link in that email. If you need us to send the confirmation email again, please tap Resend Email.", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Resend email", style: .default, handler: { (action) in
                        Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.signInIndicator.isHidden = true
                    self.signInIndicator.stopAnimating()
                    return
                }
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
