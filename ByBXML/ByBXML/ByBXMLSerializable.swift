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
	// Can't use simply case Dictionary and case Array, as compiler will complain
	case XMLValue(String, ByBXMLAttributes?, String)	// name, attributes, value
	//
	//	<node test="true">VALUE</node>
	//
	//	XMLValue => String = "node"
	//				ByBXMLAttributes = [ "test" : "true" ]
	//				String = "VALUE"
	//
	case XMLDictionary(String, ByBXMLAttributes?, [ String : ByBXMLNode ])	// name, attributes, dictionary
	//
	//	<node test="true">
	//		<tag1 internal="true">INNER NODE</tag>
	//	</node>
	//
	//	XMLDictionary =>	String = "node"
	//						ByBXMLAttributes = [ "test" : "true" ]
	//						Dictionary = [ "tag1" : XMLValue =>	String = "tag1"
	//															ByBXMLAttributes = [ "internal" : "true" ]
	//															String = "INNER NODE" ]
	//
	case XMLArray([ ByBXMLNode ])	// array
	//
	//	<items test="true">
	//		<item position="1">FIRST ITEM</item>
	//		<item position="2">SECOND ITEM</item>
	//	</items>
	//
	//	XMLDictionary =>	String = "items"
	//						ByBXMLAttributes = [ "test" : "true" ]
	//						Dictionary = [ "item" : [	XMLValue =>	String = "item"
	//																ByBXMLAttributes = [ "position" : "1" ]
	//																String = "FIRST ITEM",
	//													XMLValue =>	String = "item"
	//																ByBXMLAttributes = [ "position" : "2" ]
	//																String = "SECOND ITEM" ] ]
	//
	
	public subscript(index: Int) -> ByBXMLNode? {
		let array: [ ByBXMLNode ]
		
		switch self {
		case .XMLArray(let xmlArray):
			array = xmlArray
			
		case .XMLValue(_, _, _): fallthrough
		case .XMLDictionary(_, _, _):
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
		case .XMLDictionary(_, _, let xmlDictionary):
			return xmlDictionary[key]
			
		case .XMLValue(_, _, _): fallthrough
		case .XMLArray(_):
			return nil
		}
	}
	
	public func addEntry(node: ByBXMLNode, key: String) -> ByBXMLNode {
		switch self {
		case .XMLArray(_):
			return self
			
		case .XMLDictionary(let name, let attributes, let xmlDictionary):
			if let entry = xmlDictionary[key] {
				
				var array: [ ByBXMLNode ]
				
				switch entry {
				case .XMLArray(let xmlArray):
					array = xmlArray
					array.append(node)
					
				case .XMLDictionary(_, _, _): fallthrough
				case .XMLValue(_, _, _):
					array = [ entry, node ]
				}
				
				var dict = xmlDictionary
				dict[key] = .XMLArray(array)
				
				return .XMLDictionary(name, attributes, dict)
			} else {
				var dict = xmlDictionary
				dict[key] = node
				
				return .XMLDictionary(name, attributes, dict)
			}
			
		case .XMLValue(let name, let parentAttributes, _):
			return .XMLDictionary(name, parentAttributes, [ key : node ])
		}
	}
	
	public func addString(string: String) -> ByBXMLNode {
		switch self {
		case .XMLArray(_): fallthrough
		case .XMLDictionary(_, _, _):
			return self
			
		case .XMLValue(let name, let attributes, let xmlString):
			return .XMLValue(name, attributes, xmlString + string)
		}
	}
	
	public var value: String {
		switch self {
		case .XMLValue(_, _, let string):
			return string
			
		case .XMLArray(_): fallthrough
		case .XMLDictionary(_, _, _):
			return ByBEmpty
		}
	}
	
	func arrayFromAttributes(attributes: ByBXMLAttributes?) -> [ String ] {
		var keys: [ String ] = []
		
		if let attributes = attributes {
			for (attKey, attValue) in attributes {
				keys.append("\(attKey)=\"\(attValue)\"")
			}
		}
		
		return keys
	}
	
	func startTagWith(name: String, attributes: ByBXMLAttributes?) -> String {
		let elements = join(" ", [name] + arrayFromAttributes(attributes))
		
		return "<\(elements)>"
	}
	
	func endTagWith(name: String) -> String {
		return "</\(name)>"
	}
	
	public var xml: String {
		switch self {
		case .XMLValue(let name, let attributes, let value):
			return "\(startTagWith(name, attributes: attributes))\(value)\(endTagWith(name))"
			
		case .XMLArray(let xmlArray):
			return join("", xmlArray.map { $0.xml })
			
		case .XMLDictionary(let name, let attributes, let xmlDict):
			var value = ""
			for (xmlKey, xmlValue) in xmlDict {
				value += xmlValue.xml
			}
			return "\(startTagWith(name, attributes: attributes))\(value)\(endTagWith(name))"
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

public protocol ByBXMLUnserializable {
	func unserializeXML(handler: (ByBXMLResult) -> Void)
}

//public protocol ByBXMLSerializable {
//	public func serializeXML() -> ByBXMLNode
//}

func areEqual (lhs: ByBXMLAttributes?, rhs: ByBXMLAttributes?) -> Bool {
	switch (lhs, rhs) {
	case (.None, .None):
		return true
		
	case (.None, .Some(let rhsAttributes)):
		return rhsAttributes.isEmpty
		
	case (.Some(let lhsAttributes), .None):
		return lhsAttributes.isEmpty
		
	case (.Some(let lhsAttributes), .Some(let rhsAttributes)):
		return lhsAttributes == rhsAttributes
	}
}

public func == (lhs: ByBXMLNode, rhs: ByBXMLNode) -> Bool {
	switch (lhs, rhs) {
	case (.XMLValue(let lhsName, let lhsAttributes, let lhsValue), .XMLValue(let rhsName, let rhsAttributes, let rhsValue)):
		return (lhsName == rhsName && lhsValue == rhsValue && areEqual(lhsAttributes, rhsAttributes))
		
	case (.XMLArray(let lhsArray), .XMLArray(let rhsArray)):
		return lhsArray == rhsArray
		
	case (.XMLArray(let lhsArray), _):
		return (lhsArray.count == 1 && lhsArray[0] == rhs)
		
	case (_, .XMLArray(let rhsArray)):
		return (rhsArray.count == 1 && rhsArray[0] == lhs)
		
	case (.XMLDictionary(let lhsName, let lhsAttributes, let lhsDict), .XMLDictionary(let rhsName, let rhsAttributes, let rhsDict)):
		return (lhsName == rhsName && lhsDict == rhsDict && areEqual(lhsAttributes, rhsAttributes))
		
	default:
		return false
	}
}

extension ByBXMLNode: Equatable {
}