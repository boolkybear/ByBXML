//
//  ByBXMLExtensionsTests.swift
//  ByBXML
//
//  Created by Boolky Bear on 5/7/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import UIKit
import XCTest

class ByBXMLExtensionsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        XCTAssert(true, "Pass")
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock() {
//            // Put the code you want to measure the time of here.
//        }
//    }
	
	func testStringExtension() {
		let sampleXML =	"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
						"<note>" +
							"<to>Tove</to>" +
							"<from>Jani</from>" +
							"<heading>Reminder</heading>" +
							"<body>Don't forget me this weekend!</body>" +
						"</note>"
		
		let expectation = expectationWithDescription("Parsing")
		sampleXML.unserializeXML {
			result in
			
			switch result {
			case .Error(let error):
				XCTFail("Result error")
				
			case .Success(let root):
				let reference = ByBXMLNode.XMLDictionary("note", nil, [ "to" : ByBXMLNode.XMLValue("to", nil, "Tove"),
					"from" : ByBXMLNode.XMLValue("from", nil, "Jani"),
					"heading" : ByBXMLNode.XMLValue("heading", nil, "Reminder"),
					"body" : ByBXMLNode.XMLValue("body", nil, "Don't forget me this weekend!")])
				XCTAssert(root == reference)
			}
			
			expectation.fulfill()
		}
		
		waitForExpectationsWithTimeout(5.0) {
			error in
			
			if let _ = error {
				XCTFail("Parse error")
			}
		}
	}

	func testNSStringExtension() {
		let sampleXML: NSString =	"<?xml version=\"1.0\" encoding=\"UTF-8\"?>" +
									"<root xmlns:h=\"http://www.w3.org/TR/html4/\" xmlns:f=\"http://www.w3schools.com/furniture\">" +
										"<h:table>" +
											"<h:tr>" +
												"<h:td>Apples</h:td>" +
												"<h:td>Bananas</h:td>" +
											"</h:tr>" +
										"</h:table>" +
										"<f:table>" +
											"<f:name>African Coffee Table</f:name>" +
											"<f:width>80</f:width>" +
											"<f:length>120</f:length>" +
										"</f:table>" +
									"</root>";
		
		let expectation = expectationWithDescription("Parsing")
		sampleXML.unserializeXML {
			result in
			
			switch result {
			case .Error(let error):
				XCTFail("Result error")
				
			case .Success(let root):
				let reference = ByBXMLNode.XMLDictionary("root", [	"xmlns:h" : "http://www.w3.org/TR/html4/",
					"xmlns:f" : "http://www.w3schools.com/furniture" ],
					[	"h:table" : ByBXMLNode.XMLDictionary("h:table", nil, [ "h:tr" : ByBXMLNode.XMLDictionary("h:tr", nil, [ "h:td" : ByBXMLNode.XMLArray([ ByBXMLNode.XMLValue("h:td", nil, "Apples"), ByBXMLNode.XMLValue("h:td", nil, "Bananas")]) ])]),
						"f:table" : ByBXMLNode.XMLDictionary("f:table", nil, [ "f:name" : ByBXMLNode.XMLValue("f:name", nil, "African Coffee Table"),
							"f:width" : ByBXMLNode.XMLValue("f:width", nil, "80"),
							"f:length" : ByBXMLNode.XMLValue("f:length", nil, "120")]) ])
				XCTAssert(root == reference)
			}
			
			expectation.fulfill()
		}
		
		waitForExpectationsWithTimeout(5.0) {
			error in
			
			if let _ = error {
				XCTFail("Parse error")
			}
		}
	}
}
