
# Hang-Out-Planner

## Concept
Hang-Out-Planner is an application which instantly auto-generates a daily plan.

## User
- People who are not familiar with the user’s current place.                                  (e.g. tourists, transients living in the city, etc.)
- People who are lazy to make plans

## Feature
- You can choose maximum 5 categories which you’re interested in
- You can make daily plans for the place of user’s current location
- You can see the directions and route options between each place on the map 
- You can see concise introduction of each place


## API
This application uses two API(MapKit and Yelp API).
### Mapkit
Display map or satellite imagery within your app, call out points of interest,and determine placemark information for map coordinates.

[Website](https://developer.apple.com/documentation/mapkit/)



### Yelp API
Yelp is a popular online directory for discovering local businesses ranging from bars, restaurants, and cafes to hairdressers, spas, and gas stations.

[Website](https://www.yelp.com/developers)


### ip-api
We can get geolocation from IP address.

[Website](https://ip-api.com)

## Usage
1, Select maximum 5 categories and tap go button.

![ezgif com-video-to-gif](https://user-images.githubusercontent.com/60034714/106401685-4d8c6900-63da-11eb-9f38-24f14c4ce184.gif)

Then, the application is going to generate some daily plan near your current place.

2, Tap a plan which application generated.

![ezgif com-video-to-gif-2](https://user-images.githubusercontent.com/60034714/106401769-b96ed180-63da-11eb-878b-c970cc916a1d.gif)

Then, the application is going to show the route and concise introduction of each place.

3, Tap a place in the plan.

![ezgif com-video-to-gif](https://user-images.githubusercontent.com/60034714/106401790-e327f880-63da-11eb-99a3-9a6cd2e6d87b.gif)


Then, the application is going to show the detail of the place. If you tap the “Yelp” label right bottom of the screen, you can go to the Yelp website of the place in Safari.


<img width="200" alt="image" src="https://user-images.githubusercontent.com/60034714/106401877-8416b380-63db-11eb-8f2c-987cf2e1dc53.png">


Then, the application is going to show the detail of the place. If you tap the “Yelp” label right bottom of the screen, you can go to the Yelp website of the place in Safari.

<img width="200" alt="image" src="https://user-images.githubusercontent.com/60034714/106367428-7556d080-62f7-11eb-8e29-8e38a6889032.png">

## Contribution

### Taka (`cookie777`)
- Manage our group  
- Design & UI
- Model for logic part 
- MapKit
- YelpAPI

### Yumi (`YumiMachin`)
- ViewController for Result
- MapKit
- Refine category
- Select category icon


### Kengo (`kengo-taka`)
- ViewController for input
- ReadMe
- Set cache


## Future Work
- User can share the plan 
- User save the plan and route
- Easy to use all over the world (By using other API like Yelp)
