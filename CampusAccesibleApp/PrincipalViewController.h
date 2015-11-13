//
//  PrincipalViewController.h
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 10/17/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PESGraph/PESGraph.h"
@import GoogleMaps;

@interface PrincipalViewController : UIViewController <GMSMapViewDelegate>

@property (nonatomic,strong) GMSMapView *mapView;
@property (strong, nonatomic) NSArray *nodes;
@property (strong, nonatomic) IBOutlet UIView *vwMap;
@property (strong, nonatomic) NSArray *edges;
@property (strong, nonatomic) PESGraph *graph;
@property (strong, nonatomic) NSMutableArray * pesNodes;
- (IBAction)limpiarMapa:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
