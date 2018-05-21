//
//  TagSerializer.swift
//  Ghost
//
//  Created by Ray Bradley on 5/14/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation

class TagSerializer {
  class func populateFromJSON(tag: Tag, json: NSDictionary) {
    tag.id = json["id"] as! String
    tag.name = json["name"] as! String
  }
}
