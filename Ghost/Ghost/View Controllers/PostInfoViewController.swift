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
  }
  
  @IBAction func hide() {
    containerViewController?.toggleInfo()
  }
  
  // MARK: delegates
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell = UITableViewCell()
    
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
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch(indexPath.row) {
    case 0:
      return 72
    case 1:
      return 80
    case 2:
      return 50
    default:
      return 44
    }
  }
}
