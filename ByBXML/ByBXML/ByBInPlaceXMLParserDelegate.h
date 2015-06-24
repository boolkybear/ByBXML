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
typedef void(^ByBInPlaceXMLMappingPrefixHandler)(NSXMLParser *parser, NSString *prefix, NSString *namespaceURI);
typedef void(^ByBInPlaceXMLElementHandler)(NSXMLParser *parser, NSString *elementName, NSString *namespaceURI, NSString *qualifiedName, NSDictionary *attributes);
typedef void(^ByBInPlaceXMLErrorHandler)(NSXMLParser *parser, NSError *error);
typedef void(^ByBInPlaceXMLStringHandler)(NSXMLParser *parser, NSString *string);
typedef void(^ByBInPlaceXMLProcessingHandler)(NSXMLParser *parser, NSString *target, NSString *data);
typedef void(^ByBInPlaceXMLDataHandler)(NSXMLParser *parser, NSData *data);
typedef NSData *(^ByBInPlaceXMLResolveExternalHandler)(NSXMLParser *parser, NSString *entityName, NSString *systemID);
typedef void(^ByBInPlaceXMLThreeStringsHandler)(NSXMLParser *parser, NSString *string1, NSString *string2, NSString *string3);
typedef void(^ByBInPlaceXMLFourStringsHandler)(NSXMLParser *parser, NSString *string1, NSString *string2, NSString *string3, NSString *string4);

- (instancetype) setStartDocumentHandler:(ByBInPlaceXMLParserHandler) handler;
- (instancetype) setEndDocumentHandler:(ByBInPlaceXMLParserHandler) handler;

- (instancetype) setStartMappingPrefixHandler:(ByBInPlaceXMLMappingPrefixHandler) handler;
- (instancetype) setEndMappingPrefixHandler:(ByBInPlaceXMLMappingPrefixHandler) handler;

- (instancetype) setStartElementHandler:(ByBInPlaceXMLElementHandler) handler;
- (instancetype) setEndElementHandler:(ByBInPlaceXMLElementHandler) handler;

- (instancetype) setParseErrorHandler:(ByBInPlaceXMLErrorHandler) handler;
- (instancetype) setValidationErrorHandler:(ByBInPlaceXMLErrorHandler) handler;

- (instancetype) setResolveExternalHandler:(ByBInPlaceXMLResolveExternalHandler) handler;

- (instancetype) setFoundCharactersHandler:(ByBInPlaceXMLStringHandler) handler;
- (instancetype) setFoundIgnorableWhitespaceHandler:(ByBInPlaceXMLStringHandler) handler;
- (instancetype) setFoundProcessingInstructionHandler:(ByBInPlaceXMLProcessingHandler) handler;
- (instancetype) setFoundCommentHandler:(ByBInPlaceXMLStringHandler) handler;
- (instancetype) setFoundCDATAHandler:(ByBInPlaceXMLDataHandler) handler;

- (instancetype) setFoundAttributeDeclarationHandler:(ByBInPlaceXMLFourStringsHandler) handler;
- (instancetype) setFoundElementDeclarationHandler:(ByBInPlaceXMLMappingPrefixHandler) handler;
- (instancetype) setFoundExternalDeclarationHandler:(ByBInPlaceXMLThreeStringsHandler) handler;
- (instancetype) setFoundInternalDeclarationHandler:(ByBInPlaceXMLMappingPrefixHandler) handler;
- (instancetype) setFoundUnparsedDeclarationHandler:(ByBInPlaceXMLFourStringsHandler) handler;
- (instancetype) setFoundNotationDeclarationHandler:(ByBInPlaceXMLThreeStringsHandler) handler;

@end

@interface ByBInPlaceXMLParserDelegate (NSXMLParserDelegate) <NSXMLParserDelegate>
@end
