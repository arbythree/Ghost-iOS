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
  var author: String = "";
  var status: String = "";
  var updated_at: Date = Date();
  var created_at: Date = Date();
  var published_at: Date = Date();
  
  class func all(success: @escaping ([Post]) -> Void) -> Void {
    let client = GhostRESTClient();
    
    client.getJSON(path: "/posts/", completionHandler: { responseJSON in
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
    let formatter = DateFormatter();
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    let ua = json["updated_at"]   as! String;
    let pa = json["published_at"] as! String;
    let ca = json["created_at"]   as! String;
    
    title  = json["title"]  as! String;
    author = json["author"] as! String;
    status = json["status"] as! String;
    
    updated_at   = formatter.date(from: ua)!;
    published_at = formatter.date(from: pa)!;
    created_at   = formatter.date(from: ca)!;
  }
}
