//
//  ByBInPlaceXMLParserDelegate.m
//  ByBXML
//
//  Created by Boolky Bear on 24/6/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

#import "ByBInPlaceXMLParserDelegate.h"

@implementation ByBInPlaceXMLParserDelegate
{
	ByBInPlaceXMLParserHandler startDocumentHandler;
	ByBInPlaceXMLParserHandler endDocumentHandler;
	
	ByBInPlaceXMLStartMappingPrefixHandler startMappingPrefixHandler;
	ByBInPlaceXMLEndMappingPrefixHandler endMappingPrefixHandler;
	
	ByBInPlaceXMLStartElementHandler startElementHandler;
	ByBInPlaceXMLEndElementHandler endElementHandler;
	
	ByBInPlaceXMLErrorHandler parseErrorHandler;
	ByBInPlaceXMLErrorHandler validationErrorHandler;
	
	ByBInPlaceXMLResolveExternalHandler resolveExternalHandler;
	
	ByBInPlaceXMLStringHandler foundCharactersHandler;
	ByBInPlaceXMLStringHandler foundIgnorableWhitespaceHandler;
	ByBInPlaceXMLProcessingHandler foundProcessingInstructionHandler;
	ByBInPlaceXMLStringHandler foundCommentHandler;
	ByBInPlaceXMLDataHandler foundCDATAHandler;
	
	ByBInPlaceXMLAttributeDeclarationHandler foundAttributeDeclarationHandler;
	ByBInPlaceXMLElementDeclarationHandler foundElementDeclarationHandler;
	ByBInPlaceXMLExternalDeclarationHandler foundExternalDeclarationHandler;
	ByBInPlaceXMLInternalDeclarationHandler foundInternalDeclarationHandler;
	ByBInPlaceXMLUnparsedDeclarationHandler foundUnparsedDeclarationHandler;
	ByBInPlaceXMLNotationDeclarationHandler foundNotationDeclarationHandler;
}

- (instancetype) setStartDocumentHandler:(ByBInPlaceXMLParserHandler) handler
{
	startDocumentHandler = handler;
	
	return self;
}

- (instancetype) setEndDocumentHandler:(ByBInPlaceXMLParserHandler) handler
{
	endDocumentHandler = handler;
	
	return self;
}

- (instancetype) setStartMappingPrefixHandler:(ByBInPlaceXMLStartMappingPrefixHandler) handler
{
	startMappingPrefixHandler = handler;
	
	return self;
}

- (instancetype) setEndMappingPrefixHandler:(ByBInPlaceXMLEndMappingPrefixHandler) handler
{
	endMappingPrefixHandler = handler;
	
	return self;
}

- (instancetype) setStartElementHandler:(ByBInPlaceXMLStartElementHandler) handler
{
	startElementHandler = handler;
	
	return self;
}

- (instancetype) setEndElementHandler:(ByBInPlaceXMLEndElementHandler) handler
{
	endElementHandler = handler;
	
	return self;
}

- (instancetype) setParseErrorHandler:(ByBInPlaceXMLErrorHandler) handler
{
	parseErrorHandler = handler;
	
	return self;
}

- (instancetype) setValidationErrorHandler:(ByBInPlaceXMLErrorHandler) handler
{
	validationErrorHandler = handler;
	
	return self;
}

- (instancetype) setResolveExternalHandler:(ByBInPlaceXMLResolveExternalHandler) handler
{
	resolveExternalHandler = handler;
	
	return self;
}

- (instancetype) setFoundCharactersHandler:(ByBInPlaceXMLStringHandler) handler
{
	foundCharactersHandler = handler;
	
	return self;
}

- (instancetype) setFoundIgnorableWhitespaceHandler:(ByBInPlaceXMLStringHandler) handler
{
	foundIgnorableWhitespaceHandler = handler;
	
	return self;
}

- (instancetype) setFoundProcessingInstructionHandler:(ByBInPlaceXMLProcessingHandler) handler
{
	foundProcessingInstructionHandler = handler;
	
	return self;
}

- (instancetype) setFoundCommentHandler:(ByBInPlaceXMLStringHandler) handler
{
	foundCommentHandler = handler;
	
	return self;
}

- (instancetype) setFoundCDATAHandler:(ByBInPlaceXMLDataHandler) handler
{
	foundCDATAHandler = handler;
	
	return self;
}

- (instancetype) setFoundAttributeDeclarationHandler:(ByBInPlaceXMLAttributeDeclarationHandler) handler
{
	foundAttributeDeclarationHandler = handler;
	
	return self;
}

- (instancetype) setFoundElementDeclarationHandler:(ByBInPlaceXMLElementDeclarationHandler) handler
{
	foundElementDeclarationHandler = handler;
	
	return self;
}

- (instancetype) setFoundExternalDeclarationHandler:(ByBInPlaceXMLExternalDeclarationHandler) handler
{
	foundExternalDeclarationHandler = handler;
	
	return self;
}

- (instancetype) setFoundInternalDeclarationHandler:(ByBInPlaceXMLInternalDeclarationHandler) handler
{
	foundInternalDeclarationHandler = handler;
	
	return self;
}

- (instancetype) setFoundUnparsedDeclarationHandler:(ByBInPlaceXMLUnparsedDeclarationHandler) handler
{
	foundUnparsedDeclarationHandler = handler;
	
	return self;
}

- (instancetype) setFoundNotationDeclarationHandler:(ByBInPlaceXMLNotationDeclarationHandler) handler
{
	foundNotationDeclarationHandler = handler;
	
	return self;
}

@end

@implementation ByBInPlaceXMLParserDelegate (NSXMLParserDelegate)

- (void) parserDidStartDocument:(NSXMLParser *)parser
{
	if(startDocumentHandler != nil)
		startDocumentHandler(parser);
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
	if(endDocumentHandler != nil)
		endDocumentHandler(parser);
}

- (void) parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI
{
	if(startMappingPrefixHandler != nil)
		startMappingPrefixHandler(parser, prefix, namespaceURI);
}

- (void) parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix
{
	if(endMappingPrefixHandler != nil)
		endMappingPrefixHandler(parser, prefix);
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
	if(startElementHandler != nil)
		startElementHandler(parser, elementName, namespaceURI, qName, attributeDict);
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if(endElementHandler != nil)
		endElementHandler(parser, elementName, namespaceURI, qName);
}

- (void) parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
	if(parseErrorHandler != nil)
		parseErrorHandler(parser, parseError);
}

- (void) parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
	if(validationErrorHandler != nil)
		validationErrorHandler(parser, validationError);
}

- (NSData *) parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)entityName systemID:(NSString *)systemID
{
	if(resolveExternalHandler != nil)
		return resolveExternalHandler(parser, entityName, systemID);
	else
		return nil;
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(foundCharactersHandler != nil)
		foundCharactersHandler(parser, string);
}

- (void) parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{
	if(foundCharactersHandler != nil)
		foundIgnorableWhitespaceHandler(parser, whitespaceString);
}

- (void) parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data
{
	if(foundProcessingInstructionHandler != nil)
		foundProcessingInstructionHandler(parser, target, data);
}

- (void) parser:(NSXMLParser *)parser foundComment:(NSString *)comment
{
	if(foundCommentHandler != nil)
		foundCommentHandler(parser, comment);
}

- (void) parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
	if(foundCDATAHandler != nil)
		foundCDATAHandler(parser, CDATABlock);
}

- (void) parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model
{
	if(foundElementDeclarationHandler != nil)
		foundElementDeclarationHandler(parser, elementName, model);
}

- (void) parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
	if(foundExternalDeclarationHandler != nil)
		foundExternalDeclarationHandler(parser, name, publicID, systemID);
}

- (void) parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value
{
	if(foundInternalDeclarationHandler != nil)
		foundInternalDeclarationHandler(parser, name, value);
}

- (void) parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName
{
	if(foundUnparsedDeclarationHandler != nil)
		foundUnparsedDeclarationHandler(parser, name, publicID, systemID, notationName);
}

- (void) parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
	if(foundNotationDeclarationHandler != nil)
		foundNotationDeclarationHandler(parser, name, publicID, systemID);
}

@end