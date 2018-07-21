//
//  Tag.swift
//  Ghost
//
//  Created by Ray Bradley on 4/30/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation

class User {
  class func all(success: @escaping ([User]) -> Void) -> Void {
    let client = GhostRESTClient.shared
    
    let params: Dictionary = [ "limit": "all" ]
    
    client.getJSON(path: "/users/", parameters: params, completionHandler: { responseJSON in
      let tagsJSON = responseJSON["users"] as! NSArray
      var users: [User] = []
      for tagJSON in tagsJSON {
        let user = User(json: tagJSON as! NSDictionary)
        users.append(user)
      }
      success(users)
    });
  }
  
  init(json: NSDictionary) {
    
  }
}
