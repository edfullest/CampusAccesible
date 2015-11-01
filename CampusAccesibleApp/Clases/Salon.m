//
//  Salon.m
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//

#import <Foundation/Foundation.h>
#import "Salon.h"

@implementation Salon

- (id) initWithClave:(NSString *)sClave{
    self = [super init];
    if (self){
        _sClave = sClave;
    }
    return self;
}
@end