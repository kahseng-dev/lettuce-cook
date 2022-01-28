//
//  ProfileViewController.swift
//  lettuce-cook
//
//  Created by Mac on 12/1/22.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    var user = FirebaseAuth.Auth.auth().currentUser
    let profileOptions = ["My Bookmarks", "Logout"] // profile options text
    
    @IBOutlet weak var profileOptionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileOptionsTableView.delegate = self
        profileOptionsTableView.dataSource = self
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if user == nil {
            return 1
        }
        return profileOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // if user is not logged in, show sign up or sign in options
        if user == nil {
            let cell = profileOptionsTableView.dequeueReusableCell(withIdentifier: Constants.Cell.profileLogoutCell, for: indexPath) as! ProfileLogoutTableViewCell
            cell.profileLogoutDescription.text = "Sign Up or Log In to store your bookmarks and shopping list."
            cell.profileSignUpButton.addTarget(self, action: #selector(signUpButtonTap), for: .touchUpInside)
            cell.profileLoginButton.addTarget(self, action: #selector(loginButtonTap), for: .touchUpInside)
            profileOptionsTableView.rowHeight = 140
            return cell
        }
        
        // if the user is logged in, show profile options
        else {
            let cell = profileOptionsTableView.dequeueReusableCell(withIdentifier: Constants.Cell.profileLoginCell, for: indexPath) as! ProfileLoginTableViewCell
            
            cell.profileOptionButton.setTitle(profileOptions[indexPath.row], for: .normal)
            
            switch (indexPath.row) {
                case 0:
                    cell.profileOptionButton.addTarget(self, action: #selector(bookmarkButtonTap), for: .touchUpInside)
                    break
                case 1:
                    cell.profileOptionButton.addTarget(self, action: #selector(logoutButtonTap), for: .touchUpInside)
                    break
                default:
                    break
            }
            
            return cell
        }
    }
    
    @objc func signUpButtonTap(sender:UIButton) {
        transitionToSignUp()
    }
    
    @objc func loginButtonTap(sender:UIButton) {
        transitionToLogin()
    }
    
    @objc func bookmarkButtonTap(sender:UIButton) {
        transitionToBookmark()
    }
    
    @objc func logoutButtonTap(sender:UIButton) {
        logout()
    }
    
    func logout() {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {}
        user = nil
        profileOptionsTableView.reloadData()
    }
    
    func transitionToBookmark() {
        self.tabBarController?.selectedIndex = 1
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
