//
//  TabBarController.swift
//  lettuce-cook
//
//  Created by Mac on 13/1/22.
//

import UIKit
import FirebaseAuth

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // custom tabbar controller to show login requirement for certain features of the app
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let user = FirebaseAuth.Auth.auth().currentUser
        
        if user == nil {
            let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController)!
            
            if selectedIndex == 1 { // Bookmarks Bar Item
                showActionSheet()
                return false
            }
        }
        
        return true
    }
    
    // show action sheet function that contains create account or login options
    func showActionSheet() {
        let alert = UIAlertController(title: "Create an account to continue", message: "Create an account or login to view your personal information", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Create an Account", style: .default, handler: { (_) in
            self.transitionToSignUp()
        }))

        alert.addAction(UIAlertAction(title: "Login to your Account", style: .default, handler: { (_) in
            self.transitionToLogin()
        }))

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
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
