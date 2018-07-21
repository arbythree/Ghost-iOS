//
//  PostSerializer.swift
//  Ghost
//
//  Created by Ray Bradley on 5/3/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation

// class for persisting and rehydrating Post objects
class PostSerializer {
  class func serialize(post: Post) -> [String: Any] {
    var result: [String: Any] = [:]
    
    if !post.new {
      result["id"]      = post.id
    }
    result["title"]     = post.title
    result["mobiledoc"] = post.mobiledoc
    result["status"]    = post.status
    
    var tagArray: [[String: String]] = []
    
    post.tags.forEach { tag in
      var tagDict: [String: String] = [:]
//      tagDict["id"] = tag.id
      tagDict["name"] = tag.name
      tagArray.append(tagDict)
    }
    
    result["tags"] = tagArray
    
    return result
  }
  
  // this part of the Ghost API isn't documented
  // I/Ray relied on the Android code base
  // and inspecting XHR requests in the browser
  class func save(post: Post) {
    let client = GhostRESTClient.shared
    let serialized = PostSerializer.serialize(post: post)
    let serializedArray = [serialized]
    let params = ["posts": serializedArray]
    
    if post.new {
      client.post(
        path: "/posts",
        parameters: params,
        success: { result in
          //TODO: handle this
        },
        failure: {
          //TODO: handle this
        }
      )
    } else {
      client.put(
        path: "/posts/\(post.id)",
        parameters: params,
        success: { (result) in
          //TODO: handle this
        },
        failure: {
          //TODO: handle this
        }
      )
    }
  }
  
  class func delete(post: Post) {
    let client = GhostRESTClient.shared
    client.delete(
      path: "/posts/\(post.id)",
      success: { () in },
      failure: { }
    )
  }
  
  // given an existing Post object, populate its attributes from a JSON dictionary
  class func populateFromJSON(post: Post, json: NSDictionary) {
    let formatter = DateFormatter();
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    post.id     = json["id"]     as! String
    post.title  = json["title"]  as! String
    post.status = json["status"] as! String
    if json["custom_excerpt"] is NSNull {
    } else {
      post.excerpt = json["custom_excerpt"] as! String
    }

    // author
    let authorJSON = json["author"] as! NSDictionary;
    post.author = authorJSON["name"] as! String;

    // tags
    post.tags = []
    
    let tagsJSON = json["tags"] as! [[String: Any]];
    for tagJSON in tagsJSON {
      let tag = Tag()
      tag.id = tagJSON["id"] as! String;
      tag.name = tagJSON["name"] as! String;
      post.tags.append(tag);
    }
    
    // pull dates
    let ua = json["updated_at"] as! String;
    post.updated_at = formatter.date(from: ua)!;
    
    let ca = json["created_at"] as! String;
    post.created_at = formatter.date(from: ca)!;
    
    let pa = json["published_at"];
    if pa is NSNull {
      
    } else {
      post.published_at = formatter.date(from: pa as! String)!;
    }
  }
  
  class func mobiledocToMarkdown(_ mobiledoc: String) -> String? {
    let data = mobiledoc.data(using: .utf8)
    do {
      let json = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
      let cardsJSON = json["cards"] as! NSArray
      let markdownCardJSON = (cardsJSON[0] as! NSArray)[1] as! NSDictionary
      let markdown = markdownCardJSON["markdown"]
      return markdown as? String
    } catch let error as NSError {
      print(error.localizedDescription)
    }
    
    return nil
  }
}

// sample mobiledoc:
//
//  "{" +
//  "  \"version\": \"0.3.1\"," +
//  "  \"markups\": []," +
//  "  \"atoms\": []," +
//  "  \"cards\": [" +
//  "    [\"card-markdown\", {" +
//  "      \"cardName\": \"card-markdown\"," +
//  "      \"markdown\": \"\(escapedMarkdown)\"" +
//  "    }]" +
//  "  ]," +
//  "  \"sections\": [[10, 0]]" +
//"}"
//
