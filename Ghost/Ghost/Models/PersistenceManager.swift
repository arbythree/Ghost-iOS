//
//  PersistenceManager.swift
//  Ghost
//
//  Created by Ray Bradley on 5/2/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation

class PersistenceManager {
  class func save(object: Any?) {
    if object is Post { savePost(object: object as! Post) }
    if object is Tag { }
  }
  
  class func all(object: Any?) {
    
  }
  
  class func savePost(object: Post) {
    
  }
}
