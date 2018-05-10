//
//  PostIndexViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 4/24/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class PostListViewController: GhostBaseDetailViewController, UITableViewDelegate, UITableViewDataSource {
  private var _posts: [Post] = [];
  private var _selectedPost: Post?;
  @IBOutlet weak var tableView: UITableView!;
  
  override func viewDidLoad() {
    Post.all(success: { posts in
      self._posts = posts
      self.tableView.reloadData()
      
      // select the first cell
      if posts.count > 0 {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        self.tableView(self.tableView, didSelectRowAt: indexPath)
      }
    })
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return _posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell;
    let post = _posts[indexPath.row]
    cell.post = post
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
    cell.selectedView.isHidden = false
    _selectedPost = _posts[indexPath.row]
    containerViewController?.editPostViewController?.post = _selectedPost
  }
  
  func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
    cell.selectedView.isHidden = true
  }
  
  @IBAction func toggleSettings() {
    self.containerViewController?.toggleSideMenu()
  }
}
