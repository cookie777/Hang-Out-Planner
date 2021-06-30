# iOS: Hang out Planner

keyword: Swift, REST API, DispatchGroup, diffable data sources, MapKit, CoreLocation

## Summary
Created a native iOS application with Swift. This app suggests optimized root which includes locations that the user prefers. This app uses modern collection views with diffable data source, async API-fetch with dispatch group.

## Motivation

### Problem

These days, there are a lot of locations and places where we want to visit. However, it is very difficult to find out which to visit, and next to visit.

This is because,

1. There are too many places so that it is troublesome to find out decent ones.
2. Even if you find out them, it is also painstaking to think about the best route. For example, which places to visit first and next so that we can go multiple places efficiently.

### Solution

To solve these problems, we created is a great application, which instantly and automatically generates a plan which is a collection of navigation routes based on famous locations surrounded by your current location.

<div align="center" >
<img class="app-screen-capture" src="https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/animation-summary.webp" alt="select categories" width=240 border-radius="6px" style="border: 2px solid #021a40; background-color: #ff0;border-radius: 6px;"/>
</div>

## Spec

- Swift: version 5.4
- MapKit: To display route and user location
- Core Location: To get the user current location
- REST-API: Get external location data from yelp.
- Collection View: With diffable data source.

## Usage

### Flow

The user first selects some categories of locations with the order. Then the app will fetch locations surrounded by a user and calculates auto-suggests the best (most famous and closest) route includes locations that belong to the category user has chosen. 

For example, if a user chooses 'Restaurant' ➔ 'Nature, Park' ➔ 'Art' in New York, the app will suggest the route 'SHAKE SHACK' ➔ 'Central Park' ➔ 'Carnegie Hall'.

### How to use

1. A user selects some categories with their preferred order. 
2. After deciding categories, a list of plans is displayed to a user.
3. After selecting a plan, a user can look at its details with routes on the map, distance, cost, and so on.
4. Of course, users can see each location's data.

<div align="center" style="
  display: inline-flex;
  gap: 16px;
">
  <img class="app-screen-capture" src="https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/animation-todo.webp" alt="todo"  width=240 style="border: 2px solid #021a40; background-color: #ff0;border-radius: 6px;"/>

  <img class="app-screen-capture" src="https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/animation-planner.webp" alt="planner" width=240 style="border: 2px solid #021a40; background-color: #ff0;border-radius: 6px;"/>

  <img class="app-screen-capture"  src="https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/animation-location-manager.webp"  alt="location-manager" width=240 style="border: 2px solid #021a40; background-color: #ff0;border-radius: 6px;" />
</div>


## Agile project management

We used notion for scheduling and used the agile style. This makes this project complete in just two weeks!

![Schedules](https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/manager-schedule.webp)
![Docs](https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/manager-docs.webp)
![Tasks](https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/manager-requirements.webp)


## UI Designing

We created a whole UI mock using Figma. In addition to creating a style guide, We create design components that are well suitable for implementing swift codes.

![UI mock 1](https://github.com/cookie777/images/blob/main/works/2021-01-Hang-Out-Planner/ui-mock1.webp?raw=true)
![UI mock 2](https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/ui-mock2.webp)


## Back-end

We design the architecture and algorithm of fetching and suggesting items. We also created tracking of user location by using core location.

### Fetching user location

The app fetches the user's location in two ways, locationManager and IP address.
When you visit the target screen, we set the location manager to start fetching his/her location. Even a user denies it, we can assume approximate location by using the IP address from API.

![Fetching location](https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/back-end-location.webp)


This function will be executed at `sceneWillEnterForeground` and `viewWillAppear`

```swift
extension LocationController {
  /// Start updating(tacking) user location
  /// - Parameter completion: an action you want to do when the user location is updated.
  func start(completion : @escaping(()->Void)) {
    locationManager.requestAlwaysAuthorization()
    locationManager.startUpdatingLocation()
    isUpdatingLocation = true
    self.completionDidLocationUpdated = completion
  }
```

### How to suggest the routes

![DispatchGroup](https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/back-end-fetching.webp)

After a user decides their categories, this app asks API (yelp) to fetch related locations. It will ask serval times to get different times. These fetching are executed as **async and concurrently**. Once all fetching has complete, we proceed to the next step. These processes were realized by using `DispatchGroup`.

```swift
    group.enter()
    NetworkController.shared.fetchLocations(
      group : group,
      category:CategoriesForAPI.amusement,
      completion: NetworkController.shared.convertAndStoreLocation
    )
```

```swift
    // This is executed after "all fetch are done"
    group.notify(queue: .main) {
      
      // Creating final locations with adding user location and assigning id.
      User.allLocations.removeAll()
      User.allLocations = [User.userLocation] + NetworkController.shared.tempAllLocations
      (0..<User.allLocations.count).forEach{User.allLocations[$0].id = $0}
      // Remove temp data for memory saving.
      NetworkController.shared.tempAllLocations.removeAll()
      
      completion()
      
    }
```

### Async Fetching

Fetching images is expensive. Sometimes, if the internet connection is weak it costs a lot of time to get images. In this kind of situation, we didn't want the screen to stop until it fetched and displayed images. So we firstly display place holder and try fetching images asynchronously. As soon as it finished fetching, we replace images so that the user can feel no stress!

<div align="center">
<img class="app-screen-capture" align="center" src="https://raw.githubusercontent.com/cookie777/images/main/works/2021-01-Hang-Out-Planner/animation-async-fetch.webp" alt="look the plan detail" width=240 style=" border: 2px solid #021a40; background-color: #ff0;border-radius: 6px;"/>
</div>

## Future work

What we're planning to do next is as follows.

- Store plans as permanent data using core data or realm
- Publish in the app store
- Implement user account by using firebase


## Team member

### Tak (me :[cookie777](https://github.com/cookie777))

- Team manager
- UI Designer
- Back end developer

### Yumi ([YumiMachin](https://github.com/YumiMachino))

- Front end 
- Back end (implement image API fetching)


### Kengo ([kengo-taka](https://github.com/kengo-taka))

- Front end
- Created ReadMe, Docs.
