//
//  LoginViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 4/25/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
  @IBOutlet var urlTextField: UITextField!;
  @IBOutlet var emailTextField: UITextField!;
  @IBOutlet var passwordTextField: UITextField!;
  
  @IBAction func attemptLogin() {
    let mgr = AuthenticationManager.sharedManager;
    mgr.attemptLogin(
      baseURL: urlTextField.text!,
      username: emailTextField.text!,
      password: passwordTextField.text!,
      success: { (token) in
        // load up and launch the main UI
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainView");
        self.present(mainViewController, animated: true, completion: {});
      },
      failure: {}
    );
  }
}
