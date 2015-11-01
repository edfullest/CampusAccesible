//
//  Bano.h
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//
#import <UIKit/UIKit.h>

@interface Bano : NSObject

@property (nonatomic, strong) NSString *sClave;
@property (nonatomic, strong) NSString *sTipo;
- (id) initWithClave: (NSString *) sClave withTipo: (NSString *) sTipo;


@end
