//
//  Descriptor+CoreDataProperties.h
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 11/7/15.
//  Copyright © 2015 ITESM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Descriptor.h"

NS_ASSUME_NONNULL_BEGIN

@interface Descriptor (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *nombre;
@property (nullable, nonatomic, retain) NSString *valor;
@property (nullable, nonatomic, retain) PuntoClave *tieneUnPuntoClave;

@end

NS_ASSUME_NONNULL_END
