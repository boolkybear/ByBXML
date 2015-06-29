//
//  ByBXMLInPlaceXMLParserDelegateTests.m
//  ByBXML
//
//  Created by Jose on 26/6/15.
//  Copyright (c) 2015 ByBDesigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "ByBInPlaceXMLParserDelegate.h"

@interface ByBXMLInPlaceXMLParserDelegateTests : XCTestCase

@end

static const NSString *kNamespaceKey = @"namespace";
static const NSString *kQualifiedNameKey = @"qualifiedName";
static const NSString *kAttributesKey = @"attributes";
static const NSString *kElementKey = @"element";
static const NSString *kTypeKey = @"type";
static const NSString *kDefaultKey = @"default";
static const NSString *kPublicKey = @"public";
static const NSString *kSystemKey = @"system";
static const NSString *kNotationKey = @"notation";

@implementation ByBXMLInPlaceXMLParserDelegateTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void) testStartAndEndDocument {
	// Reference XML from http://www.w3schools.com/xml/note.xml
	NSString *sampleXML =	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							@"<note>"
								@"<to>Tove</to>"
								@"<from>Jani</from>"
								@"<heading>Reminder</heading>"
								@"<body>Don't forget me this weekend!</body>"
							@"</note>";
	NSData *xmlData = [sampleXML dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	
	__block BOOL isDocumentStarted = NO;
	__block BOOL isDocumentEnded = NO;
	ByBInPlaceXMLParserDelegate *delegate = [[[[ByBInPlaceXMLParserDelegate alloc] init] setStartDocumentHandler:^(NSXMLParser *parser) {
		isDocumentStarted = YES;
	}] setEndDocumentHandler:^(NSXMLParser *parser) {
		isDocumentEnded = YES;
	}];
	parser.delegate = delegate;
	
	BOOL parseOk = [parser parse];
	XCTAssert(parseOk);
	XCTAssert(isDocumentStarted);
	XCTAssert(isDocumentEnded);
}

- (BOOL) parseData:(NSData *)data reportingNamespaces:(BOOL)shouldReportNamespaces
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	
	// Don't report namespaces:
	NSDictionary *nonReportingReferenceMappings = @{};
	NSSet *nonReportingReferenceEndedMappings = [NSSet setWithArray:@[]];
	
	// Report namespaces:
	NSDictionary *reportingReferenceMappings = @{ @"h" : @"http://www.w3.org/TR/html4/",
										 @"f" : @"http://www.w3schools.com/furniture" };
	NSSet *reportingReferenceEndedMappings = [NSSet setWithArray:@[ @"h", @"f" ]];
	
	NSMutableDictionary *mappings = [NSMutableDictionary new];
	NSMutableSet *endedMappings = [NSMutableSet new];
	ByBInPlaceXMLParserDelegate *delegate = [[[[ByBInPlaceXMLParserDelegate alloc] init] setStartMappingPrefixHandler:^(NSXMLParser *parser, NSString *prefix, NSString *namespaceURI) {
		mappings[prefix] = namespaceURI;
	}] setEndMappingPrefixHandler:^(NSXMLParser *parser, NSString *prefix) {
		[endedMappings addObject:prefix];
	}];
	parser.delegate = delegate;
	parser.shouldReportNamespacePrefixes = shouldReportNamespaces;
	
	BOOL parseOk = [parser parse];
	XCTAssert(parseOk);
	
	BOOL mappingsOk = [mappings isEqualToDictionary:shouldReportNamespaces ? reportingReferenceMappings : nonReportingReferenceMappings];
	BOOL endedMappingsOk = [endedMappings isEqualToSet:shouldReportNamespaces ? reportingReferenceEndedMappings : nonReportingReferenceEndedMappings];
	XCTAssert(mappingsOk);
	XCTAssert(endedMappingsOk);
	
	return (parseOk && mappingsOk && endedMappingsOk);
}

- (void) testStartAndEndMappingPrefix {
	// Reference XML from http://www.w3schools.com/xml/xml_namespaces.asp
	NSString *sampleXML =	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							@"<root xmlns:h=\"http://www.w3.org/TR/html4/\" xmlns:f=\"http://www.w3schools.com/furniture\">"
								@"<h:table>"
									@"<h:tr>"
										@"<h:td>Apples</h:td>"
										@"<h:td>Bananas</h:td>"
									@"</h:tr>"
								@"</h:table>"
								@"<f:table>"
									@"<f:name>African Coffee Table</f:name>"
									@"<f:width>80</f:width>"
									@"<f:length>120</f:length>"
								@"</f:table>"
							@"</root>";
	NSData *xmlData = [sampleXML dataUsingEncoding:NSUTF8StringEncoding];
	
	XCTAssert([self parseData:xmlData reportingNamespaces:NO]);
	XCTAssert([self parseData:xmlData reportingNamespaces:YES]);
}

- (NSDictionary *) dictionaryWithNamespace:(NSString *)namespace qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributes
{
	NSMutableDictionary *mutableDictionary = [NSMutableDictionary new];

	if(namespace != nil)
		mutableDictionary[kNamespaceKey] = namespace;
	if(qualifiedName != nil)
		mutableDictionary[kQualifiedNameKey] = qualifiedName;
	if(attributes != nil)
		mutableDictionary[kAttributesKey] = attributes;
	
	return [mutableDictionary copy];
}

- (BOOL) parseData:(NSData *)data processingNamespaces:(BOOL)shouldProcessNamespaces
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	
	// Don't process namespaces:
	NSDictionary *nonProcessingNamespacesReference = @{ @"root" : @{ kAttributesKey : @{ @"xmlns:h" : @"http://www.w3.org/TR/html4/" } },
														@"h:table" : @{ kAttributesKey : @{} },
														@"h:tr" : @{ kAttributesKey : @{} },
														@"h:td" : @{ kAttributesKey : @{} } };
	NSDictionary *nonProcessingNamespacesEndReference = @{ @"h:td" : @{},
														   @"h:tr" : @{},
														   @"h:table" : @{},
														   @"root" : @{} };
	// Process namespaces:
	NSDictionary *processingNamespacesReference = @{ @"root" : @{ kNamespaceKey : @"",
																  kQualifiedNameKey : @"root",
																  kAttributesKey : @{} },
													 @"table" : @{ kNamespaceKey : @"http://www.w3.org/TR/html4/",
																   kQualifiedNameKey : @"h:table",
																   kAttributesKey : @{} },
													 @"tr" : @{ kNamespaceKey : @"http://www.w3.org/TR/html4/",
																kQualifiedNameKey : @"h:tr",
																kAttributesKey : @{} },
													 @"td" : @{ kNamespaceKey : @"http://www.w3.org/TR/html4/",
																kQualifiedNameKey : @"h:td",
																kAttributesKey : @{} } };
	NSDictionary *processingNamespacesEndReference = @{ @"td" : @{ kNamespaceKey : @"http://www.w3.org/TR/html4/",
																   kQualifiedNameKey : @"h:td" },
														@"tr" : @{ kNamespaceKey : @"http://www.w3.org/TR/html4/",
																   kQualifiedNameKey : @"h:tr" },
														@"table" : @{ kNamespaceKey : @"http://www.w3.org/TR/html4/",
																	 kQualifiedNameKey : @"h:table" },
														@"root" : @{ kNamespaceKey : @"",
																	 kQualifiedNameKey : @"root" } };
	
	NSMutableDictionary *elements = [NSMutableDictionary new];
	NSMutableDictionary *endElements = [NSMutableDictionary new];
	ByBInPlaceXMLParserDelegate *delegate = [[[[ByBInPlaceXMLParserDelegate alloc] init] setStartElementHandler:^(NSXMLParser *parser, NSString *elementName, NSString *namespaceURI, NSString *qualifiedName, NSDictionary *attributes) {
		elements[elementName] = [self dictionaryWithNamespace:namespaceURI qualifiedName:qualifiedName attributes:attributes];
	}] setEndElementHandler:^(NSXMLParser *parser, NSString *elementName, NSString *namespaceURI, NSString *qualifiedName) {
		endElements[elementName] = [self dictionaryWithNamespace:namespaceURI qualifiedName:qualifiedName attributes:nil];
	}];
	parser.delegate = delegate;
	parser.shouldProcessNamespaces = shouldProcessNamespaces;
	
	BOOL parseOk = [parser parse];
	XCTAssert(parseOk);
	
	BOOL elementsOk = [elements isEqualToDictionary:shouldProcessNamespaces ? processingNamespacesReference : nonProcessingNamespacesReference];
	BOOL endElementsOk = [endElements isEqualToDictionary:shouldProcessNamespaces ? processingNamespacesEndReference : nonProcessingNamespacesEndReference];
	XCTAssert(elementsOk);
	XCTAssert(endElementsOk);
	
	return (parseOk && elementsOk && endElementsOk);
}

- (void) testStartAndEndElement {
	// Reference XML from http://www.w3schools.com/xml/xml_namespaces.asp
	// Only one reference of each tag, to make testing easier
	NSString *sampleXML =	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							@"<root xmlns:h=\"http://www.w3.org/TR/html4/\">"
								@"<h:table>"
									@"<h:tr>"
										@"<h:td>Apples</h:td>"
									@"</h:tr>"
								@"</h:table>"
							@"</root>";
	NSData *xmlData = [sampleXML dataUsingEncoding:NSUTF8StringEncoding];
	
	XCTAssert([self parseData:xmlData processingNamespaces:NO]);
	XCTAssert([self parseData:xmlData processingNamespaces:YES]);
}

- (void) testParserError {
	// Reference XML from http://www.w3schools.com/xml/note.xml
	NSString *sampleXML =	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							@"<note>"
								@"<to>Tove</to>"
								@"<from>Jani</from>"
								@"<heading>Reminder"	// <-- removed closing heading tag
								@"<body>Don't forget me this weekend!</body>"
							@"</note>";
	NSData *xmlData = [sampleXML dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	
	__block NSError *parseError = nil;
	__block NSError *validationError = nil;
	ByBInPlaceXMLParserDelegate *delegate = [[[[[ByBInPlaceXMLParserDelegate alloc] init] setParseErrorHandler:^(NSXMLParser *parser, NSError *error) {
		parseError = error;
	}] setValidationErrorHandler:^(NSXMLParser *parser, NSError *error) {
		validationError = error;
	}] setEndDocumentHandler:^(NSXMLParser *parser) {
		NSLog(@"Document ended");
	}];
	parser.delegate = delegate;
	
	BOOL parseOk = [parser parse];
	XCTAssertFalse(parseOk);
	XCTAssertNotNil(parseError);
	
	// Stated in the Apple documentation:
	// Sent by a parser object to its delegate when it encounters a fatal validation error. NSXMLParser currently does not invoke this method and does not perform validation.
	//XCTAssertNotNil(validationError);
}

// This example always fails!
- (void) testResolveExternalEntity
{
	// Reference XML from http://www.vsecurity.com/download/advisories/20140917-1.txt
	NSString *sampleXML =	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							@"<!DOCTYPE test ["
								@"<!ENTITY http SYSTEM \"http://iossdk-xxe.apt.vsecurity.org/\">"
								@"<!ENTITY file SYSTEM \"file:///etc/hosts\">"
								@"<!ELEMENT test (vsr)>"
								@"<!ELEMENT vsr (tag1, tag2)>"
								@"<!ELEMENT tag1 (#PCDATA)>"
								@"<!ELEMENT tag2 (#PCDATA)>"
							@"]>"
							@"<test>"
								@"<vsr>"
									@"<tag1>&file;</tag1>"
									@"<tag2>&http;</tag2>"
								@"</vsr>"
							@"</test>";
	NSData *xmlData = [sampleXML dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	parser.shouldResolveExternalEntities = YES;
	
	ByBInPlaceXMLParserDelegate *delegate = [[[[[ByBInPlaceXMLParserDelegate alloc] init] setResolveExternalHandler:^NSData *(NSXMLParser *parser, NSString *entityName, NSString *systemID) {
		NSDictionary *entities = @{ @"file" : [@"file as string" dataUsingEncoding:NSUTF8StringEncoding],
									@"http" : [@"http as string" dataUsingEncoding:NSUTF8StringEncoding] };
		
		return entities[entityName];
		
		// This gets called after the setParserErrorHandler, entityName == @"file" but systemID == nil
	}] setParseErrorHandler:^(NSXMLParser *parser, NSError *error) {
		NSLog(@"Error: %@", error);
		
		// This gets called with an error 104 (XML_ERR_ENTITY_PROCESSING in libxml2)
		// After this, the setResolveExternalHandler is called
	}] setFoundCharactersHandler:^(NSXMLParser *parser, NSString *string) {
		NSLog(@"Found %@", string);
		
		// This is called after setResolveExternalHandler, and string == @"file as string"
		// After this, no more delegate methods are called and parsing stops
	}];
	
	parser.delegate = delegate;
	
	BOOL parseOk = [parser parse];
	XCTAssert(parseOk);
	
	// parseOk == false, parser.parseError == 111 (XML_ERR_USER_STOP in libxml2)
}

- (void) testFoundTexts {
	// Reference XML from http://www.w3schools.com/xml/note.xml
	NSString *sampleXML =	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							@"<!DOCTYPE note ["
								@"<!ELEMENT note (to, from, heading, body)>"
								@"<!ELEMENT to (#PCDATA)>"
								@"<!ELEMENT from (#PCDATA)>"
								@"<!ELEMENT heading (#PCDATA)>"
								@"<!ELEMENT body (#PCDATA)>"
							@"]>"
							@"<note>  "
								@"<to>Tove</to>\t  "
								@"<from>Jani</from>\t  "
								@"<heading>Reminder   note</heading>\t  "
								@"<body><![CDATA[Don't forget me & my friends this weekend!]]></body>"
								@"<!-- End of the note -->"
							@"</note>";
	NSData *xmlData = [sampleXML dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	
	NSMutableArray *texts = [NSMutableArray new];
	NSMutableArray *blanks = [NSMutableArray new];
	__block NSString *comment = nil;
	ByBInPlaceXMLParserDelegate *delegate = [[[[[[ByBInPlaceXMLParserDelegate alloc] init] setFoundCharactersHandler:^(NSXMLParser *parser, NSString *string) {
		[texts addObject:string];
	}] setFoundCDATAHandler:^(NSXMLParser *parser, NSData *data) {
		NSString *stringFromData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		if(stringFromData != nil)
			[texts addObject:stringFromData];
	}] setFoundIgnorableWhitespaceHandler:^(NSXMLParser *parser, NSString *string) {
		[blanks addObject:string];
	}] setFoundCommentHandler:^(NSXMLParser *parser, NSString *string) {
		comment = [string copy];
	}];
	parser.delegate = delegate;
	
	BOOL parseOk = [parser parse];
	XCTAssert(parseOk);
	
	// NSXMLParser is not a validating parser. Thus, ignorable whitespaces are not being reported even when a DTD is especified
	// Normally you would expect
	// NSArray *textReference = @[ @"Tove", @"Jani", @"Reminder   note", @"Don't forget me & my friends this weekend!" ];
	// NSArray *blanksReference = @[ @"\t  ", @"\t  ", @"\t  " ];
	// But in practice, this is what you get:
	NSArray *textReference = @[ @"  ", @"Tove", @"\t  ", @"Jani", @"\t  ", @"Reminder   note", @"\t  ", @"Don't forget me & my friends this weekend!" ];
	NSArray *blanksReference = @[];
	NSString *commentReference = @" End of the note ";
	
	XCTAssert([texts isEqualToArray:textReference]);
	XCTAssert([blanks isEqualToArray:blanksReference]);
	XCTAssert([comment isEqualToString:commentReference]);
}

- (void) testProcessingInstruction {
	// Reference XML from http://www.w3schools.com/xml/note.xml
	NSString *sampleXML =	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							@"<note>"
								@"<?author name=\"T. Thomas\" date=\"2015-06-27\"?>"
								@"<to>Tove</to>"
								@"<from>Jani</from>"
								@"<heading>Reminder</heading>"
								@"<body>Don't forget me this weekend!</body>"
							@"</note>";
	NSData *xmlData = [sampleXML dataUsingEncoding:NSUTF8StringEncoding];
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
	
	NSMutableDictionary *instructions = [NSMutableDictionary new];
	ByBInPlaceXMLParserDelegate *delegate = [[[ByBInPlaceXMLParserDelegate alloc] init] setFoundProcessingInstructionHandler:^(NSXMLParser *parser, NSString *target, NSString *data) {
		instructions[target] = data;
	}];
	parser.delegate = delegate;
	
	BOOL parseOk = [parser parse];
	XCTAssert(parseOk);
	
	NSDictionary *reference = @{ @"author" : @"name=\"T. Thomas\" date=\"2015-06-27\"" };
	XCTAssert([instructions isEqualToDictionary:reference]);
}

- (NSDictionary *) dictionaryWithElement:(NSString *)element type:(NSString *)type defaultValue:(NSString *)defaultValue
{
	NSMutableDictionary *dict = [NSMutableDictionary new];
	
	if(element != nil)
		dict[kElementKey] = element;
	if(type != nil)
		dict[kTypeKey] = type;
	if(defaultValue != nil)
		dict[kDefaultKey] = defaultValue;
	
	return [dict copy];
}

- (NSDictionary *) dictionaryWithPublicID:(NSString *)publicID systemID:(NSString *)systemID notation:(NSString *)notation
{
	NSMutableDictionary *dict = [NSMutableDictionary new];
	
	if(publicID != nil)
		dict[kPublicKey] = publicID;
	if(systemID != nil)
		dict[kSystemKey] = systemID;
	if(notation != nil)
		dict[kNotationKey] = notation;
	
	return [dict copy];
}

- (NSDictionary *) dictionaryWithPublicID:(NSString *)publicID systemID:(NSString *)systemID
{
	return [self dictionaryWithPublicID:publicID systemID:systemID notation:nil];
}

- (BOOL) parseData:(NSData *)data resolvingExternalEntities:(BOOL)shouldResolveExternals
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
	parser.shouldResolveExternalEntities = shouldResolveExternals;
	
	NSMutableArray *elements = [NSMutableArray new];
	NSMutableDictionary *internals = [NSMutableDictionary new];
	NSMutableDictionary *attributes = [NSMutableDictionary new];
	NSMutableDictionary *externals = [NSMutableDictionary new];
	NSMutableDictionary *unparsed = [NSMutableDictionary new];
	NSMutableDictionary *notations = [NSMutableDictionary new];
	ByBInPlaceXMLParserDelegate *delegate = [[[[[[[[[ByBInPlaceXMLParserDelegate alloc] init] setResolveExternalHandler:^NSData *(NSXMLParser *parser, NSString *entityName, NSString *systemID) {
		NSDictionary *entities = @{ @"internal" : [@"Internal entity" dataUsingEncoding:NSUTF8StringEncoding],
									@"external" : [@"External entity" dataUsingEncoding:NSUTF8StringEncoding],
									@"parsed" : [@"Parsed entity" dataUsingEncoding:NSUTF8StringEncoding]};
		
		return entities[entityName];
	}] setFoundElementDeclarationHandler:^(NSXMLParser *parser, NSString *element, NSString *model) {
		[elements addObject:element];
	}] setFoundAttributeDeclarationHandler:^(NSXMLParser *parser, NSString *attribute, NSString *element, NSString *type, NSString *defaultValue) {
		NSMutableArray *tags = attributes[attribute] ?: [NSMutableArray new];
		[tags addObject:[self dictionaryWithElement:element type:type defaultValue:defaultValue]];
		attributes[attribute] = tags;
	}] setFoundExternalDeclarationHandler:^(NSXMLParser *parser, NSString *name, NSString *publicID, NSString *systemID) {
		externals[name] = [self dictionaryWithPublicID:publicID systemID:systemID];
	}] setFoundInternalDeclarationHandler:^(NSXMLParser *parser, NSString *name, NSString *value) {
		internals[name] = value ?: [NSNull null];
	}] setFoundUnparsedDeclarationHandler:^(NSXMLParser *parser, NSString *name, NSString *publicID, NSString *systemID, NSString *notationName) {
		unparsed[name] = [self dictionaryWithPublicID:publicID systemID:systemID notation:notationName];
	}] setFoundNotationDeclarationHandler:^(NSXMLParser *parser, NSString *name, NSString *publicID, NSString *systemID) {
		notations[name] = [self dictionaryWithPublicID:publicID systemID:systemID];
	}];
	
	parser.delegate = delegate;
	
	BOOL parseOk = [parser parse];
	//XCTAssert(parseOk);
	// parseOk == false, parser.parseError == 111 (XML_ERR_USER_STOP in libxml2)
	
	NSArray *elementsReference = @[ @"test", @"vsr", @"tag1", @"tag2", @"tag3" ];
	NSDictionary *attributesReference = @{ @"internal" : @[	@{ kElementKey : @"tag1",
															   kTypeKey : @"",
															   kDefaultKey : @"true" },
															@{ kElementKey : @"tag2",
															   kTypeKey : @"",
															   kDefaultKey : @"false" } ] };
	NSDictionary *externalsReference = @{ @"parsed" : @{ kSystemKey : @"http://iossdk-xxe.apt.vsecurity.org/" } };
	NSDictionary *internalsReference = @{ @"internal" : @"Internal string" };
	NSDictionary *unparsedReference = @{ @"external" : @{ kSystemKey : @"https://devimages.apple.com.edgekey.net/home/images/adp-wordmark.png",
														  kNotationKey : @"png" } };
	NSDictionary *notationsReference = @{ @"png" : @{ kSystemKey : @"image/png" } };
	
	BOOL elementsOk = [elements isEqualToArray:elementsReference];
	XCTAssert(elementsOk);
	BOOL attributesOk = [attributes isEqualToDictionary:attributesReference];
	XCTAssert(attributesOk);
	BOOL externalsOk = !shouldResolveExternals || [externals isEqualToDictionary:externalsReference];
	XCTAssert(externalsOk);
	BOOL internalsOk = [internals isEqualToDictionary:internalsReference];
	XCTAssert(internalsOk);
	BOOL unparsedOk = [unparsed isEqualToDictionary:unparsedReference];
	XCTAssert(unparsedOk);
	BOOL notationsOk = [notations isEqualToDictionary:notationsReference];
	XCTAssert(notationsOk);
	
	return (parseOk && elementsOk && attributesOk && externalsOk && internalsOk && unparsedOk && notationsOk);
}

// This example always fails!
- (void) testDTD
{
	// Reference XML from http://www.vsecurity.com/download/advisories/20140917-1.txt
	NSString *sampleXML =	@"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
							@"<!DOCTYPE test ["
								@"<!ENTITY external SYSTEM \"https://devimages.apple.com.edgekey.net/home/images/adp-wordmark.png\" NDATA png>"
								@"<!ENTITY internal \"Internal string\">"
								@"<!ENTITY parsed SYSTEM \"http://iossdk-xxe.apt.vsecurity.org/\">"
								@"<!ELEMENT test (vsr)>"
								@"<!ELEMENT vsr (tag1, tag2, tag3)>"
								@"<!ELEMENT tag1 (#PCDATA)>"
								@"<!ELEMENT tag2 (#PCDATA)>"
								@"<!ELEMENT tag3 (#PCDATA)>"
								@"<!NOTATION png SYSTEM \"image/png\">"
								@"<!ATTLIST tag1 internal (true|false) \"true\">"
								@"<!ATTLIST tag2 internal (true|false) \"false\">"
							@"]>"
							@"<test>"
								@"<vsr>"
									@"<tag1 internal=\"true\">&internal;</tag1>"
									@"<tag2>&parsed;</tag2>"
									@"<tag3>&external;</tag3>"
								@"</vsr>"
							@"</test>";
	NSData *xmlData = [sampleXML dataUsingEncoding:NSUTF8StringEncoding];

	XCTAssert([self parseData:xmlData resolvingExternalEntities:NO]);
	XCTAssert([self parseData:xmlData resolvingExternalEntities:YES]);
}

@end
