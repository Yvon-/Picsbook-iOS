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
#import "Face.h"
#import "YVHPicVC.h"
#import "CVCell.h"
#import "FilterCell.h"
#import "PicListCell.h"
#import "YVHDAO.h"
#import <UIKit/UIKit.h>
#import "YVHUtil.h"


@interface YVHGalleryVC ()


@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;

//PicsTable
@property (weak, nonatomic) IBOutlet UIView *picListView;
@property (weak, nonatomic) IBOutlet UITableView *picListTable;


//HeaderView
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *backButtonView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *titlePicLbl;

@property (weak, nonatomic) IBOutlet UIView *numPicsView;
@property (weak, nonatomic) IBOutlet UILabel *numPicsLbl;
@property (weak, nonatomic) IBOutlet UILabel *numPicsTextLbl;

//OptionsViews
@property (weak, nonatomic) IBOutlet UIView *optionsAlbumView;
@property (weak, nonatomic) IBOutlet UIImageView *optionsAlbumImg;
@property (weak, nonatomic) IBOutlet UIView *optionsOnePicView;
@property (weak, nonatomic) IBOutlet UIImageView *optionsOnePicImg;
@property (assign, nonatomic) CGRect hiddenAlbumOptionsFrame;
@property (assign, nonatomic) CGRect hiddenOnePicOptionsFrame;
@property (assign, nonatomic) CGRect shownAlbumOptionsFrame;
@property (assign, nonatomic) CGRect shownOnePicOptionsFrame;

@property (strong, nonatomic) UIButton * AlbumOptionsBtn1;
@property (strong, nonatomic) UIButton * AlbumOptionsBtn2;
@property (strong, nonatomic) UIButton * AlbumOptionsBtn3;

@property (strong, nonatomic) UIButton * OnePicOptionsBtn1;
@property (strong, nonatomic) UIButton * OnePicOptionsBtn2;
@property (strong, nonatomic) UIButton * OnePicOptionsBtn3;
@property (strong, nonatomic) UIButton * OnePicOptionsBtn4;
@property (strong, nonatomic) UIButton * OnePicOptionsBtn5;

//InfoViews
@property (weak, nonatomic) IBOutlet UIView *infoAlbumView;
@property (weak, nonatomic) IBOutlet UIImageView *infoAlbumImg;
@property (assign, nonatomic) CGRect hiddenInfoAlbumFrame;
@property (assign, nonatomic) CGRect shownInfoAlbumFrame;


@property (weak, nonatomic) IBOutlet UIView *infoPicView;
@property (weak, nonatomic) IBOutlet UIImageView *infoPicImg;
@property (assign, nonatomic) CGRect hiddenInfoPicFrame;
@property (assign, nonatomic) CGRect shownInfoPicFrame;

@property (weak, nonatomic) IBOutlet UILabel *nameTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;

@property (weak, nonatomic) IBOutlet UILabel *albumLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl2;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl3;
@property (weak, nonatomic) IBOutlet UILabel *longitudeTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *longitudeLbl;
@property (weak, nonatomic) IBOutlet UILabel *latitudeTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *latitudeLbl;
@property (weak, nonatomic) IBOutlet UILabel *facesTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *facesLbl;


//OnePic View
@property (weak, nonatomic) IBOutlet UIView *PicView;
@property (weak, nonatomic) IBOutlet UIImageView *PicViewImg;

//Filters
@property (strong, nonatomic) NSArray * filterList;
@property (weak, nonatomic) IBOutlet UIView *filtersView;
@property (weak, nonatomic) IBOutlet UICollectionView *filtersCollectionView;

@property (weak, nonatomic) IBOutlet UIView *filterDetailView;
@property (weak, nonatomic) IBOutlet UIView *filterDetailTitleTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *filterDetailTitleLbl;
@property (weak, nonatomic) IBOutlet UIButton *filterDetailSaveBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterDetailCopyBtn;
@property (weak, nonatomic) IBOutlet UIButton *filterDetailCancelBtn;

@property (assign, nonatomic) NSInteger pickedFilter;

@property (assign, nonatomic) CGRect hiddenFiltersFrame;
@property (assign, nonatomic) CGRect shownFiltersFrame;

@property (assign, nonatomic) CGRect hiddenFilterDetailFrame;
@property (assign, nonatomic) CGRect shownFilterDetailFrame;

//Confirmation
@property (weak, nonatomic) IBOutlet UIView *confirmationView;
@property (weak, nonatomic) IBOutlet UILabel *confirmationLbl;
@property (weak, nonatomic) IBOutlet UIView *confirmationButtonsView;
@property (weak, nonatomic) IBOutlet UIButton *confirmationOkButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmationCancelButton;


//Others
@property (weak, nonatomic) IBOutlet UIButton *debugButton;

@property (nonatomic, strong) NSArray *picsArray;
@property (nonatomic, strong) UIImage * pickedImg;
@property (nonatomic, strong) Pic * pickedPic;
@property (nonatomic, assign) int pickedPicIndex;
@property (nonatomic, strong) NSMutableArray *facesFramesArray;

@property(nonatomic,assign) BOOL contextHasChange;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) UIImage* lastPickedImg;





@end

@implementation YVHGalleryVC

//Vars

bool isShowingPicOptions = false;
bool isShowingAlbumOptions = false;
bool isOnePicView = false;
bool isShownAlbumInfo = false;
bool isShownFilters = false;
bool isShownFilterDetail = false;
bool isShownPicInfo = false;
bool isShownFaces = false;
bool isShownConfirmView = false;
bool isStatusBarHidden = false;
float showViewDuration = 0.1;
float showConfirmationMsgDuration = 1;

float hideViewDuration = 0.3;
int radius = 25;

#pragma mark -
#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
   // [self.address addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    
    //Change appeareance of uiviews
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_cork.png"]];
    
    //Coredata Stack access
    self.managedObjectContext = [YVHDAO getContext];
    
    self.picsArray = [YVHDAO  getPics:nil];
    [YVHDAO setSelectedPics:self.picsArray];
    
    UINib *cellNib = [UINib nibWithNibName:@"CVCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];

    UINib *filterCellNib = [UINib nibWithNibName:@"FilterCell" bundle:nil];
    [self.filtersCollectionView registerNib:filterCellNib forCellWithReuseIdentifier:@"filterCell"];
    
    self.contextHasChange = NO;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleDataModelChange:)
     name:NSManagedObjectContextObjectsDidChangeNotification
     object: self.managedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchOptions)
                                                 name:@"GalleryOptions"
                                               object:nil];
    
    //Gestures
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.PicView addGestureRecognizer:singleFingerTap];    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
        
    
    // Adding the swipe gesture on image view
    [self.PicView addGestureRecognizer:swipeLeft];
    [self.PicView addGestureRecognizer:swipeRight];
    [self.PicView addGestureRecognizer:swipeUp];
    
    [self initAlbumView];
    [self initAlbumOptionsView];
    [self initOptionsOnePicView];
    //[self initAlbumInfoView];
    [self initFilterListView];
    [self initPicInfoView];
    [self initFilterDetailView];    
    [self initConfirmView];
    
    
#if DEBUG
    [self initDebugControls];
#endif
    
    self.filterList = @[@"CISepiaTone",//0
                        @"CIFalseColor"  ,//1
                        @"CIColorCube"    ,//2
                        //@"CICrop"     ,//3
                        @"CIColorInvert"    ,//4
                        @"CICircularScreen"    ,//5
                        //@"CICMYKHalftone"    ,//6
                        //@"CIColorClamp"    ,//7
                        //@"CIColorControls"    ,//8
                        //@"CIColorCrossPolynomial"    ,//9
                        @"CIColorPosterize"     ,//10
                        //@"CICrystallize"     ,//11
                        // @"CIEdges"     ,//12
                        // @"CIEdgeWork"     ,//13
                        //@"CIGlassDistortion"     ,//14
                        //@"CIGlassLozenge"     ,//15
                        //@"CIHighlightShadowAdjust"     ,//16
                        //@"CIHistogramDisplayFilter"     ,//17
                        //@"CIDroste"     ,//18
                        //@"CIConvolution7X7"     ,//19
                        //@"CIKaleidoscope"     ,//20
                        //@"CILineOverlay"     ,//21
                        //@"CIPerspectiveTile"     ,//22
                        @"CIPerspectiveTransform"     ,//23
                        @"CIPhotoEffectChrome"     ,//24
                        @"CIPhotoEffectMono"     ,//25
                        @"CIPhotoEffectNoir"     ,//26
                        @"CIPixellate"     ,//27
                        //@"CIQRCodeGenerator"     ,//28
                        //@"CIColorMap"     ,//29
                        //@"CIStraightenFilter"     ,//30
                        
                        ];
}


-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if(self.contextHasChange){
        self.picsArray = [YVHDAO getPics:nil];
        [self.collectionView reloadData];
        [self.picListTable reloadData];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    if (isShowingPicOptions){
        [self switchOnePicOptions];
        isShowingPicOptions = false;
    }
    if (isShowingAlbumOptions){
        [self hideAlbumOptions];
    }
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



#pragma mark - Utils

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

-(UIImage *) getThumnailFromUImage:(UIImage*)originalImage{

    CGSize destinationSize = CGSizeMake(135, 170);
    
    UIGraphicsBeginImageContext(destinationSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(NSString *)convertToThPath:(NSString*)path{
    //int len = [path length];
    return  [path stringByAppendingString:@"_s"];
}

-(CGImageRef )processingImage:(CIImage *)image
                       filter:(CIFilter *)filter{
    
    CIContext *context = [CIContext contextWithOptions:nil];        //1
    //CIImage *image = [CIImage imageWithContentsOfURL:urlImage];     //2
    CIImage *result = [filter valueForKey:kCIOutputImageKey];           //4
    CGImageRef cgImage = [context createCGImage:result
                                       fromRect:[result extent]];
    return cgImage;
}

-(UIImage *)standarFilterToImage:(UIImage *)image
                       filterName:(NSString *)filterName{
    
    UIImageOrientation originalOrientation = image.imageOrientation;
    CGFloat originalScale = image.scale;
    
    CGImageRef cgimg = image.CGImage;
    CIImage * ciimage = [CIImage imageWithCGImage:cgimg];
    
    CIFilter * filter = [CIFilter filterWithName:filterName];
    [filter setValue:ciimage forKey:kCIInputImageKey];
//    if ([filterName isEqualToString:@"CIColorMap"]) {
//        [filter setValue:[NSNumber numberWithFloat:0.8f] forKey:@"inputGradientImage"];
//    }
         //  [filter setValue:[NSNumber numberWithFloat:0.8f] forKey:@"InputIntensity"];
         
    CIContext *context = [CIContext contextWithOptions:nil];        //1
    CIImage *result = [filter valueForKey:kCIOutputImageKey];           //4
    CGImageRef cgImage = [context createCGImage:result
                                       fromRect:[result extent]];
    
    UIImage *newPtImage = [UIImage imageWithCGImage:cgImage scale:originalScale orientation:originalOrientation];
    
    return newPtImage;

}



#pragma mark - UI

- (IBAction)backToAlbum:(id)sender {
    self.PicView.hidden = true;
    //self.collectionView.hidden = false;
    isStatusBarHidden = false;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if(self.contextHasChange){
        self.picsArray = [YVHDAO getPics:nil];
        [self.collectionView reloadData];
        [self.picListTable reloadData];
    }
    [YVHDAO setSelectedPics:self.picsArray];


    if(isShownAlbumInfo){
        [self showAlbumInfo];
    }
    else{
        [self hideAlbumInfo];
    }
    
    
    if (isShownFilterDetail) {
        self.PicViewImg.image = self.pickedImg;
    }
    
    [self voidScreen];
    
    self.titlePicLbl.hidden = true;
    self.titleLbl.hidden = false;
    self.backButtonView.hidden = true;
    self.infoPicView.hidden = true;
    isOnePicView = false;
}

-(void)handleSingleTap{
    [self voidScreen];
    if (isShownFilterDetail) {
        self.PicViewImg.image = self.pickedImg;
    }
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self showNextPicAfterDelete:false];
    }
    
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self showPrevPic];
    }
    
    else if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        [self deletePicConfirm];
    }
}

-(void)refitAlbumHeader{
    
    [self.titleLbl sizeToFit];
    self.titleLbl.center = CGPointMake(self.headerView.center.x,self.titleLbl.center.y);
    
    [self.numPicsTextLbl sizeToFit];

    
    self.numPicsView.frame = CGRectMake(self.titleLbl.frame.origin.x +  self.titleLbl.frame.size.width + 30, self.numPicsView.frame.origin.y , self.numPicsView.frame.size.width, self.numPicsView.frame.size.height);
    self.numPicsLbl.frame = CGRectMake(self.numPicsTextLbl.frame.origin.x +  self.numPicsTextLbl.frame.size.width + 5, self.numPicsLbl.frame.origin.y , self.numPicsLbl.frame.size.width, self.numPicsLbl.frame.size.height);
    

}


int optionHeight = 80;
int optionWidth = 165;
int iconWidth = 50;
float iconAlpha = .8;

-(void)initAlbumOptionsView
{
    int options = 2;
    int height = optionHeight * options;
    UIImage * btnImage;
    
    
    //Bar image
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.hiddenAlbumOptionsFrame = CGRectMake(screenRect.size.width - optionWidth - 5, screenRect.size.height, optionWidth, height);
    self.shownAlbumOptionsFrame = CGRectMake(screenRect.size.width - optionWidth - 5, screenRect.size.height - 57 - height, optionWidth, height);
    self.optionsAlbumView.frame = self.hiddenAlbumOptionsFrame;
    
    self.optionsAlbumImg.image = [UIImage imageNamed:@"options2.png"];
    [self.view bringSubviewToFront:self.optionsAlbumView];
    
    //Buttons
    btnImage = [UIImage imageNamed:@"gridicon_s.png"];
	self.AlbumOptionsBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.AlbumOptionsBtn1.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight/2 - iconWidth/2, iconWidth , iconWidth);
    self.AlbumOptionsBtn1.alpha = iconAlpha;
	[self.AlbumOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.optionsAlbumView addSubview:self.AlbumOptionsBtn1];
    [self.AlbumOptionsBtn1 addTarget:self action:@selector(showAlbumGridView) forControlEvents:UIControlEventTouchUpInside];
    
    btnImage = [UIImage imageNamed:@"listicon.png"];
	self.AlbumOptionsBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.AlbumOptionsBtn2.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight + optionHeight/2 - iconWidth/2, iconWidth, iconWidth);

    self.AlbumOptionsBtn2.alpha = iconAlpha;
	[self.AlbumOptionsBtn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.optionsAlbumView addSubview:self.AlbumOptionsBtn2];
    [self.AlbumOptionsBtn2 addTarget:self action:@selector(showAlbumListView) forControlEvents:UIControlEventTouchUpInside];
    
    /*
    btnImage = [UIImage imageNamed:@"info.png"];
	self.AlbumOptionsBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.AlbumOptionsBtn3.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight*2 + optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
    self.AlbumOptionsBtn3.alpha = iconAlpha;
	[self.AlbumOptionsBtn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.optionsAlbumView addSubview:self.AlbumOptionsBtn3];
    [self.AlbumOptionsBtn3 addTarget:self action:@selector(switchAlbumInfoView) forControlEvents:UIControlEventTouchUpInside];*/
    
}



-(void)initAlbumView{
    [self showAlbumGridView];
    [self showAlbumInfo];
}

-(void)initOptionsOnePicView
{
    int options = 5;
    int height = optionHeight * options;
    UIImage * btnImage;
    
    //Bar image
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.hiddenOnePicOptionsFrame = CGRectMake(screenRect.size.width - optionWidth - 5, screenRect.size.height, optionWidth, height);
    self.shownOnePicOptionsFrame = CGRectMake(screenRect.size.width - optionWidth - 5, screenRect.size.height - 57 - height, optionWidth, height);
    self.optionsOnePicView.frame = self.hiddenOnePicOptionsFrame;
    
    self.optionsOnePicImg.image = [UIImage imageNamed:@"options5.png"];
    [self.view bringSubviewToFront:self.optionsOnePicView];
    
    //Buttons
    //btnImage = [UIImage imageNamed:@"face.png"];
	self.OnePicOptionsBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.OnePicOptionsBtn1.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
	self.OnePicOptionsBtn1.alpha = iconAlpha;
    //[self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.OnePicOptionsBtn1 addTarget:self action:@selector(switchFaces) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsOnePicView addSubview:self.OnePicOptionsBtn1];
    
    btnImage = [UIImage imageNamed:@"filter.png"];
	self.OnePicOptionsBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.OnePicOptionsBtn2.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight + optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
	self.OnePicOptionsBtn2.alpha = iconAlpha;
    [self.OnePicOptionsBtn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.OnePicOptionsBtn2 addTarget:self action:@selector(toFilters) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsOnePicView addSubview:self.OnePicOptionsBtn2];
    
    btnImage = [UIImage imageNamed:@"share.png"];
	self.OnePicOptionsBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.OnePicOptionsBtn3.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight*2 + optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
	self.OnePicOptionsBtn3.alpha = iconAlpha;
    [self.OnePicOptionsBtn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.OnePicOptionsBtn3 addTarget:self action:@selector(toShare) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsOnePicView addSubview:self.OnePicOptionsBtn3];
    
    btnImage = [UIImage imageNamed:@"delete-256.png"];
	self.OnePicOptionsBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.OnePicOptionsBtn4.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight*3 + optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
    self.OnePicOptionsBtn4.alpha = iconAlpha;
	[self.OnePicOptionsBtn4 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.OnePicOptionsBtn4 addTarget:self action:@selector(deletePicConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsOnePicView addSubview:self.OnePicOptionsBtn4];
    
    btnImage = [UIImage imageNamed:@"info.png"];
	self.OnePicOptionsBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
	self.OnePicOptionsBtn5.frame = CGRectMake(optionWidth/2 - iconWidth/2, optionHeight*4 + optionHeight/2 - iconWidth/2, iconWidth, iconWidth);
    self.OnePicOptionsBtn5.alpha = iconAlpha;
	[self.OnePicOptionsBtn5 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [self.OnePicOptionsBtn5 addTarget:self action:@selector(switchPicInfoView) forControlEvents:UIControlEventTouchUpInside];
    [self.optionsOnePicView addSubview:self.OnePicOptionsBtn5];
    
}

-(void)initAlbumInfoView{
  //  int options = 1;
  //  int height = optionHeight * options;
    int infoViewWidth = 450;
    int infoViewHeight = 400;
    
    //Bar image
    self.hiddenInfoAlbumFrame = CGRectMake(0 - infoViewWidth, 500, infoViewWidth, infoViewHeight);
    self.shownInfoAlbumFrame = CGRectMake(0 , 500, infoViewWidth, infoViewHeight);
    self.infoAlbumView.frame = self.hiddenInfoAlbumFrame;
    
    self.infoAlbumImg.image = [UIImage imageNamed:@"infoBg.png"];
    [self.view bringSubviewToFront:self.infoAlbumView];
}

-(void)initPicInfoView{
    //  int options = 1;
    //  int height = optionHeight * options;
    int infoViewWidth = 550;
    int infoViewHeight = 355;
    
    //Bar image
    self.hiddenInfoPicFrame = CGRectMake(0 - infoViewWidth, 60, infoViewWidth, infoViewHeight);
    self.shownInfoPicFrame = CGRectMake(0 -radius , 60, infoViewWidth, infoViewHeight);
    self.infoPicView.frame = self.hiddenInfoPicFrame;
    
    self.infoPicView.layer.cornerRadius = radius;
    self.infoPicView.clipsToBounds = YES;
    
    self.infoPicImg.image = [UIImage imageNamed:@"infoBg2.png"];

    [self.view bringSubviewToFront:self.infoPicView];
    
}

-(void)initFilterListView{
    
    
    CGRect v = self.filtersView.frame;
    
    self.hiddenFiltersFrame = CGRectMake(0 - v.size.width, v.origin.y, v.size.width, v.size.height);
    self.shownFiltersFrame = CGRectMake(0 - radius, v.origin.y, v.size.width, v.size.height);
    self.filtersView.frame = self.hiddenFiltersFrame;
    
    self.filtersView.layer.cornerRadius = radius;
    self.filtersView.clipsToBounds = YES;
    
    [self.view bringSubviewToFront:self.filtersView];
}

-(void)initFilterDetailView{
    int buttonRadius = 5;
    
    CGRect v = self.filterDetailView.frame;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.hiddenFilterDetailFrame = CGRectMake(v.origin.x, screenRect.size.height, v.size.width, v.size.height);
    self.shownFilterDetailFrame = CGRectMake(v.origin.x, screenRect.size.height - 57 - v.size.height, v.size.width, v.size.height);
    self.filterDetailView.frame = self.hiddenFilterDetailFrame;
    
    self.filterDetailView.layer.cornerRadius = radius;
    self.filterDetailView.clipsToBounds = YES;
    
    self.filterDetailTitleTextLbl = NSLocalizedString(@"FILTER", nil);
    
    [self.filterDetailSaveBtn setTitle: NSLocalizedString(@"SAVE_CHANGES", nil) forState: UIControlStateNormal];
    [self.filterDetailCopyBtn setTitle: NSLocalizedString(@"SAVE_COPY", nil) forState: UIControlStateNormal];
    [self.filterDetailCancelBtn setTitle: NSLocalizedString(@"CANCEL", nil) forState: UIControlStateNormal];
    
    self.filterDetailSaveBtn.layer.cornerRadius = buttonRadius;
    self.filterDetailCopyBtn.layer.cornerRadius = buttonRadius;
    self.filterDetailCancelBtn.layer.cornerRadius = buttonRadius;
    self.filterDetailSaveBtn.clipsToBounds = YES;
    self.filterDetailCopyBtn.clipsToBounds = YES;
    self.filterDetailCancelBtn.clipsToBounds = YES;
    
    
    [self.view bringSubviewToFront:self.filterDetailView];
}


-(void)initDebugControls{
    
    self.debugButton.hidden = false;
  
}


-(void)initConfirmView{
    int buttonRadius = 5;
    
    [self.confirmationOkButton setTitle: NSLocalizedString(@"CONFIRM", nil) forState: UIControlStateNormal];
    [self.confirmationCancelButton setTitle: NSLocalizedString(@"CANCEL", nil) forState: UIControlStateNormal];
    
    self.confirmationOkButton.layer.cornerRadius = buttonRadius;
    self.confirmationCancelButton.layer.cornerRadius = buttonRadius;
    self.confirmationView.layer.cornerRadius = radius;
    self.confirmationOkButton.clipsToBounds = YES;
    self.confirmationCancelButton.clipsToBounds = YES;
    self.confirmationView.clipsToBounds = YES;
    
    [self hideConfirmView];
    [self.view bringSubviewToFront:self.confirmationView];
}



-(void)switchOptions{
    if(isOnePicView){
        [self switchOnePicOptions];
    }
    else{
        [self switchAlbumOptions];
    }
}


-(void)switchPicInfoView
{
    if(isShownPicInfo){
        [self hidePicInfo];
    }
    else{
        [self showPicInfo];
    }
}

-(void)switchAlbumOptions
{
    if(isShowingAlbumOptions){
        [self hideAlbumOptions];
    }
    else{
        [self showAlbumOptions];
    }
}



-(void)switchOnePicOptions
{
    if(isShowingPicOptions){
        [UIView animateWithDuration:hideViewDuration animations:^{ self.optionsOnePicView.frame = self.hiddenOnePicOptionsFrame;}];
        isShowingPicOptions = false;
    }
    else{
        self.optionsOnePicView.frame = self.hiddenOnePicOptionsFrame;
        [UIView animateWithDuration:showViewDuration animations:^{ self.optionsOnePicView.frame = self.shownOnePicOptionsFrame;}];
        isShowingPicOptions = true;
    }
}





-(void)switchAlbumInfoView
{
    if(isShownAlbumInfo){
        [self hideAlbumInfo];
    }
    else{
        [self showAlbumInfo];
    }
}



-(void)switchFiltersView
{
    if(isShownFilters){
        [self hideFilters];
    }
    else{
        [self showFilters];
    }
}


-(void)switchFaces
{
    if(isShownFaces){
        [self hideFaces];
    }
    else{
        [self showFaces];
    }
}

-(void)showAlbumGridView{
    [self.AlbumOptionsBtn1 setBackgroundImage:[UIImage imageNamed:@"gridicon_s.png"] forState:UIControlStateNormal];
    [self.AlbumOptionsBtn2 setBackgroundImage:[UIImage imageNamed:@"listicon.png"] forState:UIControlStateNormal];
    self.picListView.hidden = true;
    self.collectionView.hidden = false;
    
    [self hideAlbumOptions];
}
-(void)showAlbumListView{
    [self.AlbumOptionsBtn1 setBackgroundImage:[UIImage imageNamed:@"gridicon.png"] forState:UIControlStateNormal];
    [self.AlbumOptionsBtn2 setBackgroundImage:[UIImage imageNamed:@"listicon_s.png"] forState:UIControlStateNormal];
    self.picListView.hidden = false;
    self.collectionView.hidden = true;
    
    [self hideAlbumOptions];
}


-(void)showOnePicViewAtIndex:(NSIndexPath*)indexPath{
    NSInteger x = indexPath.row;
    NSInteger y = indexPath.section;
    NSInteger i = x + (y * 3);
    if(i<[self.picsArray count]){
        
        self.lastPickedImg = self.pickedImg;
        self.pickedPic = [self.picsArray objectAtIndex:x];
        self.pickedPicIndex = x;
        
        self.pickedImg = [self getPicFromDisk:self.pickedPic.path];
        self.PicViewImg.image = self.pickedImg;
        self.PicView.hidden = false;
       // self.collectionView.hidden = true;
        
        isStatusBarHidden = true;
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
        {
            [self setNeedsStatusBarAppearanceUpdate];
        }
        
        [YVHDAO setSelectedPics:@[self.pickedPic]];
        self.titlePicLbl.text = self.pickedPic.name;
        
        if(self.pickedPic.pic_face.count == 0){
            UIImage * btnImage = [UIImage imageNamed:@"face_off.png"];
            [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
            self.OnePicOptionsBtn1.userInteractionEnabled = false;
        }
        else
        {
            UIImage * btnImage;
            if(isShownFaces){
                btnImage = [UIImage imageNamed:@"face_s.png"];
            }
            else{
               btnImage =  [UIImage imageNamed:@"face.png"];
            }
            
            [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
            self.OnePicOptionsBtn1.userInteractionEnabled = true;
        }
    }
    
    self.infoPicView.hidden = false;
    self.headerView.hidden = false;
    self.numPicsView.hidden = true;
    self.backButtonView.hidden = false;
    self.titleLbl.hidden = true;
    self.titlePicLbl.hidden = false;
    
    
    if(isShowingAlbumOptions){
        [self hideAlbumOptions];
    }
    if(isShownPicInfo){
        [self showPicInfo];
    }
    isOnePicView = true;
}


-(void)showAlbumOptions
{
    self.optionsAlbumView.frame = self.hiddenAlbumOptionsFrame;
    [UIView animateWithDuration:0.07 animations:^{ self.optionsAlbumView.frame = self.shownAlbumOptionsFrame;}];
    isShowingAlbumOptions = true;
    
}



-(void)showConfirmView{
    self.confirmationView.hidden = false;
    isShownConfirmView = true;
}



-(void)showAlbumInfo{
    //[UIView animateWithDuration:0.07 animations:^{ self.infoAlbumView.frame = self.shownInfoAlbumFrame;}];
    
    self.titleLbl.text = NSLocalizedString(@"SINGLE_ALBUM_TITLE", nil);
    self.numPicsTextLbl.text = NSLocalizedString(@"ALBUM_NUM_PICS", nil);
    self.numPicsLbl.text = [NSString stringWithFormat: @"%d", self.picsArray.count];
    self.numPicsView.hidden = false;
    self.headerView.hidden = false;
    self.backButtonView.hidden = true;
    self.titleLbl.hidden = false;
    
    [self refitAlbumHeader];
    
    isShownAlbumInfo = true;
    [self hideAlbumOptions];
    UIImage * btnImage = [UIImage imageNamed:@"info_s.png"];
	//[self.AlbumOptionsBtn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
}




-(void)showPicInfo{
    UIImage * btnImage = [UIImage imageNamed:@"info_s.png"];
	[self.OnePicOptionsBtn5 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    self.nameTextLbl.text = NSLocalizedString(@"PIC_NAME", nil);
    self.nameLbl.text = self.pickedPic.name;
    
    self.albumLbl.text = NSLocalizedString(@"SINGLE_ALBUM_TITLE", nil);
    
    self.facesTextLbl.text = NSLocalizedString(@"PIC_FACES", nil);
    self.facesLbl.text = [NSString stringWithFormat: @"%d", self.pickedPic.pic_face.count];
    

    self.longitudeTextLbl.text = NSLocalizedString(@"PIC_LONG", nil);
    self.longitudeLbl.text = [self.pickedPic.longitude stringValue];
    self.latitudeTextLbl.text = NSLocalizedString(@"PIC_LAT", nil);
    self.latitudeLbl.text = [self.pickedPic.latitude stringValue];
    
    self.addressTextLbl.text = NSLocalizedString(@"PIC_ADDRESS", nil);
    
    CLLocation * selectedLocation = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)[self.pickedPic.latitude doubleValue]
                                                  longitude:(CLLocationDegrees)[self.pickedPic.longitude doubleValue]];
    if(!self.pickedPic.address && self.pickedPic.latitude){
        self.pickedPic = [[YVHUtil getInstance] getReverseGeocodeLocation:selectedLocation forPic:self.pickedPic];
        [YVHDAO saveContext];
    }//Para que intente recalcular otra vez si le falta
    
    if(self.pickedPic.address){
        self.addressLbl.textColor = [UIColor whiteColor];
        self.addressLbl.text = self.pickedPic.address;
        self.addressLbl2.text = [NSString stringWithFormat:@"%@ - %@ ", self.pickedPic.zip, self.pickedPic.city];
        self.addressLbl3.text = [NSString stringWithFormat:@"%@ %@", [self.pickedPic.area isEqualToString:self.pickedPic.city]?@"":[self.pickedPic.area stringByAppendingString: @" - " ], self.pickedPic.country];
    }
    else{
        self.addressLbl.textColor = [UIColor orangeColor];
        self.addressLbl.text = NSLocalizedString(@"NO_LOCALIZED", nil);
        self.addressLbl2.text = @"";
        self.addressLbl3.text = @"";
    }
    
    [UIView animateWithDuration:showViewDuration  animations:^{ self.infoPicView.frame = self.shownInfoPicFrame;}];
    isShownPicInfo = true;
    //[self switchOnePicOptions];
}


-(void)showFilters
{
    if (isShownPicInfo) {
        [self hidePicInfo];
    }
    
    UIImage * btnImage = [UIImage imageNamed:@"filter_s.png"];
    [self.OnePicOptionsBtn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    if(self.lastPickedImg != self.pickedImg){
        [self.filtersCollectionView reloadData];
        self.lastPickedImg = self.pickedImg;
    }
    

    
    [UIView animateWithDuration:showViewDuration animations:^{ self.filtersView.frame = self.shownFiltersFrame;}];
    isShownFilters = true;
    

}

-(void)showFilter:(NSNumber *)filterId{
    
    switch ([filterId integerValue]) {
        case 1:
            
            break;
            
        default:
            break;
    }
    
}

-(void)showFilterDetail:(NSString *)filterName
{
    self.filterDetailTitleLbl.text = filterName;
    [UIView animateWithDuration:showViewDuration animations:^{ self.filterDetailView.frame = self.shownFilterDetailFrame;}];
    isShownFilterDetail = true;
}


-(void)showFaces{
    isShownFaces = true;
    
    UIImage * btnImage;
    if(self.pickedPic.pic_face.count == 0){
        btnImage = [UIImage imageNamed:@"face_off.png"];
    }
    else{
        btnImage = [UIImage imageNamed:@"face_s.png"];
    }
    [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    self.facesFramesArray = [@[] mutableCopy];
    
    for(Face * f in  self.pickedPic.pic_face ){
        CGRect c = CGRectFromString(f.nsrectstring);
        UIImageView * v = [[UIImageView alloc]init];
        v.image = [UIImage imageNamed:@"faceFrame.png"];
        v.frame = [self refitFrame:c];
        CGRect c2 = v.frame;
        [self.facesFramesArray addObject:v];
    }
    
    for(UIImageView * v in self.facesFramesArray){
        v.alpha = .5;
        [self.view addSubview:v];
         CGRect c2 = v.frame;
    }
    
    
}



-(void)showConfirmDeleteMsg
{
    self.confirmationLbl.text = NSLocalizedString(@"DELETE_CONFIRMED", nil);
    self.confirmationLbl.frame = CGRectMake(self.confirmationLbl.frame.origin.x,
                                            45,
                                            self.confirmationLbl.frame.size.width,
                                            self.confirmationLbl.frame.size.height);
    self.confirmationButtonsView.hidden = true;
    [self showConfirmView];
    
    
    [NSTimer scheduledTimerWithTimeInterval:.7
                                     target:self
                                   selector:@selector(deleteCompletion)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)showConfirmMsg:(NSString*)msg{
    self.confirmationLbl.text = msg;
    self.confirmationLbl.frame = CGRectMake(self.confirmationLbl.frame.origin.x,
                                            45,
                                            self.confirmationLbl.frame.size.width,
                                            self.confirmationLbl.frame.size.height);
    self.confirmationButtonsView.hidden = true;
    [self showConfirmView];
    
    
    [NSTimer scheduledTimerWithTimeInterval:.7
                                     target:self
                                   selector:@selector(hideConfirmView)
                                   userInfo:nil
                                    repeats:NO];
    
}



-(void)showNextPicAfterDelete:(bool)afterDelete{
    int index = self.pickedPicIndex;
    int next;
    
    if(afterDelete){
        if(index >= self.picsArray.count){
            next = 0;
        }
        else if(index == self.picsArray.count-1){
            next = index;
            
        }
        else{
            next = index + 1 ;
        }
    }
    else{
        if(index >= self.picsArray.count-1){
            next = 0;
        }
        else{
            next = index+1 ;
        }
    }

   

    self.pickedPic = [self.picsArray objectAtIndex:next];
    self.pickedPicIndex = next;
    self.pickedImg = [self getPicFromDisk:self.pickedPic.path];
    [YVHDAO setSelectedPics:@[self.pickedPic]];
    
    [UIView transitionWithView:self.PicViewImg
                      duration:.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.PicViewImg.image = self.pickedImg;;
                    } completion:nil];
    
    self.titlePicLbl.text = self.pickedPic.name;
    
    if (isShownPicInfo) {
        [self showPicInfo];
    }
    
    if (isShownFaces) {
        [self hideFaces];
        [self showFaces];
    }
    
    if(isShownFilters){
        [self.filtersCollectionView reloadData];
    }
    
    if(self.pickedPic.pic_face.count == 0){
        UIImage * btnImage = [UIImage imageNamed:@"face_off.png"];
        [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
        self.OnePicOptionsBtn1.userInteractionEnabled = false;
    }
    else
    {
        UIImage * btnImage;
        if(isShownFaces){
            btnImage = [UIImage imageNamed:@"face_s.png"];
        }
        else{
            btnImage = [UIImage imageNamed:@"face.png"];
        }
        
        [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
        self.OnePicOptionsBtn1.userInteractionEnabled = true;
    }
    
}

-(void)showPrevPic{
    int index = self.pickedPicIndex;
    int prev;
    
    if(index == 0){
        prev = self.picsArray.count-1;
    }
    else{
        prev = index-1 ;
    }
    
    self.pickedPic = [self.picsArray objectAtIndex:prev];
    self.pickedPicIndex = prev;
    self.pickedImg = [self getPicFromDisk:self.pickedPic.path];
    [YVHDAO setSelectedPics:@[self.pickedPic]];
 
    [UIView transitionWithView:self.PicViewImg
                      duration:.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.PicViewImg.image = self.pickedImg;;
                    } completion:nil];
    
    self.titlePicLbl.text = self.pickedPic.name;
    
    if (isShownPicInfo) {
        [self showPicInfo];
    }
    
    if(isShownFilters){
        [self.filtersCollectionView reloadData];
    }
    
    if (isShownFaces) {
        [self hideFaces];
        [self showFaces];
    }
    
    if(self.pickedPic.pic_face.count == 0){
        UIImage * btnImage = [UIImage imageNamed:@"face_off.png"];
        [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
        self.OnePicOptionsBtn1.userInteractionEnabled = false;
    }
    else
    {
        UIImage * btnImage;
        if(isShownFaces){
            btnImage = [UIImage imageNamed:@"face_s.png"];
        }
        else{
            btnImage = [UIImage imageNamed:@"face.png"];
        }
        
        [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
        self.OnePicOptionsBtn1.userInteractionEnabled = true;
    }
}

-(void)hideAlbumInfo
{
    self.headerView.hidden = true;
    isShownAlbumInfo = false;
    [self hideAlbumOptions];
    UIImage * btnImage = [UIImage imageNamed:@"info.png"];
	[self.AlbumOptionsBtn3 setBackgroundImage:btnImage forState:UIControlStateNormal];
    //[UIView animateWithDuration:0.1 animations:^{ self.infoAlbumView.frame = self.hiddenInfoAlbumFrame;}];
}


-(void)hideAlbumOptions
{
    [UIView animateWithDuration:0.1 animations:^{ self.optionsAlbumView.frame = self.hiddenAlbumOptionsFrame;}];
    isShowingAlbumOptions = false;
}


-(void)hidePicInfo
{
    UIImage * btnImage = [UIImage imageNamed:@"info.png"];
	[self.OnePicOptionsBtn5 setBackgroundImage:btnImage forState:UIControlStateNormal];
    [UIView animateWithDuration:hideViewDuration animations:^{ self.infoPicView.frame = self.hiddenInfoPicFrame;}];
    isShownPicInfo = false;
    
    
}


-(void)hideFilterDetail
{
    [UIView animateWithDuration:showViewDuration animations:^{ self.filterDetailView.frame = self.hiddenFilterDetailFrame;}];
    isShownFilterDetail = false;
}


-(void)hideFilters
{

    [UIView animateWithDuration:hideViewDuration animations:^{ self.filtersView.frame = self.hiddenFiltersFrame;}];
    isShownFilters = false;
    UIImage * btnImage = [UIImage imageNamed:@"filter.png"];
    [self.OnePicOptionsBtn2 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    
}

-(void)hideFaces
{
    
    //[UIView animateWithDuration:hideViewDuration animations:^{ self.filtersView.frame = self.hiddenFiltersFrame;}];
    isShownFaces = false;
    UIImage * btnImage;
    if(self.pickedPic.pic_face.count == 0){
        btnImage = [UIImage imageNamed:@"face_off.png"];
    }
    else{
        btnImage = [UIImage imageNamed:@"face.png"];
    }
    [self.OnePicOptionsBtn1 setBackgroundImage:btnImage forState:UIControlStateNormal];
    
    for(UIImageView * v in self.facesFramesArray){
        [v removeFromSuperview];
    }
    
    
}

-(void)hideConfirmView{
    self.confirmationView.hidden = true;
    isShownConfirmView = false;
}

-(void)toFilters{
    
    [self switchFiltersView];
    
}






-(void)toShare{
    UIActivityViewController * controller = [[UIActivityViewController alloc]initWithActivityItems:@[self.pickedImg] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

-(void)deletePicConfirm{
    self.confirmationLbl.frame = CGRectMake(self.confirmationLbl.frame.origin.x,
                                            20,
                                            self.confirmationLbl.frame.size.width,
                                            self.confirmationLbl.frame.size.height);
    self.confirmationLbl.text = NSLocalizedString(@"DELETE_CONFIRM", nil);
    self.confirmationButtonsView.hidden = false;
    [self showConfirmView];
}

-(void)deletePic{
    NSString * name = self.pickedPic.name;
    
    //Lo eliminamos del array
    NSMutableArray * mut = [NSMutableArray arrayWithArray:self.picsArray];
    [mut removeObject:self.pickedPic];
    self.picsArray = [NSArray arrayWithArray:mut];
    
    //Borramos en CoreData
    NSString * s1 = [NSString stringWithFormat:@"name == '%@'", name];
    // NSPredicate* p= [NSPredicate predicateWithFormat:@"name &lt; %@", self.picname.text];
    NSPredicate* p = [NSPredicate predicateWithFormat:s1, self.pickedPic.name];
    NSArray* res = [YVHDAO getPics:p];
    for(Pic *a in res){
        [self.managedObjectContext deleteObject:a];
    }
    [YVHDAO saveContext];
    
    //Borramos en disco
    [self removeImage:name];
    [self removeImage:[name stringByAppendingString:@"_s"]]; //Borramos el thumbnail
    
    
    
    
}

- (void)removeImage:(NSString *)fileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        NSLog(@"delete file ");
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

-(void)deleteCompletion{
    [self hideConfirmView];
    if(self.picsArray.count > 0){
        [self showNextPicAfterDelete:true];
    }
    else{
        [self backToAlbum:nil];
    }
    
}

- (IBAction)saveFilterImg:(id)sender {
    [[YVHUtil getInstance] saveImage:self.PicViewImg.image currentPic:self.pickedPic isNewImage:NO withName:nil];
    [YVHDAO saveContext];
    self.pickedImg = self.PicViewImg.image;
    [self voidScreen];
    [self showConfirmMsg:NSLocalizedString(@"SAVE_CONFIRMED", nil)];
}

- (IBAction)saveFilterNewImg:(id)sender {
    Pic * newPic =  [Pic insertInManagedObjectContext:self.managedObjectContext];
    
    NSString * newName = [NSString stringWithFormat:@"%@  %@",self.pickedPic.name, [self.filterList objectAtIndex:self.pickedFilter]];
    newPic.name = newName;
    newPic.latitude = self.pickedPic.latitude;
    newPic.longitude = self.pickedPic.longitude;
    
    //Search for faces in new filtered image
    NSArray * facesRect = [[YVHUtil getInstance] faceDetectInImage:self.PicViewImg.image];
    
    //Añadimos a Core data
    for(NSString * s in facesRect){
        Face * faceRect = [Face  insertInManagedObjectContext:self.managedObjectContext];
        faceRect.nsrectstring = s;
        [newPic addPic_faceObject:faceRect];
    }
    
    newPic = [[YVHUtil getInstance] saveImage:self.PicViewImg.image currentPic:newPic isNewImage:YES withName:newName];
    [YVHDAO saveContext];
    [self showConfirmMsg:NSLocalizedString(@"SAVECOPY_CONFIRMED", nil)];
}

- (IBAction)cancelFilter:(id)sender {
    [self hideFilterDetail];
    self.PicViewImg.image = self.pickedImg;
}

- (IBAction)prevFilter:(id)sender {
    if (self.pickedFilter == 0) {
        self.pickedFilter = self.filterList.count -1;
    }else{
        self.pickedFilter -= 1;
    }
    
    NSString * filter = [self.filterList objectAtIndex:self.pickedFilter];
    UIImage * photo = self.pickedImg;
    UIImage * fphoto = [self standarFilterToImage:photo filterName:filter];
    self.PicViewImg.image = fphoto;
    
    [self showFilterDetail:filter];
    
}
- (IBAction)postFilter:(id)sender {
    if (self.pickedFilter == self.filterList.count -1) {
        self.pickedFilter = 0;
    }else{
        self.pickedFilter += 1;
    }
    
    NSString * filter = [self.filterList objectAtIndex:self.pickedFilter];
    UIImage * photo = self.pickedImg;
    UIImage * fphoto = [self standarFilterToImage:photo filterName:filter];
    self.PicViewImg.image = fphoto;
    
    [self showFilterDetail:filter];
}

- (IBAction)confirmAction:(id)sender {
    [self deletePic];
    [self hideConfirmView];
    
    [NSTimer scheduledTimerWithTimeInterval:.2
                                     target:self
                                   selector:@selector(showConfirmDeleteMsg)
                                   userInfo:nil
                                    repeats:NO];
    
}



- (IBAction)cancelAction:(id)sender {
    [self hideConfirmView];
}

-(CGRect)refitFrame:(CGRect)c{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return CGRectMake(c.origin.x, screenRect.size.height-c.origin.y-c.size.height, c.size.width, c.size.height);
}


-(void)voidScreen{
    if(isShowingPicOptions){
        [self switchOnePicOptions];
    }
    
    if(isShownPicInfo){
        [self hidePicInfo];
    }
    
    if(isShownFilters){
        [self hideFilters];
    }
    
    if (isShownFilterDetail) {
        [self hideFilterDetail];
    }
    
    if (isShownConfirmView) {
        [self hideConfirmView];
    }

    if (isShownFaces) {
        [self hideFaces];
    }
}



#pragma mark -
#pragma mark - UICollectionView Datasource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int n;
    
    if (collectionView == self.collectionView) {
        n = [self.picsArray count];
    }
    else{
        n = self.filterList.count;
    }
    return n;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.collectionView) {
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
    else{ // if (collectionView == self.filtersCollectionView){
        
        FilterCell *cell = (FilterCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"filterCell" forIndexPath:indexPath];
        

        
        int x = indexPath.row;
        
        if(x<[self.filterList count]){
            
            
            if(isOnePicView){
                NSString * filter = [self.filterList objectAtIndex:x];
                UIImage * photo = self.pickedImg;
                UIImage * thumb = [self getThumnailFromUImage:photo];
                UIImage * fthumb = [self standarFilterToImage:thumb filterName:filter];
                cell.image.image = fthumb;
            }

        }
        
        
        // Return the cell
        return cell;
    }
    

    
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView == self.collectionView) {
        [self showOnePicViewAtIndex:indexPath];
    }
    else{// Filters collection
        
        int x = indexPath.row;
        
        if(x<[self.filterList count]){
            
            NSString * filter = [self.filterList objectAtIndex:x];
            UIImage * photo = self.pickedImg;
            UIImage * fphoto = [self standarFilterToImage:photo filterName:filter];
            self.PicViewImg.image = fphoto;
            
            [self showFilterDetail:filter];
            self.pickedFilter = (NSInteger)x;
            
        }
    }
    
}
- (BOOL)prefersStatusBarHidden
{
    return isStatusBarHidden;
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Deselect item
}


#pragma mark -
#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.collectionView) {
        
        Pic *data = self.picsArray[indexPath.row];
        UIImage *photo = [self getPicFromDisk:data.path];
        // 2
        CGSize retval = photo.size.width > 0 ? [self reducePicCell:photo.size] : CGSizeMake(100, 100);
        //CGSize retval = CGSizeMake(100, 100);
        retval.height += 35; retval.width += 35;
        return retval;
    }
    else{

        CGSize retval =  CGSizeMake(200, 180);
        //CGSize retval = CGSizeMake(100, 100);
        return retval;
    }
}

-(CGSize)reducePicCell:(CGSize)sz{
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
    //Es el espacio entre las celdas y collection container
    return UIEdgeInsetsMake(20, 20, 20, 20);
}


#pragma mark -
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.picsArray.count;
}


 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     
     PicListCell *cell = (PicListCell*) [tableView dequeueReusableCellWithIdentifier:@"picListCell"];
     if (cell == nil) { // Si no había una celda para reutilizar, debo crearla
         //cell = [[PicListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"picListCell"];
         NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PicListCell" owner:self options:nil];
         cell = [nib objectAtIndex:0];
     }
     
     Pic * p = [self.picsArray objectAtIndex:indexPath.row];
     UIImage *photo = [self getThumnailFromDisk:p.path];
     
     cell.image.image = photo;
     cell.title.text = p.name;
     
     
     if(p.address){
         cell.address.textColor = [UIColor whiteColor];
         cell.address.text = //[NSString stringWithFormat:@"%@ - %@ ", p.city, p.area];
         [NSString stringWithFormat:@"%@", [p.city isEqualToString:p.area]? p.city
                                                                          : [p.city stringByAppendingString: [NSString stringWithFormat: @" - %@" , p.area]]];
     }
     else{
         cell.address.textColor = [UIColor orangeColor];
         cell.address.text = NSLocalizedString(@"NO_LOCALIZED", nil);
     }
     
     
     cell.facesText.text = NSLocalizedString(@"PIC_FACES", nil);
     cell.faces.text = [NSString stringWithFormat:@"%d", p.pic_face.count];
     
     cell.backgroundColor = [UIColor clearColor];
     
     return cell;
 }
 

#pragma mark - UITableViewDelegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self showOnePicViewAtIndex:indexPath];
}



@end
