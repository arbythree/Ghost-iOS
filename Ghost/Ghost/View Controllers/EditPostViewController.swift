//
//  EditPostViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 4/25/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit
import Down
import WebKit

class EditPostViewController: GhostBaseDetailViewController, UITextViewDelegate {
  @IBOutlet weak var bodyTextView: UITextView!
  @IBOutlet weak var previewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var previewWebView: WKWebView!
  @IBOutlet weak var navigationBar: UINavigationBar!
  
  var post: Post? {
    didSet {
      post?.reload {
        self.populatePostData()
        self.renderPreview()
      }
    }
  }
  
  @IBAction func toggleInfo() {
    containerViewController.toggleInfo()
  }
  
  // tell the container where to find us
  override func viewDidLoad() {
    super.viewDidLoad()
    containerViewController.editPostViewController = self
  }
  
  func populatePostData() {
    if post == nil { return }
    self.title = post?.title
    bodyTextView.text = post!.markdown
  }
  
  @IBAction func togglePreview() {
    let currentWidth = previewWidthConstraint.constant;
    var targetWidth: CGFloat = 0
    
    // this is a three-way toggle: zero (hidden), 1/3 width, full width
    if currentWidth == 0 {
      targetWidth = self.view.frame.width * 0.33
    } else if currentWidth == self.view.frame.width {
      targetWidth = 0
    } else {
      targetWidth = self.view.frame.width
    }
    
    previewWidthConstraint.constant = targetWidth
    self.loadViewIfNeeded()
  }
  
  func renderPreview() {
//    let down = Down(markdownString: post!.markdown)
//    let html = try? down.toHTML()
//    previewWebView.loadHTMLString(html!, baseURL: URL(string: "http://foo"))
  }
  
  @IBAction func cancel() {
    self.bodyTextView.resignFirstResponder()
    toggleMasterView()
  }
  
  @IBAction func save() {
    bodyTextView.resignFirstResponder()
    post?.markdown = bodyTextView.text
    post?.save()
  }
  
  // show/hide the master view
  func toggleMasterView() {

  }
  
  // #mark UITextViewDelegate
  func textViewDidBeginEditing(_ textView: UITextView) {
    toggleMasterView()
  }

  func textViewDidChange(_ textView: UITextView) {
    post?.markdown = textView.text
    renderPreview()
  }
}
