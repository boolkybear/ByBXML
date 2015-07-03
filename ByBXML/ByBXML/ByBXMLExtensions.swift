//
//  ByBXMLExtensions.swift
//  ByBXML
//
//  Created by Boolky Bear on 3/7/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import Foundation

extension NSXMLParser: ByBXMLUnserializable {
	func unserializeXML(handler: (ByBXMLResult) -> Void) {

		self.shouldProcessNamespaces = false
		self.shouldResolveExternalEntities = false
		self.shouldReportNamespacePrefixes = false
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			var stack = ByBXMLStack<ByBXMLNode>()
			
			let xmlDelegate = ByBInPlaceXMLParserDelegate().setStartElementHandler {
				_, elementName, _, qualifiedName, attributes in
				
				var stringAttributes = [ String : String ]()
				for (key, value) in attributes {
					if let key = key as? String, value = value as? String {
						stringAttributes[key] = value
					}
				}
				
				stack.push(ByBXMLNode.XMLString(ByBEmpty, stringAttributes))
				}.setEndElementHandler {
					_, elementName, _,	qualifiedName in
					
					if let node = stack.pop() {
						if let parent = stack.pop() {
							stack.push(parent.addEntry(node, key: elementName))
						}
					}
				}.setFoundCharactersHandler {
					_, value in
					
					if let value = value {
						if let node = stack.pop() {
							stack.push(node.addString(value))
						}
					}
				}.setFoundCDATAHandler {
					_, cdata in
					
					if let value = NSString(data: cdata, encoding: NSUTF8StringEncoding) {
						if let node = stack.pop() {
							stack.push(node.addString(value as String))
						}
					}
			}
			
			self.delegate = xmlDelegate
			if self.parse() == true {
				if let top = stack.top() {
					handler(ByBXMLResult.Success(top))
				} else {
					handler(ByBXMLResult.Error(NSError()))	// TODO: empty stack
				}
			} else {
				handler(ByBXMLResult.Error(self.parserError ?? NSError()))
			}
		
			stack.removeAll()
		}
	}
}

extension NSData: ByBXMLUnserializable {
	func unserializeXML(handler: (ByBXMLResult) -> Void) {
		let parser = NSXMLParser(data: self)
		
		parser.unserializeXML(handler)
	}
}

extension String: ByBXMLUnserializable {
	func unserializeXML(handler: (ByBXMLResult) -> Void) {
		let objcString = NSString(string: self)
		let supportedEncodings = [ NSUTF8StringEncoding ]
		
		for encoding in supportedEncodings {
			if let data = self.dataUsingEncoding(encoding, allowLossyConversion: false) {
				data.unserializeXML(handler)
				break
			}
		}
		
		handler(ByBXMLResult.Error(NSError()))	// TODO: no valid encoding
	}
}

extension NSInputStream: ByBXMLUnserializable {
	func unserializeXML(handler: (ByBXMLResult) -> Void) {
		let parser = NSXMLParser(stream: self)
		
		parser.unserializeXML(handler)
	}
}