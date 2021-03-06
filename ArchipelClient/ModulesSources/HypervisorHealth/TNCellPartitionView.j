/*
 * TNCellPartitionView.j
 *
 * Copyright (C) 2010 Antoine Mercadal <antoine.mercadal@inframonde.eu>
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

@import <Foundation/Foundation.j>
@import <AppKit/CPLevelIndicator.j>
@import <AppKit/CPProgressIndicator.j>
@import <AppKit/CPTextField.j>

/*! represent a Partition object in a CPTableView
*/
@implementation TNCellPartitionView : CPView
{
    CPLevelIndicator        _levelIndicator;
    CPTextField             _nameLabel;
    CPTextField             _totalLabel;
    CPTextField             _usedLabel;
    CPTextField             _availableLabel;
}

#pragma mark -
#pragma mark Initialization

/*! initialize the view
*/
- (id)initWithFrame:(CPRect)aFrame
{
    if (self = [super initWithFrame:aFrame])
    {
        [self setAutoresizingMask: CPViewWidthSizable];

        _nameLabel = [CPTextField labelWithTitle:CPBundleLocalizedString(@"Partition name", @"Partition name")];
        [_nameLabel setFont:[CPFont boldSystemFontOfSize:12.0]];
        [_nameLabel setFrame:CPRectMake(3.0, 3.0, 210.0, 18.0)]
        [_nameLabel setLineBreakMode:CPLineBreakByTruncatingTail];

        _usedLabel = [CPTextField labelWithTitle:CPBundleLocalizedString(@"Used: ", @"Used: ")];
        [_usedLabel setFont:[CPFont systemFontOfSize:10.0]];
        [_usedLabel setFrame:CPRectMake(210.0, 3.0, 95.0, 18.0)];
        [_usedLabel setAutoresizingMask:CPViewMinXMargin];
        [_usedLabel setAlignment:CPRightTextAlignment];
        [_usedLabel setLineBreakMode:CPLineBreakByTruncatingTail];

        _availableLabel = [CPTextField labelWithTitle:CPBundleLocalizedString(@"Available: ", @"Available: ")];
        [_availableLabel setFont:[CPFont systemFontOfSize:10.0]];
        [_availableLabel setFrame:CPRectMake(310.0, 3.0, 108.0, 18.0)];
        [_availableLabel setAutoresizingMask:CPViewMinXMargin];
        [_availableLabel setAlignment:CPRightTextAlignment];
        [_availableLabel setLineBreakMode:CPLineBreakByTruncatingTail];

        _levelIndicator = [[CPLevelIndicator alloc] initWithFrame:CPRectMake(3.0, 20.0, aFrame.size.width - 6, 18.0)];
        [_levelIndicator setEditable:NO];
        [_levelIndicator setNumberOfTickMarks:50.0];
        [_levelIndicator setMaxValue:50.0];
        [_levelIndicator setMinValue:0.0];
        [_levelIndicator setCriticalValue:10.0];
        [_levelIndicator setWarningValue:30.0];
        [_levelIndicator setAutoresizingMask:CPViewWidthSizable];

        [self addSubview:_nameLabel];
        [self addSubview:_usedLabel];
        [self addSubview:_availableLabel];
        [self addSubview:_levelIndicator];
    }

    return self;
}


#pragma mark -
#pragma mark CPColumn view protocol

/*! set the object value of the cell
    @params aValue the current value
*/
- (void)setObjectValue:(CPDictionary)aContent
{
    var capacity = parseInt([aContent objectForKey:@"capacity"]);
    [_levelIndicator setDoubleValue:50 - capacity / 2];

    [_nameLabel setStringValue:[aContent objectForKey:@"mount"]];
    [_usedLabel setStringValue:CPBundleLocalizedString(@"Used: ", @"Used: ") + [CPString formatByteSize:[[aContent objectForKey:@"used"] intValue]]];
    [_availableLabel setStringValue:CPBundleLocalizedString(@"Available: ", @"Available: ") + [CPString formatByteSize:[[aContent objectForKey:@"available"] intValue]]];
}


#pragma mark -
#pragma mark CPCoding compliance

- (id)initWithCoder:(CPCoder)aCoder
{
    if (self = [super initWithCoder:aCoder])
    {
        _levelIndicator = [aCoder decodeObjectForKey:@"_levelIndicator"];
        _nameLabel      = [aCoder decodeObjectForKey:@"_nameLabel"];
        _usedLabel      = [aCoder decodeObjectForKey:@"_usedLabel"];
        _availableLabel = [aCoder decodeObjectForKey:@"_availableLabel"];
    }

    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:_nameLabel forKey:@"_nameLabel"];
    [aCoder encodeObject:_levelIndicator forKey:@"_levelIndicator"];
    [aCoder encodeObject:_usedLabel forKey:@"_usedLabel"];
    [aCoder encodeObject:_availableLabel forKey:@"_availableLabel"];
}

@end


// add this code to make the CPLocalizedString looking at
// the current bundle.
function CPBundleLocalizedString(key, comment)
{
    return CPLocalizedStringFromTableInBundle(key, nil, [CPBundle bundleForClass:TNCellPartitionView], comment);
}