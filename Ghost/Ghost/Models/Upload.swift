//
//  Upload.swift
//  Ghost
//
//  Created by Ray Bradley on 5/2/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation

// represents a file upload (typically an image from the device's library)
class Upload {
  func save() {
    let client = GhostRESTClient()
    client.post(path: "/uploads", parameters: [:], success: { (response) in
      
    }, failure: {
      
    })
  }
}
