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
  var id: String = "";
  var title: String = "";
  var author: String = "";
  var status: String = "";
  var markdown: String = "";
  var updated_at: Date = Date();
  var created_at: Date = Date();
  var published_at: Date = Date();
  
//  https://theojisan.com/ghost/api/v0.1/posts/?limit=30&page=1&status=all&staticPages=all&formats=mobiledoc,plaintext&include=tags
  
  class func all(success: @escaping ([Post]) -> Void) -> Void {
    let client = GhostRESTClient();
    
    let params: Parameters = [
      "status": "all"
    ]
    
    client.getJSON(path: "/posts/", parameters: params, completionHandler: { responseJSON in
      let postsJSON = responseJSON["posts"] as! NSArray;
      var posts: [Post] = [];
      for postJSON in postsJSON {
        let post = Post(json: postJSON as! NSDictionary);
        posts.append(post);
      }
      success(posts);
    });
  }
  
  func reload() {
    let client = GhostRESTClient();
    let params: Parameters = [
      "formats": "html, plaintext, mobiledoc"
    ];
    client.getJSON(path: "/posts/\(id)/", parameters: params, completionHandler: { responseJSON in
      let postsJSON = responseJSON["posts"] as! NSArray;
      let postJSON = postsJSON[0] as! NSDictionary;
      self.markdown = postJSON["plaintext"] as! String;
    });
  }
  
  func isPublished() -> Bool {
    return status == "published";
  }
  
  func isNew() -> Bool {
    return id == "";
  }
  
  init() { }
  
  init(json: NSDictionary) {
    let formatter = DateFormatter();
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    let ua = json["updated_at"]   as! String;
//    let pa = json["published_at"] as! String;
    let ca = json["created_at"]   as! String;
    
    id     = json["id"] as! String;
    title  = json["title"]  as! String;
    author = json["author"] as! String;
    status = json["status"] as! String;
    
    updated_at   = formatter.date(from: ua)!;
//    published_at = formatter.date(from: pa)!;
    created_at   = formatter.date(from: ca)!;
  }
}
