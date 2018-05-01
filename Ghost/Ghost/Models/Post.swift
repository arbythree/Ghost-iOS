//
//  Post.swift
//  Ghost
//
//  Created by Ray Bradley on 4/24/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//
//  Typical REST call
//  https://theojisan.com/ghost/api/v0.1/posts/?limit=30&page=1&status=all&staticPages=all&formats=mobiledoc,plaintext&include=tags

import Foundation
import Alamofire

class Post {
  var id:           String = "";
  var title:        String = "";
  var author:       String = "";
  var status:       String = "";
  var markdown:     String = "";
  var tags:         String = "";
  var updated_at:   Date = Date();
  var created_at:   Date = Date();
  var published_at: Date?;
  var published: Bool! {
    get {
      return status == "published";
    }
  }
  var new: Bool! {
    get {
      return id == ""
    }
  }
  
  class func all(success: @escaping ([Post]) -> Void) -> Void {
    let client = GhostRESTClient();
    let params: Parameters = [
      "status" : "all",
      "include" : "author, tags",
//      "fields" : "id, title, status, author, tags"
    ];
    
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
  
  func reload(success: @escaping () -> Void) {
    let client = GhostRESTClient();
    let params: Parameters = [
      "formats": "html, plaintext, mobiledoc"
    ];
    client.getJSON(path: "/posts/\(id)/", parameters: params, completionHandler: { responseJSON in
      let postsJSON = responseJSON["posts"] as! NSArray;
      let postJSON = postsJSON[0] as! NSDictionary;
      self.markdown = postJSON["plaintext"] as! String;
      success();
    });
  }
  
  func save() {
    
  }
  
  init(json: NSDictionary) {
    let formatter = DateFormatter();
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    id     = json["id"]     as! String;
    title  = json["title"]  as! String;
    status = json["status"] as! String;
//    markdown = json["plaintext"] as! String;
    
    let authorJSON = json["author"] as! NSDictionary;
    author = authorJSON["name"] as! String;
    
    var tagNames: [String] = [];
    let tagsJSON = json["tags"] as! [[String: Any]];
    for tagJSON in tagsJSON {
      tagNames.append(tagJSON["name"] as! String);
    }
    tags = tagNames.joined(separator: ", ")
    
    // pull dates
    let ua = json["updated_at"]   as! String;
    updated_at = formatter.date(from: ua)!;
    
    let ca = json["created_at"]   as! String;
    created_at = formatter.date(from: ca)!;
  
    let pa = json["published_at"];
    if pa is NSNull {
      
    } else {
      published_at = formatter.date(from: pa as! String)!;
    }
  }
}
