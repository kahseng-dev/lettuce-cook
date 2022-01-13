//
//  ProfileViewController.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    @IBOutlet weak var profileDescriptionLabel: UILabel!
    
    @IBOutlet weak var logoutButtonUI: UIButton!
    
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            logoutButtonUI.isEnabled = false
            displayDefaultDescription()
        }
        catch {
            // An error occurred, cannot sign out.
        }
    }
    
    @IBAction func profileLoginButton(_ sender: Any) {
        transitionToLogin()
    }
    
    @IBAction func profileSignUpButton(_ sender: Any) {
        transitionToSignUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let user = FirebaseAuth.Auth.auth().currentUser
        
        if user != nil {
            logoutButtonUI.isEnabled = true
            displayUsername(userID: user!.uid)
        }
        
        else {
            logoutButtonUI.isEnabled = false
            displayDefaultDescription()
        }
    }
    
    func displayUsername(userID:String) {
        let ref = Database.database(url: Constants.Firebase.databaseURL).reference()
        ref.child("users/\(userID)/username").getData(completion: { error, snapshot in
            
            if error != nil {
                return
            }
            
            let username = snapshot.value as? String ?? "Unknown"
            self.profileDescriptionLabel.text = "Welcome Back \(username)!"
        })
    }
    
    func displayDefaultDescription() {
        profileDescriptionLabel.text = "Sign Up or Log In to store your bookmarks and shopping list."
    }
    
    func transitionToSignUp() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.signUp) as! SignUpViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func transitionToLogin() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.login) as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
