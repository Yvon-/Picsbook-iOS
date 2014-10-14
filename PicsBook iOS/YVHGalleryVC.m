//
//  YVHGalleryVC.m
//  PicsBook iOS
//
//  Created by Yvon Valdepeñas on 30/09/14.
//  Copyright (c) 2014 Yvon Valdepeñas. All rights reserved.
//

#import "YVHGalleryVC.h"
#import "YVHAppDelegate.h"
#import "Flickr.h"
#import "Pic.h"
#import "YVHPicVC.h"
#import "CVCell.h"
#import "YVHDAO.h"


@interface YVHGalleryVC ()


@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UIView * optionsView;
@property (weak, nonatomic) IBOutlet UIImageView *optionsViewImg;

@property (nonatomic, strong) NSArray *picsArray;
@property (nonatomic, strong) UIImage * pickedImg;
@property (weak, nonatomic) IBOutlet UIView *PicView;
@property (weak, nonatomic) IBOutlet UIImageView *PicViewImg;
@property(nonatomic,assign) BOOL contextHasChange;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

@implementation YVHGalleryVC 

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Change appeareance of uiviews
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    //Coredata Stack access
    self.managedObjectContext = [YVHDAO getContext];
    
    self.picsArray = [YVHDAO  getPics:nil];
    [YVHDAO setSelectedPics:self.picsArray];
    
    UINib *cellNib = [UINib nibWithNibName:@"CVCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];

    self.contextHasChange = NO;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleDataModelChange:)
     name:NSManagedObjectContextObjectsDidChangeNotification
     object: self.managedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showOptions)
                                                 name:@"GalleryOptions"
                                               object:nil];
    [self addOptionsView];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if(self.contextHasChange){
        self.picsArray = [YVHDAO getPics:nil];
        [self.collectionView reloadData];

    }
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    isShowingOptions = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"GalleryVC memory warning");
    // Dispose of any resources that can be recreated.
 //   self.collectionView = nil;
 //   self.picsArray = nil;
}

- (void)handleDataModelChange:(NSNotification *)note
{
//    NSSet *updatedObjects = [[note userInfo] objectForKey:NSUpdatedObjectsKey];
//    NSSet *deletedObjects = [[note userInfo] objectForKey:NSDeletedObjectsKey];
//    NSSet *insertedObjects = [[note userInfo] objectForKey:NSInsertedObjectsKey];
    
    self.contextHasChange = YES;
}

#pragma mark -

-(UIImage *) getPicFromDisk:(NSString*)path{
    NSData *imgData = [NSData dataWithContentsOfFile:path];
    //UIImage *thumbNail = [UIImage imageNamed:@"2014-08-28 19.00.58.jpg"];
    UIImage *img = [[UIImage alloc] initWithData:imgData];
    
    return img;
}

-(UIImage *) getThumnailFromDisk:(NSString*)path{
    NSString * thPath = [self convertToThPath:path];
    NSData *imgData = [NSData dataWithContentsOfFile:thPath];
    UIImage *thumbNail = [[UIImage alloc] initWithData:imgData];
    
    return thumbNail;
}

-(NSString *)convertToThPath:(NSString*)path{
    //int len = [path length];
    return  [path stringByAppendingString:@"_s"];
}




#pragma mark - UI

- (IBAction)backToAlbum:(id)sender {
    self.PicView.hidden = true;
    self.collectionView.hidden = false;
    statusBarHidden = false;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    self.picsArray = [YVHDAO  getPics:nil];
    [YVHDAO setSelectedPics:self.picsArray];
    
    isShowingOptions = false;
}


CGRect hideOptions, showOptions;
-(void)addOptionsView
{
    int options = 3;
    int optionHeight = 40;
    int width = 120;
    int height = optionHeight * options;
    
    //Bar image
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    hideOptions = CGRectMake(screenRect.size.width - width - 35, screenRect.size.height, width, height);
    showOptions = CGRectMake(screenRect.size.width - width - 35, screenRect.size.height - 137 - height, width, height);
    self.optionsView.frame = hideOptions;
    
    self.optionsViewImg.image = [UIImage imageNamed:@"options2.png"];
    [self.view bringSubviewToFront:self.optionsView];
    
}

-(void)addOptionsOnePicView
{
    int options = 3;
    int optionHeight = 40;
    int width = 120;
    int height = optionHeight * options;
    
    //Bar image
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    hideOptions = CGRectMake(screenRect.size.width - width - 35, screenRect.size.height, width, height);
    showOptions = CGRectMake(screenRect.size.width - width - 35, screenRect.size.height - 137 - height, width, height);
    self.optionsView.frame = hideOptions;
    
    self.optionsViewImg.image = [UIImage imageNamed:@"options3.png"];
    [self.view bringSubviewToFront:self.optionsView];
    
}

bool isShowingOptions = false;
-(void)showOptions
{
    [self.view bringSubviewToFront:self.optionsView];
    if(isShowingOptions){
        [UIView animateWithDuration:0.1 animations:^{ self.optionsView.frame = hideOptions;}];
        isShowingOptions = false;
    }
    else{
        self.optionsView.frame = hideOptions;
        [UIView animateWithDuration:0.07 animations:^{ self.optionsView.frame = showOptions;}];
        isShowingOptions = true;
    }
}
	// Initialise our two images
//	UIImage *btnImage = [UIImage imageNamed:@"Galery.png"];
//	UIImage *btnImageSelected = [UIImage imageNamed:@"Galery_s.png"];
    
//    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom]; //Setup the button
//	self.btn1.frame = CGRectMake(screenRect.size.width/8 - 30, self.view.bounds.size.height+10 - 50, 40, 30); // Set the frame (size and position) of the button)
//    
//	[self.btn1 setBackgroundImage:btnImage forState:UIControlStateNormal]; // Set the image for the normal state of the button
//	[self.btn1 setBackgroundImage:btnImageSelected forState:UIControlStateSelected]; // Set the image for the selected state of the button
//	[self.btn1 setTag:0]; // Assign the button a "tag" so when our "click" event is called we know which button was pressed.
//	[self.btn1 setSelected:true]; // Set this button as selected (we will select the others to false as we only want Tab 1 to be selected initially
//    [self.btn1 setImageEdgeInsets:UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0)];
//    [self.btn1.imageView setContentMode:UIViewContentModeScaleAspectFit];
//	
//    
//	
//	// Now we repeat the process for the other buttons
//	btnImage = [UIImage imageNamed:@"mapOff.png"];
//	btnImageSelected = [UIImage imageNamed:@"mapOn.png"];
//	self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
//	self.btn2.frame = CGRectMake(3*screenRect.size.width/8 - 30, self.view.bounds.size.height +5 - 50, 40, 40);
//	[self.btn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
//	[self.btn2 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
//	[self.btn2 setTag:1];
//	
//	btnImage = [UIImage imageNamed:@"cameraOff.png"];
//	btnImageSelected = [UIImage imageNamed:@"cameraOff.png"];
//	self.btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
//	self.btn3.frame = CGRectMake(5*screenRect.size.width/8-20 , self.view.bounds.size.height+5 - 50, 50, 40);
//	[self.btn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
//	[self.btn3 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
//	[self.btn3 setTag:2];
//	
//	btnImage = [UIImage imageNamed:@"menu.png"];
//	btnImageSelected = [UIImage imageNamed:@"menu.png"];
//	self.btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
//	self.btn4.frame = CGRectMake(7*screenRect.size.width/8 -10, self.view.bounds.size.height+10 - 50, 35, 30);
//	[self.btn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
//	[self.btn4 setBackgroundImage:btnImageSelected forState:UIControlStateSelected];
//	[self.btn4 setTag:3];
//    
//    
//	// Add my new buttons to the view
//	[self.view addSubview:btn1];
//	[self.view addSubview:btn2];
//	[self.view addSubview:btn3];
//	[self.view addSubview:btn4];
//	
//	// Setup event handlers so that the buttonClicked method will respond to the touch up inside event.
//	[btn1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//	[btn2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//	[btn3 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//	[btn4 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//}




#pragma mark -
#pragma mark - UICollectionView Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    int n = [self.picsArray count];

    
    return n;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"cvCell";
    
    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    
    NSInteger x = indexPath.row;

    if(x<[self.picsArray count]){
        Pic * data = [self.picsArray objectAtIndex:x];
        UIImage *photo = [self getThumnailFromDisk:data.path];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.image.image = photo;
    }

    
    // Return the cell
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
bool statusBarHidden = false;

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger x = indexPath.row;
    NSInteger y = indexPath.section;
    NSInteger i = x + (y * 3);
    if(i<[self.picsArray count]){
        CGRect s = self.optionsView.frame;
        Pic * data = [self.picsArray objectAtIndex:x];
        self.pickedImg = [self getPicFromDisk:data.path];
        self.PicViewImg.image = self.pickedImg;
        self.PicView.hidden = false;
        self.collectionView.hidden = true;
        s = self.optionsView.frame;
        statusBarHidden = true;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        {
            [self setNeedsStatusBarAppearanceUpdate];
        }

        [YVHDAO setSelectedPics:@[data]];
    }

    isShowingOptions = false;
    
}
- (BOOL)prefersStatusBarHidden
{
    return statusBarHidden;
}
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    
//    if ([segue.identifier isEqualToString:@"segue1"]) {
//        YVHPicVC* picVC = [segue destinationViewController];
//        picVC.img = self.pickedImg ;
//    }
//}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect item
}


#pragma mark -
#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    Pic *data = self.picsArray[indexPath.row];
    UIImage *photo = [self getPicFromDisk:data.path];
    // 2
    CGSize retval = photo.size.width > 0 ? [self reducePic:photo.size] : CGSizeMake(100, 100);
    //CGSize retval = CGSizeMake(100, 100);
    retval.height += 35; retval.width += 35; return retval;
}

-(CGSize)reducePic:(CGSize)sz{
    int w, h, ws, hs ;
    w = sz.width;
    h = sz.height;
    if(w > h ){
        ws = 200;
        hs = h*ws/w;
    }
    else{
        hs = 200;
        ws = w*hs/h;
    }
    
    return CGSizeMake(ws, hs);

}
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    //Es el espacio entre celdas
    return UIEdgeInsetsMake(50, 20, 50, 20);
}



@end
