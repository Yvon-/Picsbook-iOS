//
//  YVHCoreDataVC.m
//  Tests
//
//  Created by Yvon Valdepeñas on 24/08/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHCoreDataVC.h"
#import "Pic.h"
#import "YVHAppDelegate.h"
#import "YVHDAO.h"

@interface YVHCoreDataVC ()

@property (weak, nonatomic) IBOutlet UITextField *picname;
@property (weak, nonatomic) IBOutlet UITextField *picpath;
@property (weak, nonatomic) IBOutlet UITextView *textbox;


@end

@implementation YVHCoreDataVC


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.managedObjectContext = [YVHDAO getContext];
    
    [self showData:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [YVHDAO saveContext];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPic:(id)sender {

   // NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];

    
    
    Pic *pic = [Pic insertInManagedObjectContext:self.managedObjectContext];
    pic.name = _picname.text;
    pic.path = @"XXXXXX";
    pic.latitude = @0.234f;
    pic.longitude = @3.123f;
    [self showData:self];
   
    
}
- (IBAction)showData:(id)sender {


    NSArray *array = [self getPics:nil];
    if (array == nil)
    {
        NSLog(@"No hay datos");
    }
    else{
        NSString *text=@"";
        for(Pic *a in array){
            Pic* p = a;
            NSString * s1 = [NSString stringWithFormat:@"*** %@ *** \n %@\n\n",p.name, p.path];
            text = [text stringByAppendingString:s1];
        }
        self.textbox.text = text;
    }
}

- (IBAction)clearPic:(id)sender {
     NSString * s1 = [NSString stringWithFormat:@"name == '%@'",self.picname.text];
   // NSPredicate* p= [NSPredicate predicateWithFormat:@"name &lt; %@", self.picname.text];
    NSPredicate* p= [NSPredicate predicateWithFormat:s1, self.picname.text];
    NSArray* res= [self getPics:p];
    for(Pic *a in res){
        [_managedObjectContext deleteObject:a];
    }
    [self showData:self];
    
}

-(NSArray*)getPics:(NSPredicate*)pred{
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Pic" inManagedObjectContext:_managedObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    if(pred)request.predicate = pred;
    
    [request setEntity:entityDescription];
    
    NSError *error;
    NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"No hay datos");
    }
    return array;
}





- (IBAction)clear:(id)sender {
    self.textbox.text = nil;
}

@end
