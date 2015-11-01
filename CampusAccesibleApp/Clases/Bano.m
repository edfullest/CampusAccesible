//
//  Bano.m
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//

#import <Foundation/Foundation.h>
#import "Bano.h"

@implementation Bano

-(id)initWithClave:(NSString *)sClave withTipo:(NSString *)sTipo{
    self = [super init];
    if (self){
        _sClave = sClave;
        _sTipo = sTipo;
    }
    return self;
}


@end