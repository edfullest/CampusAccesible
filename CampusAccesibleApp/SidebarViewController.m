//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "DetalleUbicacionTableViewController.h"
#import "PrincipalViewController.h"


@interface SidebarViewController ()

// Agregar: Cargar datos del archivo plist
@property (strong, nonatomic) NSArray *objects;
@end

@implementation SidebarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Agregar: cargar informacion del archivo plist
    NSString *pathPlist = [[NSBundle mainBundle] pathForResource: @"ListaEdificios" ofType:@"plist"];
    self.objects = [[NSArray alloc] initWithContentsOfFile:pathPlist];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.objects.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Inicio" forIndexPath:indexPath];
        cell.textLabel.text = @"Inicio";
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *object = self.objects[indexPath.row - 1];
        // Despliega el nombre del aula, obtenida de la Plist
        cell.textLabel.text = [object valueForKey:@"nombre"];
        
        // Cambiar icono a gimnasio, centrales, cetec, biotecnología y rectoría
        if ([[[object valueForKey:@"nombre"] description] isEqualToString:@"Gimnasio"]){
            // Crea imagen para asignarla
            UIImage *imagen = [UIImage imageNamed:@"sports.png"];
            cell.imageView.image = imagen;
        }
        else if ([[[object valueForKey:@"nombre"] description] isEqualToString:@"Centrales"]){
            // Crea imagen para asignarla
            UIImage *imagen = [UIImage imageNamed:@"diningRoom.png"];
            cell.imageView.image = imagen;
        }
        else if ([[[object valueForKey:@"nombre"] description] isEqualToString:@"Rectoría"]){
            // Crea imagen para asignarla
            UIImage *imagen = [UIImage imageNamed:@"statue.png"];
            cell.imageView.image = imagen;
        }
        else if ([[[object valueForKey:@"nombre"] description] isEqualToString:@"Centro de Biotecnología"]){
            // Crea imagen para asignarla
            UIImage *imagen = [UIImage imageNamed:@"biotech.png"];
            cell.imageView.image = imagen;
        }
        else if ([[[object valueForKey:@"nombre"] description] isEqualToString:@"CETEC"]){
            // Crea imagen para asignarla
            UIImage *imagen = [UIImage imageNamed:@"workstation.png"];
            cell.imageView.image = imagen;
        }
    }
    
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    
    if ([segue.identifier isEqualToString:@"inicio"]){
        [segue destinationViewController];
    }
    else{
        if(indexPath.row != 0){
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSDictionary *object = self.objects[indexPath.row - 1];
            //[[segue destinationViewController] setDetailItem:object];
            
            UINavigationController *navController = segue.destinationViewController;
            DetalleUbicacionTableViewController *detalleController = [navController childViewControllers].firstObject;
            detalleController.edificio = object;
        }
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
