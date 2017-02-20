//
//  ForecastViewController.m
//  Weather
//
//  Created by Dejan Kraguljac  on 15/02/17.
//
//

#import "ForecastViewController.h"
#import "ForecastDataSource.h"
#import "NSString+WA.h"
#import "CityCell.h"
#import "SettingsViewController.h"

@interface ForecastViewController ()
{
    __weak IBOutlet UIView *_searchContainerView;
    
    __weak IBOutlet UIView *_humidityContainerView;
    __weak IBOutlet UILabel *_humidityLabel;
    __weak IBOutlet UIView *_windContainerView;
    __weak IBOutlet UILabel *_windLabel;
    __weak IBOutlet UIView *_presureContainerView;
    __weak IBOutlet UILabel *_presureLabel;
    
    __weak IBOutlet UILabel *_cityLabel;
    
    __weak IBOutlet UITextField *_searchTextField;
    __weak IBOutlet UIView *_cancelButtonContainerView;
    
    __weak IBOutlet UILabel *_mainTemperatureLabel;
    
    __weak IBOutlet UIImageView *_weatherImageView;
    __weak IBOutlet UILabel *_weatherStateLabel;
    
    __weak IBOutlet UILabel *_lowestTeperatureLabel;
    __weak IBOutlet UILabel *_lowTeperatureStaticLabel;
    __weak IBOutlet UIButton *_cancelButton;
    __weak IBOutlet UILabel *_highTemperatureStaticLabel;
    __weak IBOutlet UILabel *_highestTemperatureLabel;
    
    __weak IBOutlet NSLayoutConstraint *_searchContainerViewHeightConstraint;
    __weak IBOutlet UIButton *_settingsButton;
    
    __weak IBOutlet NSLayoutConstraint *_searchbarMainViewTopContraint;
    __weak IBOutlet NSLayoutConstraint *_searchbarTitleLabelTopConstraint;
    __weak IBOutlet NSLayoutConstraint *_searchbarTrailingConstraint;
    
    __weak IBOutlet NSLayoutConstraint *_searchbarMainViewLeadingConstraint;
    __weak IBOutlet NSLayoutConstraint *_searchbarCancelButtonConstraint;
    
    __weak IBOutlet NSLayoutConstraint *_cancelButtonContainerViewLeadingConstraint;
    UIDynamicAnimator *animator;
    
    NSArray *_cityArray;
    
    __weak IBOutlet UIButton *_backgroundButton;
    __weak IBOutlet UITableView *_searchResultsTableView;
    ForecastDataSource *_forecastDS;
    
    //LoadingView *_loadingView;
}

@end

@implementation ForecastViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self layoutGUI];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat lat = ConfigManager.currentUserLocation.coordinate.latitude;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdated) name:@"UserLocationUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    if (!_forecastDS) _forecastDS = [ForecastDataSource new];
    
   //if (!_loadingView) _loadingView = [[LoadingView alloc] initWithFrame:self.view.frame];
    
    [_searchResultsTableView registerNib:[UINib nibWithNibName:@"CityCell" bundle:nil] forCellReuseIdentifier:@"CityCellIdentifier"];
    _searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    _searchContainerViewHeightConstraint.constant = 0;
    
    _backgroundButton.hidden = _searchResultsTableView.hidden = YES;
    
    _cancelButtonContainerViewLeadingConstraint.constant = - _cancelButtonContainerView.frame.size.width;
    
    [self setupTextField];
    
    [self applyStyle];
    
    [self loadData];
}

- (void)locationUpdated
{
    CGFloat lat = ConfigManager.currentUserLocation.coordinate.latitude;

}

-(void)keyboardWillHide:(NSNotification *)sender
{
    if ([_cityArray count] == 0)
        [self setSearchModeEnabled:NO];
}


-(void)keyboardWillShow:(NSNotification *)sender
{
    [self setSearchModeEnabled:YES];
}

- (void)setupTextField
{
    _searchTextField.layer.cornerRadius = 15.0;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *searchIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchIcon"]];
    searchIconImageView.frame = CGRectMake(10, 0, searchIconImageView.frame.size.width, searchIconImageView.frame.size.height);
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, searchIconImageView.frame.size.width * 2, searchIconImageView.frame.size.height)];
    [paddingView addSubview:searchIconImageView];
    _searchTextField.leftView = paddingView;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
   // [self addClearButtonToTextField];
}

- (void)addClearButtonToTextField
{
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[UIImage imageNamed:@"ClearIcon"] forState:UIControlStateNormal];
    [clearButton setFrame:CGRectMake(0,0, 15, 15)];
    [clearButton addTarget:self action:@selector(textFieldShouldClear:) forControlEvents:UIControlEventTouchUpInside];
    
    _searchTextField.rightViewMode = UITextFieldViewModeAlways; //can be changed to UITextFieldViewModeNever,    UITextFieldViewModeWhileEditing,   UITextFieldViewModeUnlessEditing
    [_searchTextField setRightView:clearButton];
}


- (void)loadData
{
    _currentCity = ConfigManager.userCity;
    _currentWeather = ConfigManager.userWeather;
    
    if (!_currentCity)
        [self loadCurretCityData];
    else
        [self bindGUI];
}

- (void)bindGUI
{
    _humidityLabel.text = [self singleDecimalStringFromNumber:_currentWeather.humidity];
    _windLabel.text = [self singleDecimalStringFromNumber:_currentWeather.windSpeed];
    _presureLabel.text = [self singleDecimalStringFromNumber:_currentWeather.pressure];
    _cityLabel.text = _currentCity.name;
    _mainTemperatureLabel.text = [NSString temperatureString:[self singleDecimalStringFromNumber:_currentWeather.mainTemperature] andUnit:@"°F"];
    _weatherImageView.image  = [UIImage imageNamed:_currentWeather.icon];
    _weatherStateLabel.text = _currentWeather.summary;
    _lowestTeperatureLabel.text = [NSString temperatureString:[self singleDecimalStringFromNumber:_currentWeather.minTemperature] andUnit:@"°F"];
    _highestTemperatureLabel.text = [NSString temperatureString:[self singleDecimalStringFromNumber:_currentWeather.maxTemperature] andUnit:@"°F"];
    [self layoutGUI];
    
   
}

- (NSString *)singleDecimalStringFromNumber:(NSNumber *)number
{
   return [NSString stringWithFormat:@"%.1f", [number floatValue]];
}

- (void)applyStyle
{
    [LabelStyle applyStyle:@"Temperature_Label_Big" toLabel:_mainTemperatureLabel];
    [LabelStyle applyStyle:@"Temperature_Label_Big" toLabel:_cityLabel];
    [LabelStyle applyStyle:@"Temperature_Label_Mid" toLabel:_highestTemperatureLabel];
    [LabelStyle applyStyle:@"Temperature_Label_Mid" toLabel:_lowestTeperatureLabel];
    [LabelStyle applyStyle:@"Temperature_Label_Mid" toLabel:_weatherStateLabel];
    [LabelStyle applyStyle:@"Temperature_Label_Small" toLabel:_lowTeperatureStaticLabel];
    [LabelStyle applyStyle:@"Temperature_Label_Small" toLabel:_highTemperatureStaticLabel];
    [LabelStyle applyStyle:@"Temperature_Label_Small" toLabel:_windLabel];
    [LabelStyle applyStyle:@"Temperature_Label_Small" toLabel:_humidityLabel];
    [LabelStyle applyStyle:@"Temperature_Label_Small" toLabel:_presureLabel];
    
    [_searchResultsTableView setSeparatorColor:[UIColor clearColor]];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_cancelButtonContainerView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _cancelButtonContainerView.bounds;
    maskLayer.path  = maskPath.CGPath;
    _cancelButtonContainerView.layer.mask = maskLayer;
}

- (void)layoutGUI
{
    if (_currentWeather)
    {
        self.view.backgroundColor = _currentWeather.backgroudColor;
        
    }
}

- (void)loadCurretCityData
{
    
    __weak typeof(self)weakSelf = self;
    
    if (!_currentCity)
    [_forecastDS getCityWithcompletionBlock:^(BOOL isDone, NSError *err, NSArray *arr) {
        
        _currentCity = [arr firstObject];
        [weakSelf loadWeather];
        
    }];
}

- (void)loadWeather
{
    __weak typeof(self)weakSelf = self;
    [_forecastDS getWeatherWithLongitude:_currentCity.longitude andLatitude:_currentCity.latitude WithcompletionBlock:^(BOOL isDone, NSError *err, NSArray *arr) {
    
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        _currentWeather = [arr firstObject];
        
        [LoadingView hideLoadingViewForView:weakSelf.view WithCompletionBlock:^{
            
            [strongSelf bindGUI];
            
            _cityArray = nil;
            _searchTextField.text = @"";
            [_searchResultsTableView reloadData];
            
            [strongSelf setSearchModeEnabled:NO];
            
        }];
        
    }];
    
}

#pragma mark - TextField Delegate


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (!textField.text.length)
        [textField resignFirstResponder];
    else
    {
        __weak typeof(self)weakSelf = self;
        [LoadingView showLoadingViewInView:self.view];
        
        [_forecastDS getCityWithSearchString:textField.text WithcompletionBlock:^(BOOL done, NSError *err, NSArray *arr) {
           
            [LoadingView hideLoadingViewForView:weakSelf.view WithCompletionBlock:^{
               
                if (done && !err)
                {
                    _cityArray = [NSArray arrayWithArray:arr];
                    [_searchResultsTableView reloadData];
                    [textField resignFirstResponder];
                }
                
            }];
        }];
        
    }
    
    return YES;
}

- (void)setSearchModeEnabled:(BOOL)enabled
{
    __weak typeof(self)weakSelf = self;
    
    if (!enabled)
        [self animateCancelButton:enabled];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (enabled)
        {
            _searchbarTrailingConstraint.constant = 15;
            _searchbarCancelButtonConstraint.priority = _searchbarMainViewTopContraint.priority = 999;
            _searchbarMainViewLeadingConstraint.priority = _searchbarTitleLabelTopConstraint.priority = 1;
            _searchContainerViewHeightConstraint.constant = 90;
        }
        else
        {
            
            _searchbarTrailingConstraint.constant = 40;
            _searchbarCancelButtonConstraint.priority = _searchbarMainViewTopContraint.priority = 1;
            _searchbarMainViewLeadingConstraint.priority = _searchbarTitleLabelTopConstraint.priority = 999;
            _searchContainerViewHeightConstraint.constant = 0;
        }
        
        _backgroundButton.hidden = _searchResultsTableView.hidden = !enabled;
        
        [weakSelf.view setNeedsLayout];
        [weakSelf.view  layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        if (enabled)
        [self animateCancelButton:enabled];
    }];
    
    
}

- (void)animateCancelButton:(BOOL)show
{
    __weak typeof(self)weakSelf = self;
    _cancelButtonContainerViewLeadingConstraint.constant = show ? - _cancelButtonContainerView.frame.size.width - 5 : 0;
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _cancelButtonContainerViewLeadingConstraint.constant = show ? 0 : - _cancelButtonContainerView.frame.size.width - 5;
        
        [weakSelf.view setNeedsLayout];
        [weakSelf.view  layoutIfNeeded];
        
    } completion:nil];
}

#pragma mark - Button actions

- (IBAction)clearButtonTapped:(id)sender
{
    if (_searchTextField.text.length)
    {
        _searchTextField.text = @"";
        _cityArray = nil;
        [_searchResultsTableView reloadData];
        [self setSearchModeEnabled:NO];
    }
    else
        [_searchTextField resignFirstResponder];
}
- (IBAction)settingsButtonTapped:(id)sender
{
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[SettingsViewController new]] animated:YES completion:nil];
    
}

#pragma mark - TableView Delegate/DS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_cityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityCellIdentifier"];
    
    if (!cell)
        cell = [CityCell new];
    
    cell.city = [_cityArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellEditingStyleNone;
    cell.backgroundColor = [_currentWeather.backgroudColor darkenByPercentage:0.5];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    [LoadingView showLoadingViewInView:self.view WithCompletionBlock:^{
        
        _currentCity = [_cityArray objectAtIndex:indexPath.row];
        
        [weakSelf loadWeather];
        
    }];
    
}

#pragma mark Misc

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
