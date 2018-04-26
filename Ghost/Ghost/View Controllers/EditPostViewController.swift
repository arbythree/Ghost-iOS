//
//  EditPostViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 4/25/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class EditPostViewController: UIViewController {
  var post: Post?;
  @IBOutlet var titleTextField: UITextField!;
  @IBOutlet var bodyTextView: UITextView!;
  
  func setPost(value: Post) {
    post = value;
  }
  
  override func viewDidLoad() {
    if (post != nil) {
      titleTextField.text = post!.title;
    }
  }
  
  @IBAction func showPreview() {
    performSegue(withIdentifier: "previewSegue", sender: self);
  }
}
