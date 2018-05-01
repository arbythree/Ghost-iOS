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
  @IBOutlet weak var sideMenuContainer: UIView!
  @IBOutlet weak var postListContainer: UIView!
  @IBOutlet weak var editPaneContainer: UIView!
  @IBOutlet weak var previewContainer:  UIView!
  private var _sideMenuWidth: CGFloat = 0
  private var _postListWidth: CGFloat = 0
  private var _editing = false
  
  @IBAction func toggleSideMenu() {
    let targetWidth: CGFloat = sideMenuWidthConstraint.constant == 0 ? 240 : 0
    sideMenuWidthConstraint.constant = targetWidth
  }
  
  @IBAction func togglePreview() {
    let targetWidth: CGFloat = previewWidthConstraint.constant == 0 ? 240 : 0
    previewWidthConstraint.constant = targetWidth
  }
  
  @IBAction func toggleEditMode() {
    if _editing {
      sideMenuWidthConstraint.constant = _sideMenuWidth
      postListWidthConstraint.constant = _postListWidth
      _editing = false
    } else {
      _sideMenuWidth = sideMenuWidthConstraint.constant
      _postListWidth = postListWidthConstraint.constant
      sideMenuWidthConstraint.constant = 0
      postListWidthConstraint.constant = 0
      _editing = true
    }
  }
}
