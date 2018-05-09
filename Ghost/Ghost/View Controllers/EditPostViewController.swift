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

class EditPostViewController: GhostBaseDetailViewController, UITextViewDelegate, WKNavigationDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
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
    
    // lay out the text input area
    let verticalPadding: CGFloat = 60
    let horizontalPadding: CGFloat = 120
    bodyTextView.textContainerInset = UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding)
    
    // instantiate and add buttons
    let italicButton = UIBarButtonItem(title: "Italic",  style: .plain, target: self, action: #selector(formatItalic))
    let boldButton   = UIBarButtonItem(title: "Bold",    style: .plain, target: self, action: #selector(formatBold))
    let bulletButton = UIBarButtonItem(title: "Bullets", style: .plain, target: self, action: #selector(formatBullet))
    let imageButton  = UIBarButtonItem(title: "Image",   style: .plain, target: self, action: #selector(insertImage))
    accessoryView.items = [boldButton, italicButton, bulletButton, imageButton]
    
    // lay it out and attach it
    accessoryView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
    bodyTextView.inputAccessoryView = accessoryView
  }
  
  @objc func formatItalic() {
    wrapCurrentSelection(with: "/")
  }

  @objc func formatBold() {
    wrapCurrentSelection(with: "*")
  }
  
  @objc func formatBullet() {
  }
  
  @objc func insertImage() {
    let imagePicker = UIImagePickerController()
    imagePicker.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
    imagePicker.sourceType = .savedPhotosAlbum
    imagePicker.allowsEditing = false
    self.present(imagePicker, animated: true, completion: nil)
  }
  
  private func wrapCurrentSelection(with token:String) {
    let range = bodyTextView.selectedTextRange!
    let allText = bodyTextView.text!
    let selection = bodyTextView.text(in: range)!
    let start = bodyTextView.offset(from: bodyTextView.beginningOfDocument, to: range.start)
    let end = bodyTextView.offset(from: bodyTextView.beginningOfDocument, to: range.end)
    var newSelection = token
    
    // if there's a bona fide selection (as opposed to a cursor but no selection),
    // put the token on both ends of the selection
    if start != end {
       newSelection = token + "\(selection)" + token
    }
    
    var newText = allText.prefix(start) + newSelection
    newText.append(contentsOf: allText.dropFirst(end))
    // good grief, that was complicated. Swift 4 Strings kinda hurt
    
    // replace the text without affected scroll location
    let offset = bodyTextView.contentOffset
    bodyTextView.text = String(newText)
    bodyTextView.setContentOffset(offset, animated: false)
  }
  
  private func insertTextAtCaret(insertedText:String) {
    let range = bodyTextView.selectedTextRange!
    let allText = bodyTextView.text!
    let selection = bodyTextView.text(in: range)!
    let start = bodyTextView.offset(from: bodyTextView.beginningOfDocument, to: range.start)
    let end = bodyTextView.offset(from: bodyTextView.beginningOfDocument, to: range.end)
    var newText = allText.prefix(start) + insertedText
    newText.append(contentsOf: allText.dropFirst(end))
    // good grief, that was complicated. Swift 4 Strings kinda hurt
    
    // replace the text without affected scroll location
    let offset = bodyTextView.contentOffset
    bodyTextView.text = String(newText)
    bodyTextView.setContentOffset(offset, animated: false)
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

  // fired when user chooses an image
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    // 1. upload image
    let image: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
    let referenceURL = info["UIImagePickerControllerReferenceURL"] as! NSURL
    let components = URLComponents(string: referenceURL.absoluteString!)!
    let items = components.queryItems
    let name = items?.first?.value?.replacingOccurrences(of: "-", with: "").lowercased()
    let imageData = UIImageJPEGRepresentation(image, 0)!
    let client = GhostRESTClient()
    
    client.upload(
      imageData: imageData,
      name: name!,
      success: { (body) in
        picker.dismiss(animated: true, completion: nil)
        let markup = "![](\(body.replacingOccurrences(of: "\"", with: "")))"
        self.insertTextAtCaret(insertedText: markup)
      },
      failure: { () in
        picker.dismiss(animated: true, completion: nil)
      }
    )
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
