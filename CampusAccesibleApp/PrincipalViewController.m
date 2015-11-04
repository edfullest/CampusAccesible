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

@implementation PrincipalViewController

- (void)viewDidLoad {
//    //Se cargan los datos de los nodos
//    NSString *pathPlist = [ [NSBundle mainBundle] pathForResource: @"Property List" ofType: @"plist"];
//    self.nodes = [[NSArray alloc] initWithContentsOfFile: pathPlist];
//    
//    //Centro del tec: 25.651113, -100.290028
//    // Se posiciona la camara en el centro del Tec
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:25.651113
//                                                            longitude:-100.290028
//                                                                 zoom:17];
//     _mpvMapaTec =[GMSMapView mapWithFrame:_vwMain.bounds camera:camera];
//    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(25.651113, -100.290028);
//    GMSMarker *marker = [GMSMarker markerWithPosition:position];
//    marker.title = @"Hello World";
//    marker.map = _mpvMapaTec;
//    
//   
//    
//    _mpvMapaTec = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    // http://stackoverflow.com/questions/23857744/google-maps-ios-sdk-get-tapped-overlay-coordinates
//    _mpvMapaTec.myLocationEnabled = YES;
//    
//    
//    
//    PESGraph *graph = [[PESGraph alloc] init];
//    //Se inicializan los nodos dentro del grafo
//    int i = 0;
//    for (NSDictionary* node in self.nodes) {
//        PESGraphNode *pgnNode = [PESGraphNode nodeWithIdentifier:[@(i) stringValue] nodeWithDictionary:node];
//        
//        
//        i++;
//    }
//    [self.vwMain addSubview:_mpvMapaTec];
    
    [super viewDidLoad];
    //Se cargan los datos de los nodos
    NSString *pathPlist = [ [NSBundle mainBundle] pathForResource: @"Property List" ofType: @"plist"];
    self.nodes = [[NSArray alloc] initWithContentsOfFile: pathPlist];
   
    GMSCameraPosition *cameraPosition=[GMSCameraPosition cameraWithLatitude:25.651113
                                                                                                  longitude:-100.290028
                                                                                                       zoom:17];
    //Se mandan los bounds del vwMap como el frame
    _mapView =[GMSMapView mapWithFrame:_vwMap.bounds camera:cameraPosition];
    _mapView.myLocationEnabled=YES;
    GMSMarker *mrkPrincipio=[[GMSMarker alloc]init];
    GMSMarker *mrkFinal=[[GMSMarker alloc]init];
    
    
    PESGraph *graph = [[PESGraph alloc] init];
    //Se inicializan los nodos dentro del grafo
    int i = 0;
    for (NSDictionary* node in self.nodes) {
        PESGraphNode *pgnNode = [PESGraphNode nodeWithIdentifier:[@(i) stringValue] nodeWithDictionary:node];
        GMSMarker *mark=[[GMSMarker alloc]init];
        NSLog([[node objectForKey:@"longitud"] stringValue]);
        mark.position=CLLocationCoordinate2DMake([[node objectForKey:@"longitud"] floatValue], [[node objectForKey:@"latitud"] floatValue]);
        mark.groundAnchor=CGPointMake(0.5,0.5);
        mark.icon = [GMSMarker markerImageWithColor:[UIColor redColor]];
        mark.map=_mapView;
        mark.title = @"wass";
        i++;
    }

    
    
    [self.vwMap addSubview:_mapView];
    
//
    
//    PESGraphNode *aNode = [PESGraphNode nodeWithIdentifier:@"A"];
//    PESGraphNode *bNode = [PESGraphNode nodeWithIdentifier:@"B"];
//    PESGraphNode *cNode = [PESGraphNode nodeWithIdentifier:@"C"];
//    PESGraphNode *dNode = [PESGraphNode nodeWithIdentifier:@"D"];
//    PESGraphNode *eNode = [PESGraphNode nodeWithIdentifier:@"E"];
//    PESGraphNode *fNode = [PESGraphNode nodeWithIdentifier:@"F"];
//    
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"A <-> B" andWeight:[NSNumber numberWithInt:7]] fromNode:aNode toNode:bNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"A <-> C" andWeight:[NSNumber numberWithInt:9]] fromNode:aNode toNode:cNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"A <-> F" andWeight:[NSNumber numberWithInt:14]] fromNode:aNode toNode:fNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"B <-> C" andWeight:[NSNumber numberWithInt:10]] fromNode:bNode toNode:cNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"B <-> D" andWeight:[NSNumber numberWithInt:15]] fromNode:bNode toNode:dNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"C <-> F" andWeight:[NSNumber numberWithInt:2]] fromNode:cNode toNode:fNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"C <-> D" andWeight:[NSNumber numberWithInt:11]] fromNode:cNode toNode:dNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"D <-> E" andWeight:[NSNumber numberWithInt:6]] fromNode:dNode toNode:eNode];
//    [graph addBiDirectionalEdge:[PESGraphEdge edgeWithName:@"E <-> F" andWeight:[NSNumber numberWithInt:9]] fromNode:eNode toNode:fNode];
//    
//    PESGraphRoute *route = [graph shortestRouteFromNode:aNode toNode:eNode];
//    
//    for (PESGraphRouteStep *aStep in route.steps) {
//        
//        if (aStep.edge) {
//            
//            NSLog([NSString stringWithFormat:@"\t%@ -> %@\n", aStep.node.identifier, aStep.edge]);
//            
//        } else {
//            NSLog([NSString stringWithFormat:@"\t%@ (End)", aStep.node.identifier]);
//            //[string appendFormat:@"\t%@ (End)", aStep.node.identifier];
//            
//        }
//    }


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
