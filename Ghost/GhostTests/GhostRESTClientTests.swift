//
//  GhostTests.swift
//  GhostTests
//
//  Created by Ray Bradley on 4/24/18.
//  Copyright © 2018 Analemma Heavy Industries. All rights reserved.
//

import XCTest
@testable import Ghost

class GhostRESTClientTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testFullURL() {
    let client = GhostRESTClient()
    client.baseURL = "https://foo"
    let path = "/a/b/c"
    let fullPath = client.fullURL(path: path)
    XCTAssertEqual(fullPath, "https://foo/ghost/api/v0.1/a/b/c")
  }
  
  func testFullURLWithoutLeadingSlash() {
    let client = GhostRESTClient()
    client.baseURL = "https://foo"
    let path = "a/b/c"
    let fullPath = client.fullURL(path: path)
    XCTAssertEqual(fullPath, "https://foo/ghost/api/v0.1/a/b/c")
  }
}
