//
//  RegisterViewController.swift
//  FireChat
//
//  Copyright © 2019 Angela Yu and Liam Schäpers. All rights reserved.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else { self.performSegue(withIdentifier: "registerToChat", sender: self) }
            }
        }
    }
}
