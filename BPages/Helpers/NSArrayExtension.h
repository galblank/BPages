//
//  NSArrayExtension.h
//  BPages
//
//  Created by Gal Blank on 10/13/15.
//  Copyright © 2015 Gal Blank. All rights reserved.
//

#ifndef NSArrayExtension_h
#define NSArrayExtension_h

@implementation NSArray (Extensions)

- (NSString*)json
{
    NSString* json = nil;
    
    NSError* error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return (error ? nil : json);
}

@end

#endif /* NSArrayExtension_h */
