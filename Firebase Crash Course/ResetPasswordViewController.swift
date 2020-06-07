//
//  ResetPasswordViewController.swift
//  Firebase Crash Course
//
//  Created by mac on 6/7/20.
//  Copyright © 2020 Le An Nguyen. All rights reserved.
//

import UIKit
import Firebase

class ResetPasswordViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func resetPasswordButtonClicked(_ sender: Any) {
        // Validate the input
        let email = emailTextField.text!
        if (email == "") {
            let alertController = UIAlertController(title: "Input Error", message: "Please provide your email address for password reset.", preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        
        // Send password reset email
        Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
            let title = (error == nil) ? "Password Reset Follow-up" : "Password ResetError"
            let message = (error == nil) ? "We have just sent you a password reset email. Please check your inbox and follow the instructions to reset your password." :
            error?.localizedDescription
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                if error == nil {
                    // Dismiss keyboard
                    self.view.endEditing(true)
                    // Return to the login screen
                    if let navigationController = self.navigationController {
                        navigationController.popViewController(animated: true)
                    }
                }
            })
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
