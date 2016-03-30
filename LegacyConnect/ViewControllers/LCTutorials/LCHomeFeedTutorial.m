//
//  LCHomeFeedTutorial.m
//  LegacyConnect
//
//  Created by Jijo on 3/16/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCHomeFeedTutorial.h"

@interface LCHomeFeedTutorial ()
{
  IBOutlet UILabel *label1;
  IBOutlet UIView *view1;
}
@end

@implementation LCHomeFeedTutorial


- (void) awakeFromNib {
  [super awakeFromNib];
  [self setLabels];
}


- (void)setLabels
{
  NSString *labelString = @"This is your FEED. On it you’ll see all\nof the activity for your INTERESTS,\nCAUSES and FRIENDS. Use your\nFEED to learn how others are\nhelping, to THANK them for helping\nand to find OPPORTUNITIES to help";
  NSMutableAttributedString * attributtedString = [[NSMutableAttributedString alloc] initWithString:labelString];
  NSArray * colorWords = @[@"FEED", @"INTERESTS", @"CAUSES", @"FRIENDS", @"FEED ", @"THANK", @"OPPORTUNITIES"];
  // -- Add Font -- //
  [attributtedString addAttributes:@{
                                     NSFontAttributeName : self.lightFont,
                                     } range:NSMakeRange(0, attributtedString.length)];
  [attributtedString addAttribute:NSForegroundColorAttributeName
                            value:self.colorFontGrey
                            range:NSMakeRange(0, labelString.length)];
  
  for(NSString *word in colorWords)
  {
    [attributtedString addAttribute:NSForegroundColorAttributeName
                              value:self.colorFontRed
                              range:[labelString rangeOfString:word]];
    [attributtedString addAttributes:@{
                                       NSFontAttributeName : self.boldFont,
                                       } range:[labelString rangeOfString:word]];
  }
  
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style setLineSpacing:self.lineSpacing];
  [attributtedString addAttribute:NSParagraphStyleAttributeName
                    value:style
                    range:NSMakeRange(0, labelString.length)];
  
  [label1 setAttributedText:attributtedString];
  
  view1.backgroundColor = self.colorTransparentBlack;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
