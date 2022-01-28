//
//  LoginViewController.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    @IBOutlet weak var loginEmailField: UITextField!
    @IBOutlet weak var loginPasswordField: UITextField!
    
    // when user clicks on the close button
    @IBAction func loginDismissButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // when user clicks on the login button
    @IBAction func loginButton(_ sender: Any) {
        // check if the email and password field is not empty
        guard let email = loginEmailField.text, !email.isEmpty,
              let password = loginPasswordField.text, !password.isEmpty else {
                  showError(error: "Please fill in every field.")
                  return
              }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email,
                                        password: password,
                                        completion: { result, error in
            if error != nil {
                self.showError(error: error!.localizedDescription)
                return
            }
            
            self.transitionToMain()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.loginEmailField.delegate = self
        self.loginPasswordField.delegate = self
        
        loginErrorLabel.isHidden = true
    }
    
    // MARK: when user returns on the keyboard, go to next text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    
    func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.loginEmailField:
            self.loginPasswordField.becomeFirstResponder()
        default:
            self.loginPasswordField.resignFirstResponder()
        }
    }
    
    func showError(error:String) {
        loginErrorLabel.text = error
        loginErrorLabel.isHidden = false
    }
    
    // transition back to home
    func transitionToMain() {
        let storyboard = UIStoryboard(name: Constants.Storyboard.main, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.main) as UIViewController
        vc.modalPresentationStyle = .fullScreen // try without fullscreen
        present(vc, animated: true, completion: nil)
    }
}
