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

enum PostStatus : String {
  case Draft = "draft", Published = "published"
}

class Post {
  var id:           String = "";
  var title:        String = "";
  var author:       String = "";
  var status:       String = "";
  var excerpt:      String = "";
  var markdown:     String?
  var tagNames:     [String] = [];
  var updated_at:   Date = Date();
  var created_at:   Date = Date();
  var published_at: Date?;
  var published: Bool! {
    get {
      return status == PostStatus.Published.rawValue;
    }
  }
  
  var new: Bool! {
    get {
      return id == ""
    }
  }
  
  var isDraft: Bool! {
    get {
      return status == PostStatus.Draft.rawValue
    }
  }
  
  var isPublished: Bool! {
    get {
      return status == PostStatus.Published.rawValue
    }
  }
  
  init(json: NSDictionary) {
    PostSerializer.populateFromJSON(post: self, json: json)
  }
  
  init() {
    title = NSLocalizedString("NEW_POST_TITLE", comment: "")
    markdown = ""
    status = PostStatus.Draft.rawValue
  }
  
  //
  // liberal inspiration from https://github.com/TryGhost/Ghost-Android/blob/8f31cefbf3caed339cf00726872d131eb2ddefa2/app/src/main/java/me/vickychijwani/spectre/network/GhostApiUtils.java
  //
  
  //
  // TODO: move this out to a new class (MobileDocSerializer?)
  //
  var mobiledoc: String? {
    get {
      let escapedMarkdown = markdown?
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
        "      \"markdown\": \"\(escapedMarkdown!)\"" +
        "    }]" +
        "  ]," +
        "  \"sections\": [[10, 0]]" +
      "}"
    }
  }
  
  //
  // return all Posts
  //
  class func all(success: @escaping ([Post]) -> Void) {
    let client = GhostRESTClient();
    let params: Parameters = [
      "status" : "all",
      "include" : "author, tags",
    ];
    
    // TODO: move this out to the PostSerializer
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
  
  // TODO: move this out to the PostSerializer
  func reload(success: @escaping () -> Void) {
    if new {
      success()
      return
    }
    
    let client = GhostRESTClient()
    let params: Parameters = [ "formats": "html, plaintext, mobiledoc", "status": "all" ]
    client.getJSON(path: "/posts/\(id)/", parameters: params, completionHandler: { responseJSON in
      let postsJSON = responseJSON["posts"] as! NSArray
      let postJSON = postsJSON[0] as! NSDictionary
      let mobiledoc = postJSON["mobiledoc"] as! String
      self.markdown = PostSerializer.mobiledocToMarkdown(mobiledoc)
      success()
    });
  }
  
  func save() {
    PostSerializer.save(post: self)
  }
  
  func destroy() {
    PostSerializer.delete(post: self)
  }
}
