//
//  LCGIButtonTutorial.m
//  LegacyConnect
//
//  Created by Jijo on 3/18/16.
//  Copyright © 2016 Gist. All rights reserved.
//

#import "LCGIButtonTutorial.h"

@interface LCGIButtonTutorial ()
{
  IBOutlet UILabel *label1, *label2;
  IBOutlet UIView *view1;
}
@end

@implementation LCGIButtonTutorial


- (void) awakeFromNib {
  [super awakeFromNib];
  [self setLabels];
}


- (void)setLabels
{
  //label 1
  NSString *labelString1 = @"HELPS are where you share how\nyou helped. They can be text,\nimages, or both.";
  NSMutableAttributedString * attributtedString1 = [[NSMutableAttributedString alloc] initWithString:labelString1];
  NSArray * colorWords1 = @[@"HELPS"];
  // -- Add Font -- //
  [attributtedString1 addAttributes:@{
                                      NSFontAttributeName : self.font,
                                      } range:NSMakeRange(0, attributtedString1.length)];
  [attributtedString1 addAttribute:NSForegroundColorAttributeName
                             value:self.colorFontGrey
                             range:NSMakeRange(0, labelString1.length)];
  
  for(NSString *word in colorWords1)
  {
    [attributtedString1 addAttribute:NSForegroundColorAttributeName
                               value:self.colorFontRed
                               range:[labelString1 rangeOfString:word]];
  }
  
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  [style setLineSpacing:self.lineSpacing];
  [attributtedString1 addAttribute:NSParagraphStyleAttributeName
                             value:style
                             range:NSMakeRange(0, labelString1.length)];
  
  [label1 setAttributedText:attributtedString1];
  
  //label2
  NSString *labelString2 = @"You can also create\nOPPORTUNITIES to help and invite\nothers to participate.";
  NSMutableAttributedString * attributtedString2 = [[NSMutableAttributedString alloc] initWithString:labelString2];
  NSArray * colorWords2 = @[@"OPPORTUNITIES"];
  // -- Add Font -- //
  [attributtedString2 addAttributes:@{
                                      NSFontAttributeName : self.font,
                                      } range:NSMakeRange(0, attributtedString2.length)];
  [attributtedString2 addAttribute:NSForegroundColorAttributeName
                             value:self.colorFontGrey
                             range:NSMakeRange(0, labelString2.length)];
  
  for(NSString *word in colorWords2)
  {
    [attributtedString2 addAttribute:NSForegroundColorAttributeName
                               value:self.colorFontRed
                               range:[labelString2 rangeOfString:word]];
  }
  
  NSMutableParagraphStyle *style2 = [[NSMutableParagraphStyle alloc] init];
  [style2 setLineSpacing:self.lineSpacing];
  [attributtedString2 addAttribute:NSParagraphStyleAttributeName
                             value:style2
                             range:NSMakeRange(0, labelString2.length)];
  
  [label2 setAttributedText:attributtedString2];
  
  
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
