#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSListController.h>
#import <UIKit/UIKit.h>

@interface PSSpecifier (OptimizedZhuyin)
@property(retain, nonatomic) NSDictionary* properties;
@end

@interface OptimizedZhuyinMainController: PSListController
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end