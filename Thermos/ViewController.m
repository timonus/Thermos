//
//  ViewController.m
//  Thermos
//
//  Created by Tim Johnsen on 9/6/20.
//

#import "ViewController.h"

#import <ThermodoSDK/THMThermodo.h>
#import <CoreText/CoreText.h>

@interface ViewController () <THMThermodoDelegate>

@property (nonatomic) UILabel *label;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 40.0, 40.0)];
    self.label.textAlignment = NSTextAlignmentCenter;
    
    NSArray *monospacedSetting = @[@{UIFontFeatureTypeIdentifierKey: @(kNumberSpacingType), UIFontFeatureSelectorIdentifierKey: @(kMonospacedNumbersSelector)}];
    UIFontDescriptor *descriptor = [[[UIFont systemFontOfSize:200.0] fontDescriptor] fontDescriptorByAddingAttributes:@{UIFontDescriptorFeatureSettingsAttribute: monospacedSetting}];
    [self.label setFont:[UIFont fontWithDescriptor:descriptor size:0]];
    self.label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    
    self.view.backgroundColor = [UIColor blackColor];
    self.label.textColor = [UIColor whiteColor];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.label.adjustsFontSizeToFitWidth = YES;
    self.label.text = @"...";
    [self.view addSubview:self.label];
    
    [[THMThermodo sharedThermodo] setDelegate:self];
    [[THMThermodo sharedThermodo] start];
}

- (void)thermodoInputPluggedIn:(THMThermodo *)thermodo
{
    self.label.text = @"Plug";
}

- (void)thermodoInputWasUnplugged:(THMThermodo *)thermodo
{
    self.label.text = @"Unplug";
}

- (void)thermodoDidRejectInput:(THMThermodo *)thermodo
{
    self.label.text = @"Reject";
}

- (void)thermodoDidStartMeasuring:(THMThermodo *)thermodo
{
    self.label.text = @"Start";
}

- (void)thermodoDidStopMeasuring:(THMThermodo *)thermodo
{
    self.label.text = @"Stop";
}

- (void)thermodo:(THMThermodo *)thermodo didGetTemperature:(float)temperature
{
    self.label.text = [NSString stringWithFormat:@"%0.1f℉", temperature * (9.0/5.0) + 32.0];
}

- (void)thermodo:(THMThermodo *)thermodo didFailWithError:(NSError *)error
{
    UIAlertController *c = [UIAlertController alertControllerWithTitle:@"Error"
                                                               message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    [c addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:c animated:YES completion:nil];
}

@end
