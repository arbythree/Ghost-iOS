//
//  PostIndexViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 4/24/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class ContentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  var posts: [Post] = [];
  var selectedPost: Post?;
  @IBOutlet var tableView: UITableView!;
  
  override func viewDidLoad() {
    Post.all(success: { posts in
      self.posts = posts;
      self.tableView.reloadData();
    });
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count;
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell;
    cell.setPost(value: posts[indexPath.row]);
    return cell;
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedPost = posts[indexPath.row];
    performSegue(withIdentifier: "editPostSegue", sender: self);
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let editViewController = segue.destination as! EditPostViewController;
    editViewController.setPost(value: selectedPost!);
  }
}
