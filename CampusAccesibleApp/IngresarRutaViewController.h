//
//  IngresarRutaViewController.h
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 10/17/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PESGraph/PESGraph.h"
@import GoogleMaps;

@interface IngresarRutaViewController : UIViewController
@property (nonatomic,strong) GMSMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *vwMap;
@property (strong, nonatomic) PESGraph *graph;
@property (strong, nonatomic) GMSMarker *mrkPrincipioI;

@end
