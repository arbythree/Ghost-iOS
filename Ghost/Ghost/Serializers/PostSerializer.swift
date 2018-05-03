//
//  PostSerializer.swift
//  Ghost
//
//  Created by Ray Bradley on 5/3/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation

class PostSerializer {
  class func serialize(post: Post) -> [String: Any] {
    var result: [String: Any] = [:]
    
    result["title"]     = post.title
    result["mobiledoc"] = post.mobiledoc
    result["status"]    = post.status
    
    return result
  }
  
  class func save(post: Post) {
    let client = GhostRESTClient()
    let serialized = PostSerializer.serialize(post: post)
    let serializedArray = [serialized]
    let params = ["posts": serializedArray]
    client.put(
      path: "/posts/\(post.id)",
      parameters: params,
      success: { (result) in
        
      },
      failure: {
        
      }
    )
  }
  
  class func populateFromJSON(post: Post, json: NSDictionary) {
    let formatter = DateFormatter();
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    post.id     = json["id"]     as! String;
    post.title  = json["title"]  as! String;
    post.status = json["status"] as! String;
    
    let authorJSON = json["author"] as! NSDictionary;
    post.author = authorJSON["name"] as! String;
    
    var tagNames: [String] = [];
    let tagsJSON = json["tags"] as! [[String: Any]];
    for tagJSON in tagsJSON {
      tagNames.append(tagJSON["name"] as! String);
    }
    post.tags = tagNames.joined(separator: ", ")
    
    // pull dates
    let ua = json["updated_at"]   as! String;
    post.updated_at = formatter.date(from: ua)!;
    
    let ca = json["created_at"]   as! String;
    post.created_at = formatter.date(from: ca)!;
    
    let pa = json["published_at"];
    if pa is NSNull {
      
    } else {
      post.published_at = formatter.date(from: pa as! String)!;
    }
  }
}


//public PostStub(@NonNull Post post) {
//  this.title = post.getTitle();
//  this.slug = post.getSlug();
//  this.status = post.getStatus();
//  this.mobiledoc = post.getMobiledoc();
//  this.tags = new ArrayList<>(post.getTags().size());
//  for (Tag tag : post.getTags()) {
//    this.tags.add(new TagStub(tag));
//  }
//  this.featureImage = post.getFeatureImage();
//  this.featured = post.isFeatured();
//  this.page = post.isPage();
//  this.customExcerpt = post.getCustomExcerpt();
//}
