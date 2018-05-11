//
//  GhostRESTClient.swift
//  Ghost
//
//  Created by Ray Bradley on 4/25/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import Foundation
import Alamofire
import KeychainSwift

class GhostRESTClient {
  var baseURL: String? {
    didSet {
      if baseURL == nil {
        return
      }
      
      // strip trailing
      while baseURL?.last == "/" {
        let stripped = baseURL!.dropLast()
        baseURL = String(stripped)
      }
      
      let keychain = KeychainSwift();
      keychain.set(baseURL!, forKey: "baseURL")
    }
  }

  init() {
    let keychain = KeychainSwift();
    baseURL = keychain.get("baseURL")
    
    let configuration = URLSessionConfiguration.ephemeral
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    _ = Alamofire.SessionManager(configuration: configuration)
  }
  
  func fullURL(path: String) -> String {
    var cleanPath = path
    if path.first != "/" {
      cleanPath = "/" + path
    }
    return "\(baseURL!)/ghost/api/v0.1\(cleanPath)";
  }
  
  func authorizationHeader() -> HTTPHeaders {
    let mgr = AuthenticationManager.sharedManager;
    let headers: HTTPHeaders = [
      "Authorization": "Bearer \(mgr.token!)"
    ]
    return headers
  }
  
  func getJSON(path: String, parameters: [String: Any], completionHandler: @escaping (_ : NSDictionary) -> Void) {
    Alamofire.request(fullURL(path: path), parameters: parameters, headers: authorizationHeader()).responseJSON { response in
      let status = response.response?.statusCode;
      if (status == 200) {
        let json = response.result.value as! NSDictionary;
        completionHandler(json);
      }
    }
  }
  
  func post(path: String, parameters: [String: Any], success: @escaping (HTTPURLResponse) -> Void, failure: @escaping () -> Void) {
    Alamofire.request(fullURL(path: path), method: .post, parameters: parameters, headers: authorizationHeader()).responseJSON { response in
      let status = response.response?.statusCode;
      if (status == 201) {
        success(response.response!)
      } else {
        failure()
      }
    }
  }
  
  func put(path: String, parameters: [String: Any], success: @escaping (NSDictionary) -> Void, failure: @escaping () -> Void) {
    Alamofire.request(fullURL(path: path), method: .put, parameters: parameters, headers: authorizationHeader()).responseJSON { response in
      let status = response.response?.statusCode;
      if (status == 200) {
        let json = response.result.value as! NSDictionary;
        success(json)
      } else {
        failure()
      }
    }
  }
  
  func delete(path: String, success: @escaping () -> Void, failure: @escaping () -> Void) {
    Alamofire.request(fullURL(path: path), method: .delete, headers: authorizationHeader()).responseJSON { response in
      
    }
  }
  
  func upload(imageData: Data, name: String, success: @escaping (String) -> Void, failure: @escaping () -> Void) {
    let url = URL(string: fullURL(path: "/uploads"))!
    var headers = authorizationHeader()
    headers["Content-Type"] = "multipart/form-data"
    
    Alamofire.upload(
      multipartFormData: { (multipartFormData) in
        multipartFormData.append(imageData, withName: "uploadimage", fileName: "\(name).jpg", mimeType: "image/jpeg")
      },
      usingThreshold: UInt64.init(),
      to: url,
      method: .post,
      headers: headers,
      encodingCompletion: { (result) in
        switch(result) {
        case .success(let upload, _, _):
          upload.responseString(completionHandler: { (response) in
            success(String(decoding: response.data!, as: UTF8.self))
          })
          break
        case .failure(let error):
          print("Error during upload: \(error.localizedDescription)")
          break
        }
      }
    )
  }
  
  //
  // hackety-hack...it's not entirely clear how or why the client secret is supposed to work. It looks like we can
  // just hit the /configuration public endpoint end get it. Not very secret?
  //
  func fetchAuthToken(username: String, password: String, success: @escaping (String) -> Void, failure:() -> Void) -> Void {
    Alamofire.request(fullURL(path: "/configuration")).responseJSON { response in
      let json     = response.result.value as! NSDictionary
      let configs  = json["configuration"] as! NSArray
      let config   = configs[0] as! NSDictionary
      let secret   = config["clientSecret"] as! String
      let clientId = config["clientId"] as! String

      let params = [
        "grant_type":    "password",
        "client_id":     clientId,
        "client_secret": secret,
        "username":      username,
        "password":      password
      ];

      Alamofire.request(self.fullURL(path: "/authentication/token"), method: .post, parameters: params).responseJSON { response in
        let status = response.response?.statusCode;
        if (status == 200) {
          let json = response.result.value as! NSDictionary;
          success(json["access_token"] as! String);
        }
      }
    }
  }
}
