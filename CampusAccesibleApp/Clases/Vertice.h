//
//  Vertice.h
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//


#import <UIKit/UIKit.h>

@interface Vertice : NSObject

@property (nonatomic, assign) int idVertice;
@property CGFloat fLongitud;
@property CGFloat fLatitud;
@property (nonatomic, strong) NSString *sNombreMapa;

- (id) initWithIdVertice:(int) idVertice
            withLongitud: (CGFloat) fLongitud
            withLatitud: (CGFloat) fLatitud
            withNombreMapa: (NSString *) sNombreMapa;

@end