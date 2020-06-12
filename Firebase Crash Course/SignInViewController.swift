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
        let gradientLayer = CAGradientLayer()
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.systemIndigo.cgColor, UIColor.systemGreen.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        self.view.backgroundColor = .systemIndigo
        
        emailTextField.text = "scorcher159@gmail.com"
        passwordTextField.text = "123456"
        
        signInIndicator.isHidden = true
        signInIndicator.style = .large
        signInIndicator.color = .white
        
        signInLabel.textColor = .white
        signInLabel.font = UIFont(name: "ArialRoundedMTBold", size: 30)
        
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
        
        resetPasswordButton.tintColor = .white
        resetPasswordButton.layer.borderWidth = 2
        resetPasswordButton.layer.borderColor = UIColor.white.cgColor
        resetPasswordButton.frame.size.height = 50
        resetPasswordButton.contentEdgeInsets.top = 15
        resetPasswordButton.contentEdgeInsets.bottom = 15
        resetPasswordButton.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        resetPasswordButton.setImage(UIImage(systemName: "lock.fill"), for: .normal)
        resetPasswordButton.layer.cornerRadius = signInButton.frame.height / 2
        resetPasswordButton.clipsToBounds = true
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
