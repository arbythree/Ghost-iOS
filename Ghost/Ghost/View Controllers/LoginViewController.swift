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
  @IBOutlet var urlTextField: UITextField!
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!
  @IBOutlet var onePasswordButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    onePasswordButton.isHidden = !OnePasswordExtension.shared().isAppExtensionAvailable()
  }
  
  @IBAction func onePasswordLogin(sender: UIButton) {
    let baseURL = urlTextField.text!
    
    OnePasswordExtension.shared().findLogin(
      forURLString: baseURL,
      for: self,
      sender: sender,
      completion: { (loginDictionary, error) in
        guard let loginDictionary = loginDictionary else {
          if let error = error as NSError?, error.code != AppExtensionErrorCodeCancelledByUser {
            print("Error invoking 1Password App Extension for find login: \(String(describing: error))")
          }
          return
        }
        
        if baseURL == "" {
          self.urlTextField.text = loginDictionary[AppExtensionURLStringKey] as? String
        }
        self.emailTextField.text = loginDictionary[AppExtensionUsernameKey] as? String
        self.passwordTextField.text = loginDictionary[AppExtensionPasswordKey] as? String
      }
    )
  }
  
  @IBAction func attemptLogin() {
    let mgr = AuthenticationManager.sharedManager;
    mgr.attemptLogin(
      baseURL: urlTextField.text!,
      username: emailTextField.text!,
      password: passwordTextField.text!,
      success: { (token) in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "mainView")
        self.present(mainViewController, animated: true, completion: {})
      },
      failure: {}
    );
  }
}
