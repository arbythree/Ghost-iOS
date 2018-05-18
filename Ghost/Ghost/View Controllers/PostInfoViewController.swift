//
//  PostInfoViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 5/3/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class PostInfoViewController: GhostBaseDetailViewController, UITableViewDataSource, UITableViewDelegate {
  private var _tags: [Tag] = []
  var post: Post = Post() {
    didSet {
      tableView.reloadData()
    }
  }
  
  @IBOutlet weak var tableView: UITableView!
  
  @IBAction func save() {
    containerViewController?.editPostViewController?.save()
  }
  
  @IBAction func delete() {
    containerViewController?.editPostViewController?.delete()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.shadowColor = UIColor.black.cgColor
    
    Tag.all { tags in
      self._tags = tags
    }
  }
  
  @IBAction func hide() {
    containerViewController?.toggleInfo()
  }
  
  // MARK: delegates
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch(section) {
    case 0:
      return 3
    case 1:
      return _tags.count
    default:
      return 0
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // if it was a tag
    if indexPath.section == 1 {
      let cell = tableView.cellForRow(at: indexPath)!
      let tagName = cell.textLabel!.text!
      let isChecked = cell.accessoryType == UITableViewCellAccessoryType.checkmark
      
      if isChecked {
        cell.accessoryType = .none
        if !post.tagNames.contains(tagName) {
          post.tagNames.append(tagName)
        }
      } else {
        cell.accessoryType = .checkmark
        post.tagNames = post.tagNames.filter() { $0 != tagName } // remove the tapped tagName
      }
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    
    switch(indexPath.section) {
    case 0:
      switch(indexPath.row) {
      case 0:
        cell = tableView.dequeueReusableCell(withIdentifier: "postEditCellSingleLine")!
        (cell as! PostInfoEditCell).valueTextField.text = post.title
      case 1:
        cell = tableView.dequeueReusableCell(withIdentifier: "postEditCellMultiLine")!
        (cell as! PostInfoEditCellMultiLine).valueTextView.text = post.excerpt
      case 2:
        cell = tableView.dequeueReusableCell(withIdentifier: "postInfoStatus")!
        (cell as! PostInfoStatusCell).datePicker.date = Date()
        var segmentIndex = 0
        if post.isDraft {
          segmentIndex = 2
        }
        (cell as! PostInfoStatusCell).statusSegmentView.selectedSegmentIndex = segmentIndex
      default:
        break
      }
      
    // tags section
    case 1:
      cell = tableView.dequeueReusableCell(withIdentifier: "postInfoTag")!
      let tagName = self._tags[indexPath.row].name
      cell.textLabel?.text = tagName
      if post.tagNames.contains(tagName) {
        cell.accessoryType = .checkmark
      }
      
    default:
      break;
    }
    
    (cell as! PostInfoBaseCell).post = self.post
    (cell as! PostInfoBaseCell).postInfoViewController = self
    return cell
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch(section) {
    case 0:
      return "Settings"
    case 1:
      return "Tags"
    default:
      return ""
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch(indexPath.section) {
    case 0:
      switch(indexPath.row) {
      case 0:
        return 72  // title
      case 1:
        return 80  // excerpt
      case 2:
        return 50  // status
      default:
        return 44
      }
    case 1:
      return 44
    default:
      return 44
    }
  }
}
