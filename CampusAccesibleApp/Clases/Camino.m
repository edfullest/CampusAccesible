//
//  Camino.m
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//

#import <Foundation/Foundation.h>
#import "Camino.h"

@implementation Camino

-(id) initWithLongitud: (CGFloat) fLongitud{
    self = [super init];
    if (self){
        _fLongitud = fLongitud;
    }
    return self;
}


@end