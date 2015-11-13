//
//  Camino+CoreDataProperties.h
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 11/7/15.
//  Copyright © 2015 ITESM. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Camino.h"

NS_ASSUME_NONNULL_BEGIN

@interface Camino (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *idCamino;
@property (nullable, nonatomic, retain) NSSet<PuntoClave *> *tieneMuchosPuntosClave;

@end

@interface Camino (CoreDataGeneratedAccessors)

- (void)addTieneMuchosPuntosClaveObject:(PuntoClave *)value;
- (void)removeTieneMuchosPuntosClaveObject:(PuntoClave *)value;
- (void)addTieneMuchosPuntosClave:(NSSet<PuntoClave *> *)values;
- (void)removeTieneMuchosPuntosClave:(NSSet<PuntoClave *> *)values;

@end

NS_ASSUME_NONNULL_END
