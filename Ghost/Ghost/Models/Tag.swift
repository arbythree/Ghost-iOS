//
//  Tag.swift
//  Ghost
//
//  Created by Ray Bradley on 4/30/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation

class Tag {
  class func all(success: @escaping ([Tag]) -> Void) -> Void {
    let client = GhostRESTClient();
    
    let params: Dictionary = [ "limit": "all" ];
    
    client.getJSON(path: "/tags/", parameters: params, completionHandler: { responseJSON in
      let tagsJSON = responseJSON["tags"] as! NSArray;
      var tags: [Tag] = [];
      for tagJSON in tagsJSON {
        let tag = Tag(json: tagJSON as! NSDictionary);
        tags.append(tag);
      }
      success(tags);
    });
  }
  
  init(json: NSDictionary) {
    
  }
}
