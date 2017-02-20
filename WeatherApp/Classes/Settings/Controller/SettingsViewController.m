//
//  SettingsViewController.m
//  Weather
//
//  Created by Dejan Kraguljac  on 15/02/17.
//
//

#import "SettingsViewController.h"
#import "SettingsTableViewHeader.h"
#import "SettingsCityCell.h"
#import "SettingsConditionsCell.h"
#import "SettingsUnitsCell.h"

@interface SettingsViewController ()
{
    __weak IBOutlet UITableView *_tableView;
    
    NSFetchedResultsController *_fetchController;
    NSManagedObjectContext *_mainManagedObjectContext;
    NSArray *array;
    
}
@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mainManagedObjectContext  = [[CoreDataManager sharedManager] mainManagedObjectContext];
    [self addLeftNavbarButton];
    [self setupTableView];
    [self loadData];
    
}

- (void)addLeftNavbarButton
{
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeVC)];
    self.navigationItem.leftBarButtonItem = doneButton;
}

- (void)setupTableView
{
    [_tableView registerNib:[UINib nibWithNibName:@"SettingsTableViewHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"SettingsTableViewHeaderIdentifier"];
    [_tableView registerNib:[UINib nibWithNibName:@"SettingsCityCell" bundle:nil] forCellReuseIdentifier:@"SettingsCityCellIdentifier"];
    [_tableView registerNib:[UINib nibWithNibName:@"SettingsConditionsCell" bundle:nil] forCellReuseIdentifier:@"SettingsConditionsCellIdentifier"];
    [_tableView registerNib:[UINib nibWithNibName:@"SettingsUnitsCell" bundle:nil] forCellReuseIdentifier:@"SettingsUnitsCellIdentifier"];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    CGFloat dummyViewHeight = 40;
    UIView *dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, dummyViewHeight)];
    _tableView.tableHeaderView = dummyView;
    _tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0);

}


- (void)bindGUI
{
    [_tableView reloadData];//toooooooooooooooooooooooooooooooooooooooooooo
}




- (void)loadData
{
    array = [[CoreDataManager sharedManager] citiesForSearchQuery:@""];
    
    [self bindGUI];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [array count];
    else if (section == 1)
        return 3;
    else
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self)weakSelf = self;
    
    if (indexPath.section == 0)
    {
        SettingsCityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCityCellIdentifier"];
        
        cell.cityEntitiy = ((CityEntity *)[array objectAtIndex:indexPath.row]);
        __weak typeof(self)weakSelf = self;
        cell.deleteCityButtonTapped = ^(CityEntity *cityToDelete)
        {
            [weakSelf deleteCityEntity:cityToDelete];
        };
        
        if (((CityEntity *)[array objectAtIndex:indexPath.row]).isSelected)
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        SettingsConditionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsConditionsCellIdentifier"];
        
        cell.valueChanged = ^()
        {
            [weakSelf callShouldRefreshWeatherBlock];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.titleString = @"Humidity";
                cell.conditionType = Humidity;
                break;
            case 1:
                cell.titleString = @"Wind";
                cell.conditionType = WindSpeed;
                break;
            case 2:
                cell.titleString = @"Pressure";
                cell.conditionType = Pressure;
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    else
    {
        SettingsUnitsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsUnitsCellIdentifier" forIndexPath:indexPath];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.valueChanged = ^()
        {
            [weakSelf callShouldRefreshWeatherBlock];
        };
    
        return cell;
    }
    
    return [UITableViewCell new];
}

- (void)deleteCityEntity:(CityEntity *)cityToDelete
{
    NSArray *objectsToDelete = [[CoreDataManager sharedManager] citiesForSearchQuery:[NSString stringWithFormat:@"geonameId == %f", cityToDelete.geonameId]];
    
    if ([objectsToDelete count] > 0)
        [_mainManagedObjectContext deleteObject:[objectsToDelete firstObject]];
    
    [self loadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0)
    {
        CityEntity *selectedEntity = [array objectAtIndex:indexPath.row];
        [selectedEntity setValue:@YES forKey:@"isSelected"];
        
    }
    [self callShouldRefreshWeatherBlock];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CityEntity *deselectedEntity = [array objectAtIndex:indexPath.row];
        [deselectedEntity setValue:@NO forKey:@"isSelected"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}



- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *const headerIdentifier = @"SettingsTableViewHeaderIdentifier";
    
    SettingsTableViewHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    
    if (!headerView)
        headerView = [SettingsTableViewHeader new];
    
    headerView.backgroundView.backgroundColor = [UIColor flatGrayColor];
    
    if (section == 0)
        headerView.titleString = @"Location";
    else if (section == 1)
        headerView.titleString = @"Conditions";
    else if (section == 2)
        headerView.titleString = @"Units";
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42;
}

- (void)callShouldRefreshWeatherBlock
{
    if (_shouldRefreshWeather)
        _shouldRefreshWeather();
}

- (void)closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
