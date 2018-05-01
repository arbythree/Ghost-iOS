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
  var post: Post? {
    didSet {
      post?.reload {
        self.populatePostData();
      }
    }
  }
  @IBOutlet var cancelButton: UIButton!;
  @IBOutlet var titleTextField: UITextField!;
  @IBOutlet var bodyTextView: UITextView!;
  @IBOutlet var bodyTextViewBottomConstraint: NSLayoutConstraint!;
  
//  override func viewWillAppear(_ animated: Bool) {
//    super.viewWillAppear(animated);
//    post?.reload {};
//    populatePostData();
//  }
  
  override func viewDidLoad() {    
    bodyTextView.becomeFirstResponder();
  }
  
  func populatePostData() {
    if post == nil { return }
    
    titleTextField.text = post!.title
    bodyTextView.text = post!.markdown
  }
  
  @IBAction func showPreview() {
    performSegue(withIdentifier: "previewSegue", sender: self);
  }
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil);
  }
}
