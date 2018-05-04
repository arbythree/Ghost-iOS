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
  @IBOutlet weak var editPostViewController: EditPostViewController?
  
  // show/hide the side menu on the far left
  @IBAction func toggleSideMenu() {
    let targetWidth: CGFloat = sideMenuWidthConstraint.constant == 0 ? 240 : 0
    sideMenuWidthConstraint.constant = targetWidth
  }
  
  @IBAction func togglePreview() {
    let targetWidth: CGFloat = previewWidthConstraint.constant == 0 ? 240 : 0
    previewWidthConstraint.constant = targetWidth
  }
  
  // show/hide the Info panel on the far right
  @IBAction func toggleInfo() {
    let targetWidth: CGFloat = infoWidthConstraint.constant == 0 ? 210 : 0
    infoWidthConstraint.constant = targetWidth
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
  
  @IBAction func toggleEditMode() {
    var targetSideMenuWidth: CGFloat = 0
    var targetPostListWidth: CGFloat = 0
    storePanelDimensions()

    if _editing {
      targetSideMenuWidth = self._sideMenuWidth
      targetPostListWidth = self._postListWidth
    }

    UIView.animate(withDuration: Constants.AnimationDuration, animations: {
      self.sideMenuWidthConstraint.constant = targetSideMenuWidth
      self.postListWidthConstraint.constant = targetPostListWidth
      self.view.layoutIfNeeded()
    })
    _editing = !_editing
  }
  
  func storePanelDimensions() {
    _sideMenuWidth = sideMenuWidthConstraint.constant
    _postListWidth = postListWidthConstraint.constant
  }
}
