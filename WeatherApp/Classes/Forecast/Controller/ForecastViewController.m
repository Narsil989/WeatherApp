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
#import "CommonAlertView.h"

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
    
    __weak IBOutlet UIButton *_settingsButton;
    
    __weak IBOutlet NSLayoutConstraint *_searchContainerViewHeightConstraint;
    
    __weak IBOutlet NSLayoutConstraint *_searchbarMainViewTopContraint;
    __weak IBOutlet NSLayoutConstraint *_searchbarTitleLabelTopConstraint;
    __weak IBOutlet NSLayoutConstraint *_searchbarTrailingConstraint;
    __weak IBOutlet NSLayoutConstraint *_searchbarMainViewLeadingConstraint;
    __weak IBOutlet NSLayoutConstraint *_searchbarCancelButtonConstraint;
    __weak IBOutlet NSLayoutConstraint *_cancelButtonContainerViewLeadingConstraint;
    
    __weak IBOutlet NSLayoutConstraint *_humidityTrailingConstraint;
    __weak IBOutlet NSLayoutConstraint *_windSpeedTrailingConstraint;
    __weak IBOutlet NSLayoutConstraint *_windSpeedLeadingConstraint;
    __weak IBOutlet NSLayoutConstraint *_pressureLeadingConstraint;
    
    __weak IBOutlet UITableView *_searchResultsTableView;
    
    __weak IBOutlet UILabel *_noInternetLabel;
    
    NSArray *_cityArray;
    
    BOOL _searchModeAnimationStarted;
    BOOL _dataIsLoading;
    
    NSManagedObjectContext *_mainObjectContext;
    
    ForecastDataSource *_forecastDS;
    
    CGFloat mainScreenWidth;
}

@end

@implementation ForecastViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _mainObjectContext = [DataManager mainManagedObjectContext];
    
    if (!_currentWeather)
    {
        self.view.backgroundColor = [UIColor flatSkyBlueColor];
    }
    
    _noInternetLabel.hidden = YES;
    
    if (_dataIsLoading)
        [LoadingView showLoadingViewInView:self.view];
    
    _currentCity = [[DataManager citiesForSearchQuery:@"isSelected == YES"] firstObject];
    
    [self layoutGUI];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![AFNetworkReachabilityManager sharedManager].reachable)
        _noInternetLabel.hidden = NO;
    
    __weak typeof(self)weakSelf = self;
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        
        if (status == AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
            
            [weakSelf loadData];
        else
        {
            _noInternetLabel.hidden = NO;
        }
    }];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    
    [self addObservers];
    
    [self initialLayout];
    
    [self setupForecastDataSource];
    
    [self setupSearchResultsTableView];
    
    [self setupTextField];
    
    [self applyStyle];
    
    [self loadData];
}

- (void)applyStyle
{
    [WAStyle applyStyle:@"Temperature_Label_VeryBig" toLabel:_mainTemperatureLabel];
    [WAStyle applyStyle:@"Temperature_Label_Big" toLabel:_cityLabel];
    [WAStyle applyStyle:@"Temperature_Label_Mid" toLabel:_highestTemperatureLabel];
    [WAStyle applyStyle:@"Temperature_Label_Mid" toLabel:_lowestTeperatureLabel];
    [WAStyle applyStyle:@"Temperature_Label_Mid" toLabel:_weatherStateLabel];
    [WAStyle applyStyle:@"Temperature_Label_Small" toLabel:_lowTeperatureStaticLabel];
    [WAStyle applyStyle:@"Temperature_Label_Small" toLabel:_highTemperatureStaticLabel];
    [WAStyle applyStyle:@"Temperature_Label_Small" toLabel:_windLabel];
    [WAStyle applyStyle:@"Temperature_Label_Small" toLabel:_humidityLabel];
    [WAStyle applyStyle:@"Temperature_Label_Small" toLabel:_presureLabel];
    
    [_cityLabel setAdjustsFontSizeToFitWidth:YES];
    
    [_searchResultsTableView setSeparatorColor:[UIColor clearColor]];
    
    [self applyStyleToSearchTextField];
    [self addRoundedCornersToCancelButton];
}

- (void)applyStyleToSearchTextField
{
    NSDictionary *placeholderFontAttributes = @{NSFontAttributeName :[WAStyle fontForKey:@"Text_Field_Inactive"],
                                                NSForegroundColorAttributeName : [WAStyle colorForKey:@"Text_Field_Inactive"]};
    
    _searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type something" attributes:placeholderFontAttributes];
    _searchTextField.font = [WAStyle fontForKey:@"Text_Field_Active"];
    _searchTextField.textColor = [WAStyle colorForKey:@"Text_Field_Active"];
}

- (void)addRoundedCornersToCancelButton
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_cancelButtonContainerView.bounds byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight) cornerRadii:CGSizeMake(10.0, 10.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _cancelButtonContainerView.bounds;
    maskLayer.path  = maskPath.CGPath;
    _cancelButtonContainerView.layer.mask = maskLayer;
}

- (void)setupForecastDataSource
{
    if (!_forecastDS) _forecastDS = [ForecastDataSource new];
    [_forecastDS setMaxRows:@"10"];
    [_forecastDS setUsername:@"narsil"];
    
    [_forecastDS setDarkSkyToken:@"c445625667ffb6939409211d3255ff87"];
}

- (void)initialLayout
{
    _searchContainerViewHeightConstraint.constant = 0;
    
    _searchResultsTableView.hidden = YES;
    
    [self updateConditionViews];
    
    _cancelButtonContainerViewLeadingConstraint.constant = - _cancelButtonContainerView.frame.size.width;
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
}


- (void)setupSearchResultsTableView
{
    [_searchResultsTableView registerNib:[UINib nibWithNibName:@"CityCell" bundle:nil] forCellReuseIdentifier:@"CityCellIdentifier"];
    _searchResultsTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

#pragma mark - Search TextField setup

- (void)setupTextField
{
    _searchTextField.layer.cornerRadius = 15.0;
    _searchTextField.leftViewMode = UITextFieldViewModeAlways;
    _searchTextField.rightViewMode = UITextFieldViewModeAlways;
    
    [self addSearchIconToTextField];

    [self addClearButtonToTextField];
}

- (void)addSearchIconToTextField
{
    UIImageView *searchIconImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SearchIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    searchIconImageView.tintColor = _currentWeather.backgroudColor ? _currentWeather.backgroudColor : [UIColor flatSkyBlueColor];
    searchIconImageView.frame = CGRectMake(10, 0, searchIconImageView.frame.size.width, searchIconImageView.frame.size.height);
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, searchIconImageView.frame.size.width * 2, searchIconImageView.frame.size.height)];
    
    [paddingView addSubview:searchIconImageView];
    
    _searchTextField.leftView = paddingView;
}

- (void)addClearButtonToTextField
{
    UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [clearButton setImage:[UIImage imageNamed:@"ClearIcon"] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearTextField) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, clearButton.frame.size.width, clearButton.frame.size.height)];
    [paddingView addSubview:clearButton];
    
    _searchTextField.rightView = paddingView;
    
    _searchTextField.rightView.hidden = YES;
    
}

#pragma mark - Keyboard notifications handlers

-(void)keyboardWillHide:(NSNotification *)sender
{
    if ([_cityArray count] == 0)
        [self setSearchModeEnabled:NO];
}


-(void)keyboardWillShow:(NSNotification *)sender
{
    [self setSearchModeEnabled:YES];
}

#pragma mark - LoadData

- (void)loadData
{
    _currentCity = [[DataManager citiesForSearchQuery:@"isSelected == YES"] firstObject];
    
    _dataIsLoading = YES;
    
    if (!_currentCity)
        [self loadDefaultCityData];
    else
        [self loadWeather];
}



- (void)loadDefaultCityData
{
    __weak typeof(self)weakSelf = self;
    
    [_forecastDS getDefaultCityWithcompletionBlock:^(BOOL success, NSError *err, NSArray *arr) {
        
        if (success && !err)
        {
            _currentCity = [arr firstObject];
            [weakSelf loadWeather];
        }
        else if (err && err.code == -1009)
        {
            _noInternetLabel.hidden = NO;
            _dataIsLoading = NO;
            [weakSelf bindGUI];
        }
        else
        {
            [weakSelf bindGUI];
        }
        
    }];
}

- (void)loadWeather
{
    __weak typeof(self)weakSelf = self;
    [_forecastDS getWeatherWithLongitude:_currentCity.longitude andLatitude:_currentCity.latitude WithcompletionBlock:^(BOOL success, NSError *err, NSArray *arr) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        
        if (success && !err)
        {
            _currentWeather = [arr firstObject];
            _noInternetLabel.hidden = YES;
        }
        else
            _currentWeather = nil;
        
        if (err && err.code == -1009)
        {
            _noInternetLabel.hidden = NO;
        }
        
        _dataIsLoading = NO;
        
        [LoadingView hideLoadingViewForView:weakSelf.view WithCompletionBlock:^{
            
            [strongSelf bindGUI];
            
            [strongSelf resetSearchTextField:YES andHideKeyBoard:YES andDisableSearch:YES];
            
        }];
        
    }];
    
}

#pragma mark - BindGUI

- (void)bindGUI
{
    _humidityLabel.text = [[self singleDecimalStringFromNumber:_currentWeather.humidity] stringByAppendingString:@" %"];
    _windLabel.text = [NSString windSpeedString:[self singleDecimalStringFromNumber:_currentWeather.windSpeed]];
    _presureLabel.text = [[self singleDecimalStringFromNumber:_currentWeather.pressure] stringByAppendingString:@" hpa"];
    _cityLabel.text = _currentCity.name;
    _mainTemperatureLabel.text = [NSString temperatureString:[self singleDecimalStringFromNumber:_currentWeather.mainTemperature]];
    _weatherImageView.image  = [UIImage imageNamed:_currentWeather.icon];
    _weatherStateLabel.text = _currentWeather.summary;
    _lowestTeperatureLabel.text = [NSString temperatureString:[self singleDecimalStringFromNumber:_currentWeather.minTemperature]];
    _highestTemperatureLabel.text = [NSString temperatureString:[self singleDecimalStringFromNumber:_currentWeather.maxTemperature]];
    _noInternetLabel.text = @"No internet connection, please check Your internet settings.";
    [WAStyle applyStyle:@"Settings_Title_Label" toLabel:_noInternetLabel];
    _noInternetLabel.hidden = YES;
    
    [_cityLabel setAdjustsFontSizeToFitWidth:YES];
    
    [self layoutGUI];
    
}

#pragma mark - LayoutGUI

- (void)layoutGUI
{
    if (_currentWeather)
    {
        self.view.backgroundColor = _currentWeather.backgroudColor;
        [self addSearchIconToTextField];
    }
}

#pragma mark - TextField Delegate

- (IBAction)textFieldTextChanged:(id)sender
{
    _searchTextField.rightView.hidden = !_searchTextField.text.length;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textField.rightView.hidden = !textField.text.length;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _searchTextField.rightView.hidden = !_searchTextField.text.length;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length)
    {
        __weak typeof(self)weakSelf = self;
        
        [LoadingView showLoadingViewInView:self.view];
        
        [_forecastDS getCityWithSearchString:textField.text WithcompletionBlock:^(BOOL done, NSError *err, NSArray *arr) {
            
            [LoadingView hideLoadingViewForView:weakSelf.view WithCompletionBlock:^{
                
                if (done && !err)
                {
                    _noInternetLabel.hidden = YES;
                    _cityArray = [NSArray arrayWithArray:arr];
                }
                else
                {
                    _cityArray = nil;
                }
                
                if ([arr count])
                    [textField resignFirstResponder];
                if (err && err.code == -1009)
                {
                    if (![self presentedViewController])
                    {
                        [weakSelf resetSearchTextField:YES andHideKeyBoard:YES andDisableSearch:YES];
                    }
                    
                    _noInternetLabel.hidden = NO;
                }
                
                [_searchResultsTableView reloadData];
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
    
    _searchModeAnimationStarted = YES;
    _searchContainerView.backgroundColor = [_currentWeather.backgroudColor darkenByPercentage:0.5];
    _searchResultsTableView.backgroundColor = [[_currentWeather.backgroudColor lightenByPercentage:0.5] colorWithAlphaComponent:0.7];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        if (enabled)
        {
            _searchbarTrailingConstraint.constant = 15;
            _searchbarCancelButtonConstraint.priority = _searchbarMainViewTopContraint.priority = 999;
            _searchbarMainViewLeadingConstraint.priority = _searchbarTitleLabelTopConstraint.priority = 1;
            _searchContainerViewHeightConstraint.constant = 78;
        }
        else
        {
            
            _searchbarTrailingConstraint.constant = 35;
            _searchbarCancelButtonConstraint.priority = _searchbarMainViewTopContraint.priority = 1;
            _searchbarMainViewLeadingConstraint.priority = _searchbarTitleLabelTopConstraint.priority = 999;
            _searchContainerViewHeightConstraint.constant = 0;
        }
        
        _searchResultsTableView.hidden = !enabled;
        
        [weakSelf.view setNeedsLayout];
        [weakSelf.view  layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        _searchModeAnimationStarted = NO;
        
        if (enabled)
            [self animateCancelButton:enabled];
    }];
    
    
}

- (void)animateCancelButton:(BOOL)show
{
    _cancelButtonContainerViewLeadingConstraint.constant = show ? -_cancelButtonContainerView.frame.size.width : -5;
    
    __weak typeof(self)weakSelf = self;
    
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        _cancelButtonContainerViewLeadingConstraint.constant = show ? -5 : - _cancelButtonContainerView.frame.size.width;
        
        [weakSelf.view setNeedsLayout];
        [weakSelf.view  layoutIfNeeded];
        
    } completion:nil];
}


#pragma mark Clear search TextField

- (void)clearTextField
{
    [self resetSearchTextField:YES andHideKeyBoard:NO andDisableSearch:NO];
    if (![_searchTextField isFirstResponder]) [_searchTextField becomeFirstResponder];
}


#pragma mark - Button actions

- (IBAction)clearButtonTapped:(id)sender
{
    if (_searchTextField.text.length)
        [self resetSearchTextField:YES andHideKeyBoard:YES andDisableSearch:YES];
    else
        [_searchTextField resignFirstResponder];
}
- (IBAction)settingsButtonTapped:(id)sender
{
    SettingsViewController *settingsVC = [SettingsViewController new];
    
    __weak typeof(self)weakSelf = self;
    
    settingsVC.shouldRefreshWeather = ^(){
        
        [weakSelf loadData];
    };
    
    settingsVC.shouldUpdateConditionViews = ^(){
        
        [weakSelf updateConditionViews];
        
    };
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:settingsVC] animated:YES completion:nil];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!_searchModeAnimationStarted)
        [self resetSearchTextField:[_cityArray count] == 0 andHideKeyBoard:YES andDisableSearch:[_cityArray count] == 0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    [self saveSelectedCity:[_cityArray objectAtIndex:indexPath.row]];
    
    [LoadingView showLoadingViewInView:self.view WithCompletionBlock:^{
        
        _currentCity = [_cityArray objectAtIndex:indexPath.row];
        
        [weakSelf loadWeather];
        
    }];
}

- (void)saveSelectedCity:(City *)selectedCity
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass([CityEntity class])
                                              inManagedObjectContext:_mainObjectContext];
    
    CityEntity *item = [[CityEntity alloc] initWithEntity:entity insertIntoManagedObjectContext:_mainObjectContext];
    
    item.name = selectedCity.name;
    item.countryCode = selectedCity.countryCode;
    item.geonameId = [selectedCity.geonameId floatValue];
    item.latitude = selectedCity.latitude;
    item.longitude = selectedCity.longitude;
    item.isSelected = YES;
    
    [DataManager setMainCitySelectAndDeselctOther:item];
    
}

#pragma mark - Helpers

- (void)updateConditionViews
{
    _humidityContainerView.hidden = ![ConfigManager isHumidityShown];
    _presureContainerView.hidden = ![ConfigManager isPressureShown];
    _windContainerView.hidden = ![ConfigManager isWindSpeedShown];
    
    [self setupHumiditySize];
    [self setupPressureSize];
    [self setupWindSpeedSize];
    
}

- (void)setupHumiditySize
{
    if ((![ConfigManager isPressureShown] && [ConfigManager isWindSpeedShown]) || ([ConfigManager isPressureShown] && ![ConfigManager isWindSpeedShown]))
        _humidityTrailingConstraint.constant = mainScreenWidth/2;
    if ([ConfigManager isPressureShown] && [ConfigManager isWindSpeedShown])
        _humidityTrailingConstraint.constant = mainScreenWidth*2/3;
    if (![ConfigManager isPressureShown] && ![ConfigManager isWindSpeedShown])
        _humidityTrailingConstraint.constant = 0;
}

- (void)setupWindSpeedSize
{
    if (![ConfigManager isPressureShown] && [ConfigManager isHumidityShown])
    {
        _windSpeedLeadingConstraint.constant = mainScreenWidth/2;
        _windSpeedTrailingConstraint.constant = 0;
    }
    else if ([ConfigManager isPressureShown] && ![ConfigManager isHumidityShown])
    {
        _windSpeedLeadingConstraint.constant = 0;
        _windSpeedTrailingConstraint.constant = mainScreenWidth/2;
    }
    else if ([ConfigManager isPressureShown] && [ConfigManager isHumidityShown])
    {
        _windSpeedLeadingConstraint.constant = mainScreenWidth/3;
        _windSpeedTrailingConstraint.constant = mainScreenWidth/3;
    }
    else if (![ConfigManager isPressureShown] && ![ConfigManager isHumidityShown])
    {
        _windSpeedLeadingConstraint.constant = 0;
        _windSpeedTrailingConstraint.constant = 0;
    }
}

- (void)setupPressureSize
{
    if ((![ConfigManager isHumidityShown] && [ConfigManager isWindSpeedShown]) || ([ConfigManager isHumidityShown] && ![ConfigManager isWindSpeedShown]))
    {
        _pressureLeadingConstraint.constant = mainScreenWidth/2;
    }
    else if ([ConfigManager isHumidityShown] && [ConfigManager isWindSpeedShown])
    {
        _pressureLeadingConstraint.constant = mainScreenWidth*2/3;
    }
    else if (![ConfigManager isHumidityShown] && ![ConfigManager isWindSpeedShown])
    {
        _pressureLeadingConstraint.constant = 0;
    }
}
- (void)resetSearchTextField:(BOOL)shouldReset andHideKeyBoard:(BOOL)shouldHideKeyboard andDisableSearch:(BOOL)disableSearch
{
    if (shouldReset)
    {
        _searchTextField.text = @"";
        _cityArray = nil;
        _searchTextField.rightView.hidden = YES;
        [_searchResultsTableView reloadData];
    }
    
    if (shouldHideKeyboard)
    {
        [_searchTextField resignFirstResponder];
    }
    
    if (disableSearch)
        [self setSearchModeEnabled:NO];
}

- (NSString *)singleDecimalStringFromNumber:(NSNumber *)number
{
    return [NSString stringWithFormat:@"%.1f", [number floatValue]];
}


#pragma mark Misc

- (void)dealloc
{
    [_forecastDS.manager.operationQueue cancelAllOperations];
    _forecastDS = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
