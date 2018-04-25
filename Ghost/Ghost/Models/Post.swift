//
//  Post.swift
//  Ghost
//
//  Created by Ray Bradley on 4/24/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import Alamofire

class Post {
  var title: String = "";
  
  class func all(success: @escaping ([Post]) -> Void) -> Void {
    let client = GhostRESTClient();
    
    client.getJSON(url: "/posts/", completionHandler: { responseJSON in
      let postsJSON = responseJSON["posts"] as! NSArray;
      var posts: [Post] = [];
      for postJSON in postsJSON {
        let post = Post(json: postJSON as! NSDictionary);
        posts.append(post);
      }
      success(posts);
    });
  }
  
  init(json: NSDictionary) {
    title = json["title"] as! String;
  }
}
