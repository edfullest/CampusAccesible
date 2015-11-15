//
//  BanosAccesiblesTableViewController.m
//  CampusAccesibleApp
//
//  Created by Ana on 11/9/15.
//  Copyright © 2015 ITESM. All rights reserved.
//

#import "BanosAccesiblesTableViewController.h"
#import "DetalleUbicacionTableViewController.h"

@interface BanosAccesiblesTableViewController ()

@end

@implementation BanosAccesiblesTableViewController

#pragma mark - Managing the edificio

- (void)setEdificio1:(id)newEdificio1 {
    if (_edificio1 != newEdificio1) {
        _edificio1 = newEdificio1;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Cambiar el titulo del botón back
    self.lbAtras.title = [NSString stringWithFormat:@"< %@ ", [self.edificio1 valueForKey:@"nombre"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.edificio1 valueForKey:@"banos"]count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.edificio1 valueForKey:@"banos"][indexPath.row];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)atras:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
    DetalleUbicacionTableViewController *detalleUbicacionTableViewController =
    [self.storyboard instantiateViewControllerWithIdentifier:@"detalleUbicacionTableViewController"];
    [detalleUbicacionTableViewController setEdificio:self.edificio1];
    [self.navigationController pushViewController:detalleUbicacionTableViewController animated:YES];
}
@end
