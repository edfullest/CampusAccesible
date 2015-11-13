//
//  PruebaViewController.h
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 11/9/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
@interface PruebaViewController : UIViewController <GMSMapViewDelegate>

@property (nonatomic,strong) GMSMapView *mapView;
@property (nonatomic,strong) NSMutableArray *puntos;

@end
