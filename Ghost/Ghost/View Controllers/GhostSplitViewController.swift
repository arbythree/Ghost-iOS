//
//  GhostSplitViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 5/1/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class GhostSplitViewController: UISplitViewController {
  IBOutlet bottomConstraint: NSLayoutConstraint!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: .UIKeyboardWillShow,
      object: nil
    )
  }
  
  @objc func keyboardWillShow(notification: Notification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRect = keyboardFrame.cgRectValue;
      let keyboardHeight = keyboardRect.height;
      bottomConstraint.constant = -keyboardHeight + 28;
      self.view.layoutIfNeeded();
    }
  }
}
