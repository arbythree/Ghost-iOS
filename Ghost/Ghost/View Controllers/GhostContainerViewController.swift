//
//  GhostContainerViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 5/1/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class GhostContainerViewController: UIViewController {
  @IBOutlet weak var sideMenuWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var postListWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var editPaneWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var previewWidthConstraint:  NSLayoutConstraint!
  @IBOutlet weak var infoLeftConstraint: NSLayoutConstraint!
  @IBOutlet weak var sideMenuContainer: UIView!
  @IBOutlet weak var postListContainer: UIView!
  @IBOutlet weak var editPaneContainer: UIView!
  @IBOutlet weak var previewContainer:  UIView!
  @IBOutlet weak var sideMenuBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var postListBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var editPaneBottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var infoPaneBottomConstraint: NSLayoutConstraint!
  private var _sideMenuWidth: CGFloat = 0
  private var _postListWidth: CGFloat = 0
  private var _editing = false
  private var _fullEditMode = false
  var editPostViewController: EditPostViewController?
  var previewViewController: PreviewViewController?
  var infoViewController: PostInfoViewController?
  
  // MARK: IBActions
  // show/hide the side menu on the far left
  @IBAction func toggleSideMenu() {
    let targetWidth: CGFloat = sideMenuWidthConstraint.constant == 0 ? 240 : 0
    sideMenuWidthConstraint.constant = targetWidth
  }
  
  // show/hide the Info panel on the far right
  @IBAction func toggleInfo() {
    let targetConstant: CGFloat = infoLeftConstraint.constant == 0 ? self.view.bounds.size.width : 0
    infoLeftConstraint.constant = targetConstant
  }
  
  @IBAction func toggleEditMode() {
    var targetSideMenuWidth: CGFloat = 0
    var targetPostListWidth: CGFloat = 0
    storePanelDimensions()
    
    if _editing {
      targetSideMenuWidth = self._sideMenuWidth
      targetPostListWidth = self._postListWidth
    }
    
    UIView.animate(withDuration: Constants.animationDuration, animations: {
      self.sideMenuWidthConstraint.constant = targetSideMenuWidth
      self.postListWidthConstraint.constant = targetPostListWidth
      self.view.layoutIfNeeded()
    })
    _editing = !_editing
  }
  
  // MARK: lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // initial layout
    infoLeftConstraint.constant = self.view.bounds.size.width
    sideMenuWidthConstraint.constant = 0
    
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }
  
  //
  // resize the four main panes (settings, posts, edit, info) to reflect the keyboard state
  //
  @objc private func keyboardNotification(notification: NSNotification) {
    if let userInfo = notification.userInfo {
      let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      let keyboardHeight = endFrame!.size.height
      let duration: TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
      sideMenuBottomConstraint.constant = keyboardHeight
      postListBottomConstraint.constant = keyboardHeight
      editPaneBottomConstraint.constant = keyboardHeight
      infoPaneBottomConstraint.constant = keyboardHeight

      UIView.animate(withDuration: duration) {
        self.view.layoutIfNeeded()
      }
    }
  }
  
  func toggleFullEditMode() {
    if _fullEditMode {
      sideMenuWidthConstraint.constant = _sideMenuWidth
      postListWidthConstraint.constant = _postListWidth
    } else {
      storePanelDimensions()
      sideMenuWidthConstraint.constant = 0
      postListWidthConstraint.constant = 0
    }
    
    _fullEditMode = !_fullEditMode
  }
  
  //
  // we need a way for (a) all the various child views to perform things globally and share data,
  // (b) for the containing view to keep track of specific children
  // an Embed segue fires for each of the child views, so we'll use the segue as a hook to
  // store the necessary references. Each child is a subclass of GhostBaseDetailViewController, which
  // includes a containerViewController attribute to hook back to the parent. Is there a better way
  // to do this?
  //
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let segueIdentifier = segue.identifier
    let destination = segue.destination
    
    // this is a little hacky
    // some of the views we're interested in are embedded in NavigationControllers, so we have
    // to drill down into the childViewControllers collection for those
    switch(segueIdentifier) {
    case "sidebar":
      (destination as! GhostBaseDetailViewController).containerViewController = self
    case "postList":
      (destination.childViewControllers[0] as! GhostBaseDetailViewController).containerViewController = self
    case "edit":
      (destination.childViewControllers[0] as! GhostBaseDetailViewController).containerViewController = self
      editPostViewController = destination.childViewControllers[0] as? EditPostViewController
    case "info":
      (destination as! GhostBaseDetailViewController).containerViewController = self
      infoViewController = destination as? PostInfoViewController
    case "preview":
      (destination.childViewControllers[0] as! GhostBaseDetailViewController).containerViewController = self
      previewViewController = destination.childViewControllers[0] as? PreviewViewController
    default:
      break
    }
  }
  
  //
  // MARK: private parts
  //
  private func storePanelDimensions() {
    _sideMenuWidth = sideMenuWidthConstraint.constant
    _postListWidth = postListWidthConstraint.constant
  }
}
