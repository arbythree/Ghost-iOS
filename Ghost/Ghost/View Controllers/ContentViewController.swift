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
    let cell = tableView.dequeueReusableCell(withIdentifier: "postCell")!;
    cell.textLabel!.text = posts[indexPath.row].title;
    return cell;
  }
}
