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
  
  //
  // liberal inspiration from https://github.com/TryGhost/Ghost-Android/blob/8f31cefbf3caed339cf00726872d131eb2ddefa2/app/src/main/java/me/vickychijwani/spectre/network/GhostApiUtils.java
  //
  var mobiledoc: String {
    get {
      let escapedMarkdown = markdown
        .replacingOccurrences(of: "\\", with: "\\\\")
        .replacingOccurrences(of: "\"", with: "\\\"")
        .replacingOccurrences(of: "\n", with: "\\n")
//        .replacingOccurrences(of: "\t", with: "\\\t")
//        .replacingOccurrences(of: "\r", with: "\\\r")
      
      return "{" +
        "  \"version\": \"0.3.1\"," +
        "  \"markups\": []," +
        "  \"atoms\": []," +
        "  \"cards\": [" +
        "    [\"card-markdown\", {" +
        "      \"cardName\": \"card-markdown\"," +
        "      \"markdown\": \"\(escapedMarkdown)\"" +
        "    }]" +
        "  ]," +
        "  \"sections\": [[10, 0]]" +
      "}"
    }
  }
  
  init(json: NSDictionary) {
    PostSerializer.populateFromJSON(post: self, json: json)
  }
  
  class func all(success: @escaping ([Post]) -> Void) -> Void {
    let client = GhostRESTClient();
    let params: Parameters = [
      "status" : "all",
      "include" : "author, tags",
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
    let client = GhostRESTClient()
    let params: Parameters = [ "formats": "html, plaintext, mobiledoc" ]
    client.getJSON(path: "/posts/\(id)/", parameters: params, completionHandler: { responseJSON in
      let postsJSON = responseJSON["posts"] as! NSArray;
      let postJSON = postsJSON[0] as! NSDictionary;
      self.markdown = postJSON["plaintext"] as! String;
      success();
    });
  }
  
  func save() {
    PostSerializer.save(post: self)
  }
}
