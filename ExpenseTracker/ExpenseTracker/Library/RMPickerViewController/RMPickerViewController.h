//
//  RMPickerViewController.h
//  RMPickerViewController
//
//
//

#import "RMActionController.h"


@interface RMPickerViewController : RMActionController <UIPickerView *>

@property (nonatomic, readonly) UIPickerView *pickerView;

@property (nonatomic, retain) NSArray<NSString *> *arrItems;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, retain) NSString *selectedValue;

//+ (void)showPickerViewControllerWithTitle:(NSString *)strTitle selectedIndex:(NSInteger)index array:(NSArray<NSString *> *)arrStrings doneBlock:(void(^)(NSInteger selectedIndex, NSString *selectedValue))doneBlock cancelBlock:(void(^)())cancelBlock;
+ (void)showPickerViewControllerWithTitle:(NSString *)strTitle selectedIndex:(NSInteger)index array:(NSArray<NSString *> *)arrStrings onVC:(UIViewController *)onVC doneBlock:(void(^)(NSInteger selectedIndex, NSString *selectedValue))doneBlock cancelBlock:(void(^)(void))cancelBlock;

@end
