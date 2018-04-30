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
  var post: Post = Post();
  @IBOutlet var cancelButton: UIButton!;
  @IBOutlet var titleTextField: UITextField!;
  @IBOutlet var bodyTextView: UITextView!;
  @IBOutlet var bodyTextViewBottomConstraint: NSLayoutConstraint!;
  
  func setPost(value: Post) {
    post = value;
    post.reload();
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated);
    post.reload();
    populatePostData();
  }
  
  override func viewDidLoad() {
    populatePostData();
    bodyTextView.becomeFirstResponder();
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: .UIKeyboardWillShow,
      object: nil
    )
  }
  
  func populatePostData() {
    titleTextField.text = post.title;
    cancelButton.isHidden = post.isNew();
    bodyTextView.text = post.markdown;
  }
  
  @IBAction func showPreview() {
    performSegue(withIdentifier: "previewSegue", sender: self);
  }
  
  @IBAction func cancel() {
    dismiss(animated: true, completion: nil);
  }
  
  @objc func keyboardWillShow(notification: Notification) {
    if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
      let keyboardRect = keyboardFrame.cgRectValue;
      let keyboardHeight = keyboardRect.height;
      bodyTextViewBottomConstraint.constant = -keyboardHeight + 28;
      self.view.layoutIfNeeded();
    }
  }
}
