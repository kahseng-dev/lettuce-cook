//
//  SignUpViewController.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var signUpErrorLabel: UILabel!
    
    @IBOutlet weak var signUpUsernameField: UITextField!
    @IBOutlet weak var signUpEmailField: UITextField!
    @IBOutlet weak var signUpPasswordField: UITextField!
    
    // when the user clicks on the close button, dismiss the view
    @IBAction func signUpDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // upon clicking sign up button
    @IBAction func signUpButton(_ sender: Any) {
        // check if the user has fill in all fields
        guard let username = signUpUsernameField.text, !username.isEmpty,
              let email = signUpEmailField.text, !email.isEmpty,
              let password = signUpPasswordField.text, !password.isEmpty else {
                  // if not show error
                  showError(error: "Please fill in every field.")
                  return
              }
        
        // else create the account using firebase auth
        FirebaseAuth.Auth.auth().createUser(withEmail: email,
                                            password: password,
                                            completion: { result, error in
            
            if error != nil {
                self.showError(error: error!.localizedDescription)
                return
            }
            
            // store information besides password for future retrieval
            self.saveUser(userID: result!.user.uid, username: username, email: email)
            self.transitionToMain()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the error as hidden on start up
        signUpErrorLabel.isHidden = true
        
        self.signUpUsernameField.delegate = self
        self.signUpEmailField.delegate = self
        self.signUpPasswordField.delegate = self
    }
    
    // MARK: when user returns in the keyboard, go to next field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.signUpUsernameField:
            self.signUpEmailField.becomeFirstResponder()
        case self.signUpEmailField:
            self.signUpPasswordField.becomeFirstResponder()
        default:
            self.signUpPasswordField.resignFirstResponder()
        }
    }
    
    // saving user data to firebase database function
    func saveUser(userID:String, username:String, email:String) {
        let ref = Database.database(url:Constants.Firebase.databaseURL).reference()
        ref.child("users/\(userID)").setValue(["username": username, "email": email])
    }
    
    func showError(error:String) {
        signUpErrorLabel.text = error
        signUpErrorLabel.isHidden = false
    }
    
    // used to go back to home
    func transitionToMain() {
        let storyboard = UIStoryboard(name: Constants.Storyboard.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.main) as UIViewController
        vc.modalPresentationStyle = .fullScreen // try without fullscreen
        present(vc, animated: true, completion: nil)
    }
}
