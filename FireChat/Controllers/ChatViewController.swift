//
//  ChatViewController.swift
//  FireChat
//
//  Copyright © 2019 Angela Yu and Liam Schäpers. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        title = "🔥FireChat"
        navigationItem.hidesBackButton = true
        tableView.backgroundColor = #colorLiteral(red: 0.3333333333, green: 0.3333333333, blue: 0.3333333333, alpha: 1)
        loadMessages()
    }
    
    func loadMessages() {
        db.collection("messages").order(by: "date").addSnapshotListener { (querySnapshot, error) in
            self.messages = []
            if let e = error {
                print("An error occured while retrieving data from Firestore.\(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let sender = data["sender"] as? String, let message = data["message"] as? String {
                            self.messages.append(Message(sender: sender, body: message))
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let sender = Auth.auth().currentUser?.email {
            db.collection("messages").addDocument(data: [
                "sender": sender,
                "message": messageBody,
                "date": Date().timeIntervalSince1970]) { (error) in
                if let e = error { print("There was an issue saving the data to Firstore. \(e)") }
            }
        }
        messageTextfield.text = ""
        messageTextfield.resignFirstResponder()
    }
    
    @IBAction func logoutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
    }
    
}

extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: "BrandLightPurple")
            cell.label.textColor = UIColor(named: "BrandPurple")
            cell.senderLabel.text = Auth.auth().currentUser?.email
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: "BrandPurple")
            cell.label.textColor = UIColor(named: "BrandLightPurple")
            cell.senderLabel.text = message.sender
        }
        return cell
    }
}
