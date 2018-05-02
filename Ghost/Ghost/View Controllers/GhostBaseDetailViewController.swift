//
//  GhostDetailViewController.swift
//  Ghost
//
//  Created by Ray Bradley on 5/1/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import UIKit

class GhostBaseDetailViewController: UIViewController {
  var containerViewController: GhostContainerViewController {
    get {
      var candidate = self.parent
      while true {
        if let result = candidate as? GhostContainerViewController {
          return result
        }
        candidate = candidate!.parent
      }
    }
  }
}

