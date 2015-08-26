//
//  LCTaggedLabel.m
//  LegacyConnect
//
//  Created by User on 8/17/15.
//  Copyright (c) 2015 Gist. All rights reserved.
//

#import "LCTaggedLabel.h"

@implementation LCTaggedLabel

#pragma mark - Construction

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.userInteractionEnabled = YES;
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self = [super initWithCoder:aDecoder];
  if (self)
  {
    self.userInteractionEnabled = YES;
  }
  
  return self;
}

// Common initialisation. Must be done once during construction.
- (void)setupTextSystem
{
  _layoutManager = [[NSLayoutManager alloc] init];
  _textContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
  _textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
  // Configure layoutManager and textStorage
  [_layoutManager addTextContainer:_textContainer];
  [_textStorage addLayoutManager:_layoutManager];
  // Configure textContainer
  _textContainer.lineFragmentPadding = 0.0;
  _textContainer.lineBreakMode = NSLineBreakByWordWrapping;
  _textContainer.maximumNumberOfLines = 0;
  self.userInteractionEnabled = YES;
  self.textContainer.size = self.bounds.size;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  if (!_layoutManager)
  {
    [self setupTextSystem];
  }
  // Get the info for the touched link if there is one
  CGPoint touchLocation = [[touches anyObject] locationInView:self];
  [self linkAtPoint:touchLocation];
}

- (void)linkAtPoint:(CGPoint)location
{
  // Do nothing if we have no text
  if (_textStorage.string.length == 0)
  {
    return;
  }
  // Work out the offset of the text in the view
  CGPoint textOffset = [self calcGlyphsPositionInView];
  // Get the touch location and use text offset to convert to text cotainer coords
  location.x -= textOffset.x;
  location.y -= textOffset.y;
  NSUInteger touchedChar = [_layoutManager glyphIndexForPoint:location inTextContainer:_textContainer];
  // If the touch is in white space after the last glyph on the line we don't
  // count it as a hit on the text
  NSRange lineRange;
  CGRect lineRect = [_layoutManager lineFragmentUsedRectForGlyphAtIndex:touchedChar effectiveRange:&lineRange];
  if (CGRectContainsPoint(lineRect, location) == NO)
  {
    return;
  }
  // Find the word that was touched and call the detection block
  for (int i = 0; i<self.tagsArray.count; i++) {
    NSRange range = [self.tagsArray[i][@"range"] rangeValue];
    if ((touchedChar >= range.location) && touchedChar < (range.location + range.length))
    {
      self.nameTagTapped(i);
    }
  }
}

- (CGPoint)calcGlyphsPositionInView
{
  CGPoint textOffset = CGPointZero;
  
  CGRect textBounds = [_layoutManager usedRectForTextContainer:_textContainer];
  textBounds.size.width = ceil(textBounds.size.width);
  textBounds.size.height = ceil(textBounds.size.height);
  
  if (textBounds.size.height < self.bounds.size.height)
  {
    CGFloat paddingHeight = (self.bounds.size.height - textBounds.size.height) / 2.0;
    textOffset.y = paddingHeight;
  }  
  return textOffset;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


@end
