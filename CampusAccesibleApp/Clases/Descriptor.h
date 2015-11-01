//
//  Descriptor.h
//  
//
//  Created by Eduardo Jesus Serna L on 10/31/15.
//
//

#import <UIKit/UIKit.h>

@interface Descriptor : NSObject

@property (nonatomic, strong) NSString *sNombre;
@property (nonatomic, strong) NSString *sValor;
- (id) initWithNombre: (NSString *) sNombre withValor:sValor;


@end
