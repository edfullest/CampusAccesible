//
//  PuntoClave+CoreDataProperties.h
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 11/7/15.
//  Copyright © 2015 ITESM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PuntoClave.h"

NS_ASSUME_NONNULL_BEGIN

@interface PuntoClave (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *idPuntoClave;
@property (nullable, nonatomic, retain) NSNumber *latitud;
@property (nullable, nonatomic, retain) NSNumber *longitud;
@property (nullable, nonatomic, retain) NSString *tipo;
@property (nullable, nonatomic, retain) NSSet<Descriptor *> *tieneMuchosDescriptores;
@property (nullable, nonatomic, retain) Camino *tieneUnCamino;

@end

@interface PuntoClave (CoreDataGeneratedAccessors)

- (void)addTieneMuchosDescriptoresObject:(Descriptor *)value;
- (void)removeTieneMuchosDescriptoresObject:(Descriptor *)value;
- (void)addTieneMuchosDescriptores:(NSSet<Descriptor *> *)values;
- (void)removeTieneMuchosDescriptores:(NSSet<Descriptor *> *)values;

@end

NS_ASSUME_NONNULL_END
