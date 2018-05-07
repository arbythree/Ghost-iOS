//
//  EditPostViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 4/25/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import Down

class EditPostViewController: GhostBaseDetailViewController, UITextViewDelegate, WKNavigationDelegate {
  @IBOutlet weak var bodyTextView: UITextView!
  @IBOutlet weak var previewWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var webView: WKWebView!
  private var accessoryView: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
  
  var post: Post? {
    didSet {
      post?.reload {
        self.populatePostData()
        self.renderPreview()
      }
    }
  }
  
  // MARK: IBActions
  //
  // show hide the right-hand info panel
  @IBAction func toggleInfo() {
    containerViewController?.toggleInfo()
  }
  
  // show/hide the side menu and post list
  @IBAction func toggleFullScreen() {
    containerViewController?.toggleFullEditMode()
  }
  
  @IBAction func togglePreview() {
    previewWidthConstraint.constant = previewWidthConstraint.constant == 0 ? self.view.frame.width / 2 : 0
  }
  
  @IBAction func cancel() {
    // TODO: confirm via actionsheet
    bodyTextView.text = post?.markdown
    self.bodyTextView.resignFirstResponder()
  }
  
  @IBAction func save() {
    bodyTextView.resignFirstResponder()
    post?.markdown = bodyTextView.text
    post?.save()
  }
  
  //
  // MARK: lifecycle
  //
  override func viewDidLoad() {
    super.viewDidLoad()
    previewWidthConstraint.constant = 0
    webView.navigationDelegate = self
    let verticalPadding: CGFloat = 60
    let horizontalPadding: CGFloat = 120
    bodyTextView.textContainerInset = UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding)
    
    let italicButton = UIBarButtonItem(title: "Italic", style: .plain, target: self, action: #selector(formatItalic))
    let boldButton = UIBarButtonItem(title: "Bold", style: .plain, target: self, action: #selector(formatBold))
    accessoryView.items = [boldButton, wytm2italicButton]
    accessoryView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
    
    
    
    bodyTextView.inputAccessoryView = accessoryView
  }
  
  @objc func formatItalic() {
    let allText = bodyTextView.text!
    let range = bodyTextView.selectedTextRange!
    let selection = bodyTextView.text(in: range)!
    let newSelection = "/\(selection)/"
  
    // this isn't right...we need to use a Range but I can't figure it out yet
//    let offset = bodyTextView.sc
    bodyTextView.text = allText.replacingOccurrences(of: selection, with: newSelection)
    
  }

  @objc func formatBold() {
  }
  
  //
  // MARK: delegate methods
  //
  func textViewDidChange(_ textView: UITextView) {
    post?.markdown = textView.text
    renderPreview()
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    insertCSSString(into: webView)
  }
  
  //
  // MARK: private parts
  //
  private func populatePostData() {
    if post == nil { return }
    self.title = post?.title
    bodyTextView.text = post!.markdown
  }
  
  private func renderPreview() {
    let down = Down(markdownString: post!.markdown)
    let html = try? down.toHTML()
    webView.loadHTMLString(html!, baseURL: URL(string: "http://foo"))
  }
  
  //
  // apply styling to the webview so the text isn't itty-bitty
  // courtesy of https://stackoverflow.com/questions/33123093/insert-css-into-loaded-html-in-uiwebview-wkwebview
  //
  private func insertCSSString(into: WKWebView) {
    let cssString = "body { font-size: 36px; color: #333 }"
    let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
    webView.evaluateJavaScript(jsString, completionHandler: nil)
  }
}
