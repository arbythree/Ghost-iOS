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
        // hide the pill
        statusBadgeWidthConstraint.constant = 0;
        authorLabelPaddingConstraint.constant = 0;
      } else if post!.isDraft {
        // show the pill in red
        self.statusBadge.backgroundColor = UIColor(named: "ghostRed")
        self.statusBadge.text = "Draft"
        self.statusBadge.sizeToFit()
      } else if post!.isScheduled {
        // show the pill in green
        self.statusBadge.backgroundColor = UIColor(named: "ghostGreen")
        self.statusBadge.text = "Scheduled"
        self.statusBadge.sizeToFit()
      }
    }
  }
  @IBOutlet weak var titleLabel:  UILabel!
  @IBOutlet weak var authorLabel: UILabel!
  @IBOutlet weak var ageLabel: UILabel!
  @IBOutlet weak var statusBadgeWidthConstraint: NSLayoutConstraint!
  @IBOutlet weak var authorLabelPaddingConstraint: NSLayoutConstraint!
  @IBOutlet weak var selectedView: UIView!
  @IBOutlet weak var statusBadge: UILabel!
}
