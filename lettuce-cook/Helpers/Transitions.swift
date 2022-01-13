//
//  Transitions.swift
//  lettuce-cook
//
//  Created by Mac on 14/1/22.
//

import Foundation

struct Transitions {
    
    public func transitionToLogin() {
        let vc = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.login) as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
