//
//  MoreViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 4/25/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class MoreViewController: GhostBaseDetailViewController {
  @IBOutlet var logOutButton: UIButton!;
  
  @IBAction func signOut() {
    AuthenticationManager.sharedManager.logOut();
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let mainViewController = storyboard.instantiateViewController(withIdentifier: "loginView");
    self.present(mainViewController, animated: true, completion: {});
  }
}
