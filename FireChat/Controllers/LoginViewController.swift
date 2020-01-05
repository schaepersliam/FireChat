//
//  LoginViewController.swift
//  FireChat
//
//  Copyright © 2019 Angela Yu and Liam Schäpers. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let e = error {
                    print(e)
                } else { self!.performSegue(withIdentifier: "loginToChat", sender: self) }
            }
        }
    }
}
