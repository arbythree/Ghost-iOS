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
  @IBOutlet weak var infoWidthConstraint:     NSLayoutConstraint!
  @IBOutlet weak var sideMenuContainer: UIView!
  @IBOutlet weak var postListContainer: UIView!
  @IBOutlet weak var editPaneContainer: UIView!
  @IBOutlet weak var previewContainer:  UIView!
  private var _sideMenuWidth: CGFloat = 0
  private var _postListWidth: CGFloat = 0
  private var _editing = false
  private var _fullEditMode = false
  var editPostViewController: EditPostViewController?
  var previewViewController: PreviewViewController?
  
  // MARK: IBActions
  // show/hide the side menu on the far left
  @IBAction func toggleSideMenu() {
    let targetWidth: CGFloat = sideMenuWidthConstraint.constant == 0 ? 240 : 0
    sideMenuWidthConstraint.constant = targetWidth
  }
  
  // show/hide the Info panel on the far right
  @IBAction func toggleInfo() {
    let targetWidth: CGFloat = infoWidthConstraint.constant == 0 ? 210 : 0
    infoWidthConstraint.constant = targetWidth
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
    infoWidthConstraint.constant = 0
    sideMenuWidthConstraint.constant = 0
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
