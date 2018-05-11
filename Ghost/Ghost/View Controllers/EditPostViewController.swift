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
  var isDirty = false
  
  var post: Post? {
    didSet {
      if isDirty {
        // TODO: confirm user wants to lose changes
      }
      
      post?.reload {
        self.populatePostData()
        self.renderPreview()
        self.isDirty = false
        self.bodyTextView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
        self.bodyTextView.becomeFirstResponder()
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
    // make sure we're in full edit view, if we weren't already
    if previewWidthConstraint.constant == 0 {
      self.containerViewController?.toggleFullEditMode()
    }
    
    previewWidthConstraint.constant = previewWidthConstraint.constant == 0 ? self.view.frame.width / 2 : 0
    setEditorPadding()
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
  
  func delete() {
    // display an action sheet to confirm
    post?.destroy()
  }
  
  //
  // MARK: lifecycle
  //
  override func viewDidLoad() {
    super.viewDidLoad()
    previewWidthConstraint.constant = 0
    webView.navigationDelegate = self
    
    setEditorPadding()
    initializeInputAccessory()
  }
  
  override func viewDidLayoutSubviews() {
    setEditorPadding()
  }
  
  @objc func formatItalic() {
    wrapCurrentSelection(with: "/")
  }

  @objc func formatBold() {
    wrapCurrentSelection(with: "*")
  }
  
  @objc func formatUnderline() {
    wrapCurrentSelection(with: "_")
  }
  
  @objc func formatBullet() {
  }
  
  @objc func formatNumberedList() {
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
    renderPreview()
  }
  
  private func insertTextAtCaret(insertedText:String) {
    let range = bodyTextView.selectedTextRange!
    let allText = bodyTextView.text!
    let start = bodyTextView.offset(from: bodyTextView.beginningOfDocument, to: range.start)
    let end = bodyTextView.offset(from: bodyTextView.beginningOfDocument, to: range.end)
    var newText = allText.prefix(start) + insertedText
    newText.append(contentsOf: allText.dropFirst(end))
    //
    // !@#$%^ good grief, that was complicated. Swift 4 Strings kinda hurt
    //
    // replace the text without affecting scroll location
    let offset = bodyTextView.contentOffset
    bodyTextView.text = String(newText)
    bodyTextView.setContentOffset(offset, animated: false)
    
    // update preview
    renderPreview()
  }
  
  //
  // MARK: delegate methods
  //
  func textViewDidChange(_ textView: UITextView) {
    post?.markdown = textView.text
    isDirty = true
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
        let fullPath = client.baseURL! + body.replacingOccurrences(of: "\"", with: "")
        let markup = "![](\(fullPath))"
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

    let attrString = NSMutableAttributedString(string: post!.markdown!)
    let paragraphStyle = NSMutableParagraphStyle()
    let menloFont = UIFont(name: "Menlo", size: 16)
    let allTextRange = NSRange.init(location: 0, length: post!.markdown!.count)
    
    paragraphStyle.lineSpacing = 24
    attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: allTextRange)
    attrString.addAttribute(.font, value: menloFont as Any, range: allTextRange)
    
    bodyTextView.attributedText = attrString
  }
  
  private func renderPreview() {
    let down = Down(markdownString: post!.markdown!)
    let html = try? down.toHTML()
    let offset = webView.scrollView.contentOffset
    webView.loadHTMLString(html!, baseURL: URL(string: GhostRESTClient().baseURL!))
    webView.scrollView.setContentOffset(offset, animated: false)
  }
  
  //
  // apply styling to the webview so the text isn't itty-bitty
  // courtesy of https://stackoverflow.com/questions/33123093/insert-css-into-loaded-html-in-uiwebview-wkwebview
  //
  private func insertCSSString(into: WKWebView) {
    let cssString = "body { font-size: 36px; color: #333; padding: 36px !important; }"
    let jsString = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style);"
    webView.evaluateJavaScript(jsString, completionHandler: nil)
  }
  
  //
  // create and rather tediously build up the Input Accessory (the toolbar that rides on top of the keyboard)
  //
  private func initializeInputAccessory() {
    let italicImage    = UIImage(named: "italic")?.withRenderingMode(.alwaysOriginal)
    let boldImage      = UIImage(named: "bold")?.withRenderingMode(.alwaysOriginal)
    let underlineImage = UIImage(named: "underline")?.withRenderingMode(.alwaysOriginal)
    let bulletsImage   = UIImage(named: "bullets")?.withRenderingMode(.alwaysOriginal)
    let numListImage   = UIImage(named: "numbered-list")?.withRenderingMode(.alwaysOriginal)
    let imageImage     = UIImage(named: "image")?.withRenderingMode(.alwaysOriginal)

    let italicButton    = UIBarButtonItem(image: italicImage,    style: .plain, target: self, action: #selector(formatItalic))
    let boldButton      = UIBarButtonItem(image: boldImage,      style: .plain, target: self, action: #selector(formatBold))
    let underlineButton = UIBarButtonItem(image: underlineImage, style: .plain, target: self, action: #selector(formatUnderline))
    let bulletButton    = UIBarButtonItem(image: bulletsImage,   style: .plain, target: self, action: #selector(formatBullet))
    let numListButton   = UIBarButtonItem(image: numListImage,   style: .plain, target: self, action: #selector(formatNumberedList))
    let imageButton     = UIBarButtonItem(image: imageImage,     style: .plain, target: self, action: #selector(insertImage))
  
    // populate the toolbar
    accessoryView.items = [boldButton, italicButton, underlineButton, bulletButton, numListButton, imageButton]
  
    // lay it out and attach it
    accessoryView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)
    bodyTextView.inputAccessoryView = accessoryView
  }
  
  //
  // the padding of the UITextView editor area varies depending on several factors:
  // 1. overall screen dimensions
  // 2. screen orientation
  // 3. is preview visible (which is another way of expressing 1 & 2 as it alters the effective width
  // of the edit pane
  //
  private func setEditorPadding() {
    let maxTextWidth: CGFloat = 400 // widest possible text
    let minPadding: CGFloat = 30 // smallest possible padding
    let viewWidth = bodyTextView.bounds.size.width
    let textWidth = min(viewWidth - (minPadding * 2), maxTextWidth)
    let horizontalPadding = (viewWidth - textWidth) / 2.0
    let verticalPadding: CGFloat = minPadding * 2
    
    // now apply it
    bodyTextView.textContainerInset = UIEdgeInsetsMake(verticalPadding, horizontalPadding, verticalPadding, horizontalPadding)
  }
}
