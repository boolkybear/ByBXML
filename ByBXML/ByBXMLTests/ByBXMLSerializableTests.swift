//
//  ByBXMLSerializableTests.swift
//  ByBXML
//
//  Created by Boolky Bear on 4/7/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import UIKit
import XCTest

class ByBXMLSerializableTests: XCTestCase {

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
	
	func testValueNodes() {
		let testString = "testString"
		let testKey = "testKey"
		let testValue = "testValue"
		
		let stringNode = ByBXMLNode.XMLValue(testString, nil, testString)
		let stringWithAttributesNode = ByBXMLNode.XMLValue(testString, [ testKey : testValue ], testString)
		
		let stringReference = "<testString>testString</testString>"
		let stringWithAttributesReference = "<testString testKey=\"testValue\">testString</testString>"
		
		XCTAssert(stringNode.value == testString)
		XCTAssert(stringWithAttributesNode.value == testString)
		
		XCTAssert(stringNode.xml == stringReference)
		XCTAssert(stringWithAttributesNode.xml == stringWithAttributesReference)
	}
	
	func testArrayNodes() {
		let itemString = "item"
		let testKey = "testKey"
		let testValue = "testValue"
		
		let arrayNode = ByBXMLNode.XMLArray([ ByBXMLNode.XMLValue(itemString, nil, itemString),
			ByBXMLNode.XMLValue(itemString, [ testKey : testValue ], itemString )])
		
		
		let arrayReference = "<item>item</item><item testKey=\"testValue\">item</item>"
		
		XCTAssert(arrayNode.value == ByBEmpty)
		XCTAssert(arrayNode.xml == arrayReference)
	}
	
	func testDictionaryNodes() {
		let leafString = "leaf"
		let rootString = "root"
		let testKey = "testKey"
		let testValue = "testValue"
		let arrayString = "array"
		let itemString = "item"
		
		let arrayNode = ByBXMLNode.XMLArray([ ByBXMLNode.XMLValue(itemString, nil, itemString),
			ByBXMLNode.XMLValue(itemString, [ testKey : testValue ], itemString )])
		
		let noAttNoAttNode = ByBXMLNode.XMLDictionary(rootString, nil, [leafString : ByBXMLNode.XMLValue(leafString, nil, leafString)])
		let noAttAttNode = ByBXMLNode.XMLDictionary(rootString, nil, [leafString : ByBXMLNode.XMLValue(leafString, [ testKey : testValue ], leafString)])
		let attNoAttNode = ByBXMLNode.XMLDictionary(rootString, [ testKey : testValue ], [leafString : ByBXMLNode.XMLValue(leafString, nil, leafString)])
		let attAttNode = ByBXMLNode.XMLDictionary(rootString, [ testKey : testValue ], [leafString : ByBXMLNode.XMLValue(leafString, [ testKey : testValue ], leafString)])
		let arrayNoAttNode = ByBXMLNode.XMLDictionary(rootString, nil, [ arrayString : arrayNode ])
		let arrayAttNode = ByBXMLNode.XMLDictionary(rootString, [ testKey : testValue ], [ arrayString : arrayNode ])
		
		let noAttNoAttReference = "<root><leaf>leaf</leaf></root>"
		let noAttAttReference = "<root><leaf testKey=\"testValue\">leaf</leaf></root>"
		let attNoAttReference = "<root testKey=\"testValue\"><leaf>leaf</leaf></root>"
		let attAttReference = "<root testKey=\"testValue\"><leaf testKey=\"testValue\">leaf</leaf></root>"
		let arrayNoAttReference = "<root><item>item</item><item testKey=\"testValue\">item</item></root>"
		let arrayAttReference = "<root testKey=\"testValue\"><item>item</item><item testKey=\"testValue\">item</item></root>"
		
		XCTAssert(noAttNoAttNode.value == ByBEmpty)
		XCTAssert(noAttAttNode.value == ByBEmpty)
		XCTAssert(attNoAttNode.value == ByBEmpty)
		XCTAssert(attAttNode.value == ByBEmpty)
		
		XCTAssert(noAttNoAttNode.xml == noAttNoAttReference)
		XCTAssert(noAttAttNode.xml == noAttAttReference)
		XCTAssert(attNoAttNode.xml == attNoAttReference)
		XCTAssert(attAttNode.xml == attAttReference)
		XCTAssert(arrayNoAttNode.xml == arrayNoAttReference)
		XCTAssert(arrayAttNode.xml == arrayAttReference)
	}

	func testIntSubscript() {
		let leafString = "leaf"
		let rootString = "root"
		let itemString = "item"
		let testKey = "testKey"
		let testValue = "testValue"
		
		let valueNode = ByBXMLNode.XMLValue(leafString, nil, leafString)
		let dictionaryNode = ByBXMLNode.XMLDictionary(rootString, nil, [ leafString : valueNode ])
		let arrayNode = ByBXMLNode.XMLArray([ ByBXMLNode.XMLValue(itemString, nil, itemString),
			ByBXMLNode.XMLValue(itemString, [ testKey : testValue ], itemString )])
		
		XCTAssert(valueNode[-1] == nil)
		XCTAssert(valueNode[1] == nil)
		if let leafNode = valueNode[0] {
			let leafReference = "<leaf>leaf</leaf>"
			XCTAssert(leafNode.xml == leafReference)
		} else {
			XCTFail("Node is not valid")
		}
		
		XCTAssert(dictionaryNode[-1] == nil)
		XCTAssert(dictionaryNode[1] == nil)
		if let rootNode = dictionaryNode[0] {
			let rootReference = "<root><leaf>leaf</leaf></root>"
			XCTAssert(rootNode.xml == rootReference)
		} else {
			XCTFail("Node is not valid")
		}
		
		XCTAssert(arrayNode[-1] == nil)
		XCTAssert(arrayNode[2] == nil)
		if let firstNode = arrayNode[0], lastNode = arrayNode[1] {
			let firstReference = "<item>item</item>"
			let lastReference = "<item testKey=\"testValue\">item</item>"
		
			XCTAssert(firstNode.xml == firstReference)
			XCTAssert(lastNode.xml == lastReference)
		} else {
			XCTFail("Nodes are not valid")
		}
	}
	
	func testStringSubscript() {
		let leafString = "leaf"
		let rootString = "root"
		let itemString = "item"
		let testKey = "testKey"
		let testValue = "testValue"
		
		let valueNode = ByBXMLNode.XMLValue(leafString, nil, leafString)
		let dictionaryNode = ByBXMLNode.XMLDictionary(rootString, nil, [ leafString : valueNode ])
		let arrayNode = ByBXMLNode.XMLArray([ ByBXMLNode.XMLValue(itemString, nil, itemString),
			ByBXMLNode.XMLValue(itemString, [ testKey : testValue ], itemString )])
		
		XCTAssert(valueNode[leafString] == nil)
		XCTAssert(arrayNode[itemString] == nil)
		XCTAssert(dictionaryNode[rootString] == nil)
		
		if let leafNode = dictionaryNode[leafString] {
			let leafReference = "<leaf>leaf</leaf>"
			XCTAssert(leafNode.xml == leafReference)
		} else {
			XCTFail("Node is not valid")
		}
	}
	
	func testAddString() {
		let leafString = "leaf"
		let rootString = "root"
		let testKey = "testKey"
		let testValue = "testValue"
		let arrayString = "array"
		let itemString = "item"
		
		let arrayNode = ByBXMLNode.XMLArray([ ByBXMLNode.XMLValue(itemString, nil, itemString),
			ByBXMLNode.XMLValue(itemString, [ testKey : testValue ], itemString )])
		
		let leafNoAttNode = ByBXMLNode.XMLValue(leafString, nil, leafString)
		let leafAttNode = ByBXMLNode.XMLValue(leafString, [ testKey : testValue ], leafString)
		
		let noAttNoAttNode = ByBXMLNode.XMLDictionary(rootString, nil, [leafString : leafNoAttNode])
		let noAttAttNode = ByBXMLNode.XMLDictionary(rootString, nil, [leafString : leafAttNode])
		let attNoAttNode = ByBXMLNode.XMLDictionary(rootString, [ testKey : testValue ], [leafString : leafNoAttNode])
		let attAttNode = ByBXMLNode.XMLDictionary(rootString, [ testKey : testValue ], [leafString : leafAttNode])
		let arrayNoAttNode = ByBXMLNode.XMLDictionary(rootString, nil, [ arrayString : arrayNode ])
		let arrayAttNode = ByBXMLNode.XMLDictionary(rootString, [ testKey : testValue ], [ arrayString : arrayNode ])
		
		let noAttNoAttReference = "<root><leaf>leaf</leaf></root>"
		let noAttAttReference = "<root><leaf testKey=\"testValue\">leaf</leaf></root>"
		let attNoAttReference = "<root testKey=\"testValue\"><leaf>leaf</leaf></root>"
		let attAttReference = "<root testKey=\"testValue\"><leaf testKey=\"testValue\">leaf</leaf></root>"
		let arrayNoAttReference = "<root><item>item</item><item testKey=\"testValue\">item</item></root>"
		let arrayAttReference = "<root testKey=\"testValue\"><item>item</item><item testKey=\"testValue\">item</item></root>"
		let leafleafNoAttReference = "<leaf>leafleaf</leaf>"
		let leafleafAttReference = "<leaf testKey=\"testValue\">leafleaf</leaf>"
		
		let leafleafNoAttNode = leafNoAttNode.addString(leafString)
		let leafleafAttNode = leafAttNode.addString(leafString)
		let leafNoAttNoAttNode = noAttNoAttNode.addString(leafString)
		let leafNoAttAttNode = noAttAttNode.addString(leafString)
		let leafAttNoAttNode = attNoAttNode.addString(leafString)
		let leafAttAttNode = attAttNode.addString(leafString)
		let leafArrayNoAttNode = arrayNoAttNode.addString(leafString)
		let leafArrayAttNode = arrayAttNode.addString(leafString)
		
		XCTAssert(leafleafNoAttNode.xml == leafleafNoAttReference)
		XCTAssert(leafleafAttNode.xml == leafleafAttReference)
		XCTAssert(leafNoAttNoAttNode.xml == noAttNoAttReference)
		XCTAssert(leafNoAttAttNode.xml == noAttAttReference)
		XCTAssert(leafAttNoAttNode.xml == attNoAttReference)
		XCTAssert(leafAttAttNode.xml == attAttReference)
		XCTAssert(leafArrayNoAttNode.xml == arrayNoAttReference)
		XCTAssert(leafArrayAttNode.xml == arrayAttReference)
	}
	
	func testAddEntry() {
		let leafString = "leaf"
		let rootString = "root"
		let testKey = "testKey"
		let testValue = "testValue"
		let arrayString = "array"
		let itemString = "item"
		
		let arrayNode = ByBXMLNode.XMLArray([ ByBXMLNode.XMLValue(itemString, nil, itemString),
			ByBXMLNode.XMLValue(itemString, [ testKey : testValue ], itemString )])
		
		let leafNoAttNode = ByBXMLNode.XMLValue(leafString, nil, leafString)
		let leafAttNode = ByBXMLNode.XMLValue(leafString, [ testKey : testValue ], leafString)
		
		let dictNode = ByBXMLNode.XMLDictionary(rootString, nil, [:])
		let dictLeafNode = ByBXMLNode.XMLDictionary(rootString, nil, [ leafString : leafNoAttNode ])
		let dictArrayNode = ByBXMLNode.XMLDictionary(rootString, nil, [ arrayString : ByBXMLNode.XMLArray( [ leafNoAttNode, leafAttNode ] ) ])
		let dictAttNode = ByBXMLNode.XMLDictionary(rootString, [ testKey : testValue ], [:])
		let dictAttLeafNode = ByBXMLNode.XMLDictionary(rootString, [ testKey : testValue ], [ leafString : leafNoAttNode ])
		let dictAttArrayNode = ByBXMLNode.XMLDictionary(rootString, [ testKey : testValue ], [ arrayString : ByBXMLNode.XMLArray( [ leafNoAttNode, leafAttNode ] ) ])
		
		let entryArrayNode = arrayNode.addEntry(leafNoAttNode, key: arrayString)
		let entryLeafNoAttNode = leafNoAttNode.addEntry(leafNoAttNode, key: arrayString)
		let entryLeafAttNode = leafAttNode.addEntry(leafNoAttNode, key: arrayString)
		let entryDictNode = dictNode.addEntry(leafNoAttNode, key: arrayString)
		let entryDictLeafNode = dictLeafNode.addEntry(leafNoAttNode, key: leafString)
		let entryDictArrayNode = dictArrayNode.addEntry(leafNoAttNode, key: arrayString)
		let entryDictAttNode = dictAttNode.addEntry(leafNoAttNode, key: arrayString)
		let entryDictAttLeafNode = dictAttLeafNode.addEntry(leafNoAttNode, key: leafString)
		let entryDictAttArrayNode = dictAttArrayNode.addEntry(leafNoAttNode, key: arrayString)
		
		let arrayReference = "<item>item</item><item testKey=\"testValue\">item</item>"
		let leafNoAttReference = "<leaf><leaf>leaf</leaf></leaf>"
		let leafAttReference = "<leaf testKey=\"testValue\"><leaf>leaf</leaf></leaf>"
		let dictReference = "<root><leaf>leaf</leaf></root>"
		let dictLeafReference = "<root><leaf>leaf</leaf><leaf>leaf</leaf></root>"
		let dictArrayReference = "<root><leaf>leaf</leaf><leaf testKey=\"testValue\">leaf</leaf><leaf>leaf</leaf></root>"
		let dictAttReference = "<root testKey=\"testValue\"><leaf>leaf</leaf></root>"
		let dictAttLeafReference = "<root testKey=\"testValue\"><leaf>leaf</leaf><leaf>leaf</leaf></root>"
		let dictAttArrayReference = "<root testKey=\"testValue\"><leaf>leaf</leaf><leaf testKey=\"testValue\">leaf</leaf><leaf>leaf</leaf></root>"
		
		XCTAssert(entryArrayNode.xml == arrayReference)
		XCTAssert(entryLeafNoAttNode.xml == leafNoAttReference)
		XCTAssert(entryLeafAttNode.xml == leafAttReference)
		XCTAssert(entryDictNode.xml == dictReference)
		XCTAssert(entryDictLeafNode.xml == dictLeafReference)
		XCTAssert(entryDictArrayNode.xml == dictArrayReference)
		XCTAssert(entryDictAttNode.xml == dictAttReference)
		XCTAssert(entryDictAttLeafNode.xml == dictAttLeafReference)
		XCTAssert(entryDictAttArrayNode.xml == dictAttArrayReference)
	}
}
