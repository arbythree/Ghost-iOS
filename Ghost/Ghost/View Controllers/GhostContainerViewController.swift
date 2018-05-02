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
  @IBOutlet weak var editPostViewController: EditPostViewController?
  
  @IBAction func toggleSideMenu() {
    let targetWidth: CGFloat = sideMenuWidthConstraint.constant == 0 ? 240 : 0
    sideMenuWidthConstraint.constant = targetWidth
  }
  
  @IBAction func togglePreview() {
    let targetWidth: CGFloat = previewWidthConstraint.constant == 0 ? 240 : 0
    previewWidthConstraint.constant = targetWidth
  }
  
  func toggleInfo() {
    
  }
  
  @IBAction func enterFullEditMode() {
    storePanelDimensions()
    self.sideMenuWidthConstraint.constant = 0
    self.postListWidthConstraint.constant = 0
  }
  
  @IBAction func toggleEditMode() {
    var targetSideMenuWdith: CGFloat = 0
    var targetPostListWidth: CGFloat = 0
    storePanelDimensions()

    if _editing {
      targetSideMenuWdith = self._sideMenuWidth
      targetPostListWidth = self._postListWidth
    }

    UIView.animate(withDuration: Constants.AnimationDuration, animations: {
      self.sideMenuWidthConstraint.constant = targetSideMenuWdith
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
