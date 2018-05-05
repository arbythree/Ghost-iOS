//
//  PostInfoViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 5/3/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class PostInfoViewController: GhostBaseDetailViewController {
  @IBAction func save() {
    containerViewController?.editPostViewController?.save()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.shadowColor = UIColor.black.cgColor
  }
  
  @IBAction func hide() {
    containerViewController?.toggleInfo()
  }
}
