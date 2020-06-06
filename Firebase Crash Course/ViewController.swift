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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
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

