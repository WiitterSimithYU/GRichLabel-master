//
//  GTextMenuConfiguration.m
//  GRichLabelExample
//
//  Created by GIKI on 2017/9/27.
//  Copyright © 2017年 GIKI. All rights reserved.
//

#import "GTextMenuConfiguration.h"
#import "GRichLabel.h"

@interface GRichLabel(TextMenuDefault)

@end

@implementation GRichLabel(TextMenuDefault)
/**
 copy Method
 
 @param sender sender
 */
- (void)copyItem:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithFormat:@"%@",[self getSelectText]]];
    
    [self resetSelection];
}
/**
 select All Method
 
 @param sender sender
 */
- (void)selectAllItem:(id)sender
{
    [self setSelectAllRange];
    [self showSelectionView];
    [self showAfterSelectAllMenu];
}

/**
 share Method
 
 @param sender sender
 */
- (void)shareItem:(id)sender
{
    NSString *textToShare = [NSString stringWithFormat:@"%@",[self getSelectText]];
    
    NSArray *activityItems = @[textToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    __weak typeof(self) weakSelf = self;
    
    [[self getCurrentViewController] presentViewController:activityVC animated:YES completion:^{
        [weakSelf resetSelection];
    }];
    
}

/**
 显示全部选择后的menu
 */
- (void)showAfterSelectAllMenu
{
    UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyItem:)];
    UIMenuItem *shareItem = [[UIMenuItem alloc] initWithTitle:@"共享" action:@selector(shareItem:)];
    self.menuConfiguration.menuItems = @[copyItem,shareItem];
    [self showTextMenu];
}
@end

@interface GTextMenuConfiguration ()
@property (nonatomic, weak) GRichLabel * richLabel;
@property (nonatomic, strong) NSString * selectText;

@end

@implementation GTextMenuConfiguration

+ (instancetype)textMenuConfig:(GRichLabel*)richLabel
{
    GTextMenuConfiguration * config = [GTextMenuConfiguration new];
    config.richLabel = richLabel;
    return config;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(copyItem:)];
        UIMenuItem *selectAllItem = [[UIMenuItem alloc] initWithTitle:@"全选" action:@selector(selectAllItem:)];
        UIMenuItem *shareItem = [[UIMenuItem alloc] initWithTitle:@"共享" action:@selector(shareItem:)];
        NSArray *items = [NSArray arrayWithObjects:copyItem,selectAllItem,shareItem,nil];
        self.menuItems = items;
    }
    return self;
}

- (void)showMenuWithTargetRect:(CGRect)targetRect selectRange:(NSRange)selectRange
{
    if (self.menuItems.count == 0) return;
//     [self.richLabel becomeFirstResponder];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    NSArray *items = self.menuItems;
    [menuController setMenuItems:items];

    [menuController setTargetRect:targetRect inView:self.richLabel];
    [menuController setMenuVisible:YES animated:YES];
    
}

- (void)hideTextMenu
{
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuVisible:NO animated:YES];
}


@end


