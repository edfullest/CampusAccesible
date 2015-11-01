//
//  PuntoClave.h
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//


#import <UIKit/UIKit.h>

@interface PuntoClave : NSObject

@property CGFloat fLongitud;
@property CGFloat fLatitud;
@property (nonatomic, strong) NSString *sTipo;

- (id) initWithLongitud: (CGFloat) fLongitud
               withLatitud:(CGFloat)fLatitud
               withTipo: (NSString *) sTipo;


@end