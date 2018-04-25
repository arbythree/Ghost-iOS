//
//  PostTableViewCell.swift
//  Ghost
//
//  Created by Ray Bradley on 4/25/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class PostTableViewCell: UITableViewCell {
  var post: Post?
  @IBOutlet var titleLabel:  UILabel!;
  @IBOutlet var authorLabel: UILabel!;
  
  func setPost(value: Post) {
    post = value;
    titleLabel.text = value.title;
    authorLabel.text = value.author;
  }
}
