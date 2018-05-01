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
  func containerViewController() -> GhostContainerViewController {
    return self.parent!.parent! as! GhostContainerViewController
  }
}

