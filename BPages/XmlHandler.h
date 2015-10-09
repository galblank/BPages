//
//  XmlHandler.h
//  BPages
//
//  Created by Gal Blank on 10/6/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XmlHandler : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)errorPointer;
+ (NSDictionary *)dictionaryNSXmlParseObject:(NSXMLParser *)parserObject error:(NSError *)errorPointer;

@end
