//
//  LoginViewController.swift
//  UserLocation
//
//  Created by 王安妮 on 2018/4/13.
//  Copyright © 2018年 Yash Patel. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {
var ref: DatabaseReference?
    override func viewDidLoad() {
        super.viewDidLoad()
ref = Database.database().reference()        //
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sing(_ sender: Any){
    Auth.auth().createUser(withEmail: "annie@gmail.com", password: "123456") { (user, error) in
    
    if let user = user {
    print("user id: \(user.uid)")
    self.ref?.child("users").child(user.uid).setValue(["email": user.email])
    
    //                let friend = ["id": "12345"]
    //
    //                self.ref?.child("users").child(user.uid).child("friends").updateChildValues(friend)
    
    
    //                self.ref?.child("users").child(user.uid).child("friends")
    }
    if let error = error {
    print("error: \(error)")
    }
    }
}
    
    @IBAction func logIn(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: "annie@gmail.com", password: "123456") { (user, error) in
            if let user = user {
                print("user id: \(user.uid)")
                self.performSegue(withIdentifier: "goToFriendPage", sender: self)
                
            }
            if let error = error {
                print("error: \(error)")
            }
            
        }
        
    }
}
