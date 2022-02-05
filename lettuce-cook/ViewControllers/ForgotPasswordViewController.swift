//
//  ForgotPasswordViewController.swift
//  lettuce-cook
//
//  Created by Lee Sutton on 5/2/22.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var forgotPasswordEmailAddress: UITextField!
    
    @IBOutlet weak var forgotPasswordMessage: UILabel!
    
    @IBAction func forgotPasswordCloseButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendEmailButton(_ sender: Any) {
        guard let email = forgotPasswordEmailAddress.text, !email.isEmpty
        
        else {
            forgotPasswordMessage.textColor = UIColor.red
            forgotPasswordMessage.text = "Please fill in every field."
            forgotPasswordMessage.isHidden = false
            return
        }
        
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                self.forgotPasswordMessage.textColor = UIColor.red
                self.forgotPasswordMessage.text = error.localizedDescription
                self.forgotPasswordMessage.isHidden = false
            }
            
            self.forgotPasswordMessage.textColor = UIColor.green
            self.forgotPasswordMessage.text = "A password reset has been sent to your email"
            self.forgotPasswordMessage.isHidden = false
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        forgotPasswordMessage.isHidden = true
    }
}
