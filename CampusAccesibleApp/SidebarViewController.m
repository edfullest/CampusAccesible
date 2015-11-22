//
//  El sidebar fue implementado bajo el siguiente tutorial:
//  http://www.appcoda.com/ios-programming-sidebar-navigation-menu/
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

// Arreglo para el archivo plist
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
    // Carga datos del archivo plist
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
    // Se le suma 1, porque se le agregó la celda "Inicio"
    return self.objects.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    // Si es la celda 0, pondrá la palabra "Inicio". Misma palabra que identifica a la celda 0
    if(indexPath.row == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Inicio" forIndexPath:indexPath];
        cell.textLabel.text = @"Inicio";
    }
    // Carga el campo "Nombre" de la plist
    else{
        UIImage *imagen = [[UIImage alloc]init];
        
        // De la segunda celda en adelante se identifican con el nombre "Cell" (Nombre puesto en el storyboard)
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        NSDictionary *object = self.objects[indexPath.row - 1];
        
        // Despliega el nombre del aula, obtenida de la Plist
        cell.textLabel.text = [object valueForKey:@"nombre"];
        
        // Cambiar icono a gimnasio, centrales, cetec, biotecnología y rectoría
        if ([[[object valueForKey:@"nombre"] description] isEqualToString:@"Gimnasio"]){
            // Asigna imagen
            imagen = [UIImage imageNamed:@"sports.png"];
            cell.imageView.image = imagen;
        }
        else if ([[[object valueForKey:@"nombre"] description] isEqualToString:@"Centrales"]){
            // Asigna imagen
            imagen = [UIImage imageNamed:@"diningRoom.png"];
            cell.imageView.image = imagen;
        }
        else if ([[[object valueForKey:@"nombre"] description] isEqualToString:@"Rectoría"]){
            // Asigna imagen
            imagen = [UIImage imageNamed:@"statue.png"];
            cell.imageView.image = imagen;
        }
        else if ([[[object valueForKey:@"nombre"] description] isEqualToString:@"Centro de Biotecnología"]){
            // Asigna imagen
            imagen = [UIImage imageNamed:@"biotech.png"];
            cell.imageView.image = imagen;
        }
        else if ([[[object valueForKey:@"nombre"] description] isEqualToString:@"CETEC"]){
            // Asigna imagen
            imagen = [UIImage imageNamed:@"workstation.png"];
            cell.imageView.image = imagen;
        }
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    // Si no es la celda "Inicio" se va a Detalle del aula
        if(indexPath.row != 0){
            // Crea un objeto diccionario y se lo envía a la siguiente vista
            NSDictionary *object = self.objects[indexPath.row - 1];
            UINavigationController *navController = segue.destinationViewController;
            DetalleUbicacionTableViewController *detalleController = [navController childViewControllers].firstObject;
            detalleController.edificio = object;
        }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Pop un view
    if(indexPath.row == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
