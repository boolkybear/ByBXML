//
//  ByBXMLSerializable.swift
//  ByBXML
//
//  Created by Boolky Bear on 2/7/15.
//  Copyright © 2015 ByBDesigns. All rights reserved.
//

import Foundation

public let ByBEmpty = ""
public typealias ByBXMLAttributes = [ String : String ]

public enum ByBXMLNode
{
	// Can't use simply case String, case Dictionary and case Array, as compiler will give errors
	case XMLString(String, ByBXMLAttributes?)
	case XMLDictionary([ String : ByBXMLNode ], ByBXMLAttributes?)
	case XMLArray([ ByBXMLNode ], ByBXMLAttributes?)
	
	public subscript(index: Int) -> ByBXMLNode? {
		let array: [ ByBXMLNode ]
		
		switch self {
		case .XMLArray(let xmlArray, _):
			array = xmlArray
			
		case .XMLString(_, _): fallthrough
		case .XMLDictionary(_, _):
			array = [ self ]
		}
		
		if index < 0 || index >= array.count {
			return nil
		} else {
			return array[index]
		}
	}
	
	public subscript(key: String) -> ByBXMLNode? {
		switch self {
		case .XMLDictionary(let xmlDictionary, _):
			return xmlDictionary[key]
			
		case .XMLString(_, _): fallthrough
		case .XMLArray(_, _):
			return nil
		}
	}
	
	public func addEntry(node: ByBXMLNode, key: String) -> ByBXMLNode {
		switch self {
		case .XMLArray(_, _):
			return self
			
		case .XMLDictionary(let xmlDictionary, let attributes):
			if let entry = xmlDictionary[key] {
				
				var array: [ ByBXMLNode ]
				
				switch entry {
				case .XMLArray(let xmlArray, _):
					array = xmlArray
					array.append(node)
					
				case .XMLDictionary(_, _): fallthrough
				case .XMLString(_, _):
					array = [ entry, node ]
				}
				
				var dict = xmlDictionary
				dict[key] = .XMLArray(array, nil)
				
				return .XMLDictionary(dict, attributes)
			} else {
				var dict = xmlDictionary
				dict[key] = node
				
				return .XMLDictionary(dict, attributes)
			}
			
		case .XMLString(_, let parentAttributes):
			return .XMLDictionary([ key : node ], parentAttributes)
		}
	}
	
	public func addString(string: String) -> ByBXMLNode {
		switch self {
		case .XMLArray(_, _): fallthrough
		case .XMLDictionary(_, _):
			return self
			
		case .XMLString(let xmlString, let attributes):
			return .XMLString(xmlString + string, attributes)
		}
	}
	
	public var value: String {
		switch self {
		case .XMLString(let string, _):
			return string
			
		case .XMLArray(_, _): fallthrough
		case .XMLDictionary(_, _):
			return ByBEmpty
		}
	}
}

public enum ByBXMLResult {
	case Error(NSError)
	case Success(ByBXMLNode)
}

public struct ByBXMLStack<T> {
	var stack = [T]()
	
	public init() {
		self.stack = [T]()
	}
	
	public mutating func push(item: T) {
		self.stack.append(item)
	}
	
	public mutating func pop() -> T? {
		if self.stack.isEmpty {
			return nil
		} else {
			return self.stack.removeLast()
		}
	}
	
	public func top() -> T? {
		return self.stack.last
	}
	
	public mutating func removeAll() {
		self.stack.removeAll(keepCapacity: false)
	}
}

protocol ByBXMLUnserializable {
	func unserializeXML(handler: (ByBXMLResult) -> Void)
}

protocol ByBXMLSerializable {
	func serializeXML() -> ByBXMLNode
}