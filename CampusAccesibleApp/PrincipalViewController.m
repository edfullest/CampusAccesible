//
//  PrincipalViewController.m
//  CampusAccesibleApp
//
//  Created by Eduardo Jesus Serna L on 10/17/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "PrincipalViewController.h"
#import "DetalleUbicacionTableViewController.h"
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
