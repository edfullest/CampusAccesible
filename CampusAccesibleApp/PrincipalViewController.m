//
//  PrincipalViewController.m
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 10/17/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "PrincipalViewController.h"
#import "DetalleUbicacionTableViewController.h"
#import "PESGraph/PESGraph.h"
#import "PESGraph/PESGraphNode.h"
#import "PESGraph/PESGraphEdge.h"
#import "PESGraph/PESGraphRoute.h"
#import "PESGraph/PESGraphRouteStep.h"

@import GoogleMaps;

@interface PrincipalViewController ()

@end

@implementation PrincipalViewController{
     GMSMapView *mpvMapaTec;
}

- (void)viewDidLoad {
    //Centro del tec: 25.651113, -100.290028
    // Se posiciona la camara en el centro del Tec
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:25.651113
                                                            longitude:-100.290028
                                                                 zoom:17];
    
   
    
    mpvMapaTec = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    // http://stackoverflow.com/questions/23857744/google-maps-ios-sdk-get-tapped-overlay-coordinates
    mpvMapaTec.myLocationEnabled = YES;
    self.view = mpvMapaTec;
    
    mpvMapaTec.delegate = self;
    
    PESGraph *graph = [[PESGraph alloc] init];
    PESGraphNode *aNode = [PESGraphNode nodeWithIdentifier:@"A"];
    PESGraphNode *bNode = [PESGraphNode nodeWithIdentifier:@"B"];
    PESGraphNode *cNode = [PESGraphNode nodeWithIdentifier:@"C"];
    PESGraphNode *dNode = [PESGraphNode nodeWithIdentifier:@"D"];
    PESGraphNode *eNode = [PESGraphNode nodeWithIdentifier:@"E"];
    PESGraphNode *fNode = [PESGraphNode nodeWithIdentifier:@"F"];
    
    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"A <-> B" andWeight:[NSNumber numberWithInt:7]] fromNode:aNode toNode:bNode];
    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"A <-> C" andWeight:[NSNumber numberWithInt:9]] fromNode:aNode toNode:cNode];
    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"A <-> F" andWeight:[NSNumber numberWithInt:14]] fromNode:aNode toNode:fNode];
    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"B <-> C" andWeight:[NSNumber numberWithInt:10]] fromNode:bNode toNode:cNode];
    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"B <-> D" andWeight:[NSNumber numberWithInt:15]] fromNode:bNode toNode:dNode];
    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"C <-> F" andWeight:[NSNumber numberWithInt:2]] fromNode:cNode toNode:fNode];
    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"C <-> D" andWeight:[NSNumber numberWithInt:11]] fromNode:cNode toNode:dNode];
    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"D <-> E" andWeight:[NSNumber numberWithInt:6]] fromNode:dNode toNode:eNode];
    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"E <-> F" andWeight:[NSNumber numberWithInt:9]] fromNode:eNode toNode:fNode];
    
    PESGraphRoute *route = [graph shortestRouteFromNode:aNode toNode:eNode];
    
    for (PESGraphRouteStep *aStep in route.steps) {
        
        if (aStep.edge) {
            
            NSLog([NSString stringWithFormat:@"\t%@ -> %@\n", aStep.node.identifier, aStep.edge]);
            
        } else {
            NSLog([NSString stringWithFormat:@"\t%@ (End)", aStep.node.identifier]);
            //[string appendFormat:@"\t%@ (End)", aStep.node.identifier];
            
        }
    }
     NSLog(@"what");
    Database *database = [Database database];
    [Database verticeInfo];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    DetalleUbicacionTableViewController *detalleUbicacionTableViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"detalleUbicacionTableViewController"];
    [self.navigationController pushViewController:detalleUbicacionTableViewController animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
