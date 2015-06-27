//
//  ByBInPlaceXMLParserDelegate.h
//  ByBXML
//
//  Created by Boolky Bear on 24/6/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ByBInPlaceXMLParserDelegate : NSObject

typedef void(^ByBInPlaceXMLParserHandler)(NSXMLParser *parser);
typedef void(^ByBInPlaceXMLStartMappingPrefixHandler)(NSXMLParser *parser, NSString *prefix, NSString *namespaceURI);
typedef void(^ByBInPlaceXMLEndMappingPrefixHandler)(NSXMLParser *parser, NSString *prefix);
typedef void(^ByBInPlaceXMLStartElementHandler)(NSXMLParser *parser, NSString *elementName, NSString *namespaceURI, NSString *qualifiedName, NSDictionary *attributes);
typedef void(^ByBInPlaceXMLEndElementHandler)(NSXMLParser *parser, NSString *elementName, NSString *namespaceURI, NSString *qualifiedName);
typedef void(^ByBInPlaceXMLErrorHandler)(NSXMLParser *parser, NSError *error);
typedef void(^ByBInPlaceXMLStringHandler)(NSXMLParser *parser, NSString *string);
typedef void(^ByBInPlaceXMLProcessingHandler)(NSXMLParser *parser, NSString *target, NSString *data);
typedef void(^ByBInPlaceXMLDataHandler)(NSXMLParser *parser, NSData *data);
typedef NSData *(^ByBInPlaceXMLResolveExternalHandler)(NSXMLParser *parser, NSString *entityName, NSString *systemID);
typedef void(^ByBInPlaceXMLAttributeDeclarationHandler)(NSXMLParser *parser, NSString *attribute, NSString *element, NSString *type, NSString *defaultValue);
typedef void(^ByBInPlaceXMLElementDeclarationHandler)(NSXMLParser *parser, NSString *element, NSString *model);
typedef void(^ByBInPlaceXMLExternalDeclarationHandler)(NSXMLParser *parser, NSString *name, NSString *publicID, NSString *systemID);
typedef void(^ByBInPlaceXMLInternalDeclarationHandler)(NSXMLParser *parser, NSString *name, NSString *value);
typedef void(^ByBInPlaceXMLUnparsedDeclarationHandler)(NSXMLParser *parser, NSString *name, NSString *publicID, NSString *systemID, NSString *notationName);
typedef void(^ByBInPlaceXMLNotationDeclarationHandler)(NSXMLParser *parser, NSString *name, NSString *publicID, NSString *systemID);

- (instancetype) setStartDocumentHandler:(ByBInPlaceXMLParserHandler) handler;
- (instancetype) setEndDocumentHandler:(ByBInPlaceXMLParserHandler) handler;

- (instancetype) setStartMappingPrefixHandler:(ByBInPlaceXMLStartMappingPrefixHandler) handler;
- (instancetype) setEndMappingPrefixHandler:(ByBInPlaceXMLEndMappingPrefixHandler) handler;

- (instancetype) setStartElementHandler:(ByBInPlaceXMLStartElementHandler) handler;
- (instancetype) setEndElementHandler:(ByBInPlaceXMLEndElementHandler) handler;

- (instancetype) setParseErrorHandler:(ByBInPlaceXMLErrorHandler) handler;
- (instancetype) setValidationErrorHandler:(ByBInPlaceXMLErrorHandler) handler;

- (instancetype) setResolveExternalHandler:(ByBInPlaceXMLResolveExternalHandler) handler;

- (instancetype) setFoundCharactersHandler:(ByBInPlaceXMLStringHandler) handler;
- (instancetype) setFoundIgnorableWhitespaceHandler:(ByBInPlaceXMLStringHandler) handler;
- (instancetype) setFoundProcessingInstructionHandler:(ByBInPlaceXMLProcessingHandler) handler;
- (instancetype) setFoundCommentHandler:(ByBInPlaceXMLStringHandler) handler;
- (instancetype) setFoundCDATAHandler:(ByBInPlaceXMLDataHandler) handler;

- (instancetype) setFoundAttributeDeclarationHandler:(ByBInPlaceXMLAttributeDeclarationHandler) handler;
- (instancetype) setFoundElementDeclarationHandler:(ByBInPlaceXMLElementDeclarationHandler) handler;
- (instancetype) setFoundExternalDeclarationHandler:(ByBInPlaceXMLExternalDeclarationHandler) handler;
- (instancetype) setFoundInternalDeclarationHandler:(ByBInPlaceXMLInternalDeclarationHandler) handler;
- (instancetype) setFoundUnparsedDeclarationHandler:(ByBInPlaceXMLUnparsedDeclarationHandler) handler;
- (instancetype) setFoundNotationDeclarationHandler:(ByBInPlaceXMLNotationDeclarationHandler) handler;

@end

@interface ByBInPlaceXMLParserDelegate (NSXMLParserDelegate) <NSXMLParserDelegate>
@end
