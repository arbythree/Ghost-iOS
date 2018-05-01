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
  var posts: [Post] = [];
  var selectedPost: Post?;
  
  @IBOutlet var tableView: UITableView!;
  
  override func viewDidLoad() {
    Post.all(success: { posts in
      self.posts = posts
      self.tableView.reloadData()
    })
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell;
    let post = posts[indexPath.row]
    cell.post = post
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedPost = posts[indexPath.row]
    let editViewController = self.splitViewController?.viewControllers[1] as! EditPostViewController
    editViewController.post = selectedPost
  }
}
