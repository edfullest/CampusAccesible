//
//  PESNode.m
//  PESGraph
//
//  Created by Peter Snyder on 8/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PESGraphNode.h"

@implementation PESGraphNode

@synthesize identifier;
@synthesize title;
@synthesize additionalData;

+ (PESGraphNode *)nodeWithIdentifier:(NSString *)anIdentifier {

    PESGraphNode *aNode = [[PESGraphNode alloc] init];

    aNode.identifier = anIdentifier;

    return aNode;
}


+ (PESGraphNode *)nodeWithIdentifier:(NSString *)anIdentifier nodeWithDictionary: (NSDictionary *) additionalData {

    PESGraphNode *aNode = [[PESGraphNode alloc] init];

    aNode.identifier = anIdentifier;
    aNode.additionalData = additionalData;

    return aNode;
}



@end
