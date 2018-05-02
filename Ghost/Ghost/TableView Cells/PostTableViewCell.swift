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
  var post: Post? {
    didSet {
      self.selectedBackgroundView?.backgroundColor = UIColor(white: 0.0, alpha: 0.1)

      if post == nil {
        return
      }
      
      titleLabel.text = post?.title;
      authorLabel.text = post?.author;
      if post!.published {
        statusBadgeWidthConstraint.constant = 0;
        authorLabelPaddingConstraint.constant = 0;
      }
    }
  }
  @IBOutlet weak var titleLabel:  UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var statusBadgeWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var authorLabelPaddingConstraint: NSLayoutConstraint!
  

  override func layoutSubviews() {
    super.layoutSubviews()
    self.selectedBackgroundView?.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
  }
}
