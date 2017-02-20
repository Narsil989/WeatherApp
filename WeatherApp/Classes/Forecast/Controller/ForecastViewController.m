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
    
    __weak IBOutlet UIButton *_backgroundButton;
    __weak IBOutlet UITableView *_searchResultsTableView;
    
    NSArray *_cityArray;
    
    BOOL _searchModeAnimationStared;
    
    ForecastDataSource *_forecastDS;
}

@end

@implementation ForecastViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self layoutGUI];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    [_searchResultsTableView setSeparatorColor:[UIColor clearColor]];
    
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
    
    _backgroundButton.hidden = _searchResultsTableView.hidden = YES;
    
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

#pragma mark Search TextField setup

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
    UIImageView *searchIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SearchIcon"]];
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

#pragma mark Clear search TextField

- (void)clearTextField
{
    [self resetSearchTextField:YES andHideKeyBoard:NO andDisableSearch:NO];
    if (![_searchTextField isFirstResponder]) [_searchTextField becomeFirstResponder];
}

#pragma mark - LoadData

- (void)loadData
{
    _currentCity = [[[CoreDataManager sharedManager] citiesForSearchQuery:@"isSelected == YES"] firstObject];
    _currentWeather = ConfigManager.userWeather;
    
    if (!_currentCity)
        [self loadCurretCityData];
    else
        [self bindGUI];
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
    [_forecastDS getWeatherWithLongitude:_currentCity.longitude andLatitude:_currentCity.latitude WithcompletionBlock:^(BOOL success, NSError *err, NSArray *arr) {
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        
        
        if (success && !err)
            _currentWeather = [arr firstObject];
        
        [LoadingView hideLoadingViewForView:weakSelf.view WithCompletionBlock:^{
            
            [strongSelf bindGUI];
            
            // need to add error handling
            
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
    
    [self layoutGUI];
    
}

#pragma mark - LayoutGUI

- (void)layoutGUI
{
    if (_currentWeather)
        self.view.backgroundColor = _currentWeather.backgroudColor;
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
                }
                else
                {
                    // add eror handling
                }
                
                [_searchResultsTableView reloadData];
                [textField resignFirstResponder];
                
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
    
    _searchModeAnimationStared = YES;
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
        
        _backgroundButton.hidden = _searchResultsTableView.hidden = !enabled;
        
        [weakSelf.view setNeedsLayout];
        [weakSelf.view  layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
        _searchModeAnimationStared = NO;
        
        if (enabled)
            [self animateCancelButton:enabled];
    }];
    
    
}

- (void)animateCancelButton:(BOOL)show
{
    _cancelButtonContainerViewLeadingConstraint.constant = show ? - _cancelButtonContainerView.frame.size.width - 5 : 0;
    
    __weak typeof(self)weakSelf = self;
    
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
        [self resetSearchTextField:YES andHideKeyBoard:YES andDisableSearch:YES];
    else
        [_searchTextField resignFirstResponder];
}
- (IBAction)settingsButtonTapped:(id)sender
{
    SettingsViewController *settingsVC = [SettingsViewController new];

    __weak typeof(self)weakSelf = self;
    
    settingsVC.shouldRefreshWeather = ^(){
        
        _currentCity = [[[CoreDataManager sharedManager] citiesForSearchQuery:@"isSelected == YES"] firstObject];
        
        [weakSelf loadWeather];
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
    if (!_searchModeAnimationStared)
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
                                              inManagedObjectContext:[[CoreDataManager sharedManager] mainManagedObjectContext]];
    
    CityEntity *item = [[CityEntity alloc] initWithEntity:entity insertIntoManagedObjectContext:[[CoreDataManager sharedManager] mainManagedObjectContext]];
    
    item.name = selectedCity.name;
    item.countryCode = selectedCity.countryCode;
    item.geonameId = [selectedCity.geonameId floatValue];
    
    [[[CoreDataManager sharedManager] mainManagedObjectContext] save:nil];
    
}

#pragma mark - Helpers

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
