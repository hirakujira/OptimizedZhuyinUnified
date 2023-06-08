#import <Preferences/PSControlTableCell.h>
#import <Preferences/PSListController.h>
#import <UIKit/UIKit.h>
#import <firmware.h>
#import <spawn.h>
#import <rootless.h>

@interface PSSpecifier (OptimizedZhuyin)
@property(retain, nonatomic) NSDictionary* properties;
@end

@interface OptimizedZhuyinMainController: PSListController
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end
