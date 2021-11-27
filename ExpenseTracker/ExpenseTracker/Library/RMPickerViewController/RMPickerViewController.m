//
//  RMPickerViewController.m
//  RMPickerViewController
//


#import "RMPickerViewController.h"
#import "ExpenseTracker-Swift.h"

#pragma mark - Defines

#define RM_PICKER_HEIGHT_PORTRAIT 216
#define RM_PICKER_HEIGHT_LANDSCAPE 162

#if !__has_feature(attribute_availability_app_extension)
//Normal App
#define RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
#else
//App Extension
#define RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE [UIScreen mainScreen].bounds.size.height < [UIScreen mainScreen].bounds.size.width
#endif

#pragma mark - Interfaces

@interface RMPickerViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, readwrite) UIPickerView *pickerView;
@property (nonatomic, weak) NSLayoutConstraint *pickerHeightConstraint;

@end

#pragma mark - Implementations

@implementation RMPickerViewController

+ (void)showPickerViewControllerWithTitle:(NSString *)strTitle selectedIndex:(NSInteger)index array:(NSArray<NSString *> *)arrStrings onVC:(UIViewController *)onVC doneBlock:(void(^)(NSInteger selectedIndex, NSString *selectedValue))doneBlock cancelBlock:(void(^)(void))cancelBlock {

    RMActionControllerStyle style = RMActionControllerStyleBlack;
    RMAction *selectAction = [RMAction actionWithTitle:@"Select" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        RMPickerViewController *pickerController = (RMPickerViewController *)controller;
        if(doneBlock) {
            doneBlock(pickerController.selectedIndex, pickerController.selectedValue);
        }
    }];
    RMAction *cancelAction = [RMAction actionWithTitle:@"Cancel" style:RMActionStyleDefault andHandler:^(RMActionController *controller) {
        if(cancelBlock) {
            cancelBlock();
        }
    }];
    
    RMPickerViewController *pickerViewController = [RMPickerViewController actionControllerWithStyle:style selectAction:selectAction andCancelAction:cancelAction];
    [pickerViewController setTitle:strTitle];
    pickerViewController.selectedIndex = index;
    pickerViewController.disableBouncingEffects = YES;
    pickerViewController.disableMotionEffects = YES;
    pickerViewController.disableBlurEffects = YES;
    pickerViewController.arrItems = arrStrings;
    //UIViewController *topMostViewController = [UIApplication topViewController:[[UIApplication sharedApplication] keyWindow].rootViewController];
    [onVC presentViewController:pickerViewController animated:TRUE completion:nil];
}


#pragma mark - Init and Dealloc
- (instancetype)initWithStyle:(RMActionControllerStyle)aStyle title:(NSString *)aTitle message:(NSString *)aMessage selectAction:(RMAction *)selectAction andCancelAction:(RMAction *)cancelAction {
    self = [super initWithStyle:aStyle title:aTitle message:aMessage selectAction:selectAction andCancelAction:cancelAction];
    if(self) {
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        [self.pickerView setDelegate:self];
        [self.pickerView setDataSource:self];
        self.pickerView.translatesAutoresizingMaskIntoConstraints = NO;
        
//        self.selectedIndex=0;
//        self.selectedValue=@"";
        
        self.pickerHeightConstraint = [NSLayoutConstraint constraintWithItem:self.pickerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];
        
        if(RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE) {
            self.pickerHeightConstraint.constant = RM_PICKER_HEIGHT_LANDSCAPE;
        } else {
            self.pickerHeightConstraint.constant = RM_PICKER_HEIGHT_PORTRAIT;
        }
        
        [self.pickerView addConstraint:self.pickerHeightConstraint];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.selectedIndex < self.arrItems.count && self.selectedIndex > 0)
    {
        self.selectedValue = [self.arrItems objectAtIndex:self.selectedIndex];
        [_pickerView selectRow:self.selectedIndex inComponent:0 animated:true];
        
    }else
    {
        self.selectedIndex=0;
        self.selectedValue = self.arrItems.count == 0 ? @"" : [self.arrItems objectAtIndex:self.selectedIndex];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
    [super viewDidDisappear:animated];
}

#pragma mark - Orientation
- (void)didRotate {
    NSTimeInterval duration = 0.4;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        duration = 0.3;
        
        if(RM_CURRENT_ORIENTATION_IS_LANDSCAPE_PREDICATE) {
            self.pickerHeightConstraint.constant = RM_PICKER_HEIGHT_LANDSCAPE;
        } else {
            self.pickerHeightConstraint.constant = RM_PICKER_HEIGHT_PORTRAIT;
        }
        
        [self.pickerView setNeedsUpdateConstraints];
        [self.pickerView layoutIfNeeded];
    }
    
    [self.view.superview setNeedsUpdateConstraints];
    __weak RMPickerViewController *blockself = self;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [blockself.view.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}

#pragma mark - Properties
- (UIView *)contentView {
    return self.pickerView;
}

#pragma mark - UIPicker Delagate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.arrItems.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return pickerView.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 45;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.arrItems objectAtIndex:row];
}
/*
 - (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
 //    if(!view) {
 view = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, pickerView.width, 45)];
 //    }
 [((UILabel *)view) setText:[(PItem *)[self.arrItems objectAtIndex:row] title]];
 [view setBackgroundColor:[UIColor redColor]];
 return view;
 }
 */
/*
 - (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
 
 NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[(PItem *)[self.arrItems objectAtIndex:row] title]  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:22],NSForegroundColorAttributeName:[UIColor blackColor]}];
 return str;
 }
 */
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedIndex = row;
    self.selectedValue = [self.arrItems objectAtIndex:row];
}

@end
