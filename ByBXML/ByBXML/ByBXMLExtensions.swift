//
//  ByBXMLExtensions.swift
//  ByBXML
//
//  Created by Boolky Bear on 3/7/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

import Foundation

public let ByBXMLErrorDomain = "ByBXMLErrorDomain"
public enum ByBXMLErrorDomainErrorCodes: Int {
	case EmptyXML = 1
	case NSXMLParserError = 2
	case NoValidEncodingFound = 3
}

extension NSXMLParser: ByBXMLUnserializable {
	public func unserializeXML(handler: (ByBXMLResult) -> Void) {

		self.shouldProcessNamespaces = false
		self.shouldResolveExternalEntities = false
		self.shouldReportNamespacePrefixes = false
		
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
			var stack = ByBXMLStack<ByBXMLNode>()
			var lastError: NSError? = nil
			
			let xmlDelegate = ByBInPlaceXMLParserDelegate().setStartElementHandler {
				_, elementName, _, qualifiedName, attributes in
				
				var stringAttributes = [ String : String ]()
				for (key, value) in attributes {
					if let key = key as? String, value = value as? String {
						stringAttributes[key] = value
					}
				}
				
				stack.push(ByBXMLNode.XMLValue(elementName, stringAttributes, ByBEmpty))
				}.setEndElementHandler {
					_, elementName, _,	qualifiedName in
					
					if let node = stack.pop() {
						if let parent = stack.pop() {
							stack.push(parent.addEntry(node, key: elementName))
						} else {
							stack.push(node)	// root node
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
				}.setParseErrorHandler{
					_, error in
				
					lastError = error.copy() as? NSError
			}
			
			self.delegate = xmlDelegate
			if self.parse() == true {
				if let top = stack.top() {
					handler(ByBXMLResult.Success(top))
				} else {
					handler(ByBXMLResult.Error(NSError(domain: ByBXMLErrorDomain, code: ByBXMLErrorDomainErrorCodes.EmptyXML.rawValue, userInfo: nil)))
				}
			} else {
				handler(ByBXMLResult.Error(lastError ?? self.parserError ?? NSError(domain: ByBXMLErrorDomain, code: ByBXMLErrorDomainErrorCodes.NSXMLParserError.rawValue, userInfo: nil)))
			}
		
			stack.removeAll()
		}
	}
}

extension NSData: ByBXMLUnserializable {
	public func unserializeXML(handler: (ByBXMLResult) -> Void) {
		let parser = NSXMLParser(data: self)
		
		parser.unserializeXML(handler)
	}
}

extension NSString: ByBXMLUnserializable {
	public func unserializeXML(handler: (ByBXMLResult) -> Void) {
		let supportedEncodings = [ NSUTF8StringEncoding ]
		
		for encoding in supportedEncodings {
			if let data = self.dataUsingEncoding(encoding, allowLossyConversion: false) {
				data.unserializeXML(handler)
				
				return
			}
		}
		
		handler(ByBXMLResult.Error(NSError(domain: ByBXMLErrorDomain, code: ByBXMLErrorDomainErrorCodes.NoValidEncodingFound.rawValue, userInfo: nil)))
	}
}

extension String: ByBXMLUnserializable {
	public func unserializeXML(handler: (ByBXMLResult) -> Void) {
		let objcString = NSString(string: self)
		
		objcString.unserializeXML(handler)
	}
}

extension NSInputStream: ByBXMLUnserializable {
	public func unserializeXML(handler: (ByBXMLResult) -> Void) {
		let parser = NSXMLParser(stream: self)
		
		parser.unserializeXML(handler)
	}
}