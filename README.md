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


![ezgif com-video-to-gif-6](https://user-images.githubusercontent.com/60034714/106438984-0c24a980-642c-11eb-8ba1-49d6363e6039.gif)


Then, the application is going to generate some daily plan near your current place.

2, Tap a plan which application generated.

![ezgif com-video-to-gif-9](https://user-images.githubusercontent.com/60034714/106439831-ffed1c00-642c-11eb-9a4c-2a44593f67ea.gif)


Then, the application is going to show the route and the name of each place.


![ezgif com-video-to-gif-4](https://user-images.githubusercontent.com/60034714/106427560-76355280-641c-11eb-80b3-87fab3348385.gif)

Even if fetching image delay, placeholdern will be shown until compleating fetching.

3, Tap a place in the plan.


![ezgif com-video-to-gif-7](https://user-images.githubusercontent.com/60034714/106438820-d7185700-642b-11eb-82b9-618068631092.gif)



Then, the application is going to show the detail of the place.

If you tap the “Yelp” label right bottom of the screen, you can go to the Yelp website of the place in Safari.



![ezgif com-video-to-gif-8](https://user-images.githubusercontent.com/60034714/106438832-dbdd0b00-642b-11eb-97fc-580f61ce7780.gif)



## Background

### First screen
<img width="400" alt="image" src="https://user-images.githubusercontent.com/60034714/106431532-41c49500-6422-11eb-97ee-cb1d41399813.png">

### When user tap "Go"
<img width="400" alt="image" src="https://user-images.githubusercontent.com/60034714/106431544-4721df80-6422-11eb-8ce1-e4e07293e9f3.png">

### Showing the result
<img width="400" alt="image" src="https://user-images.githubusercontent.com/60034714/106431561-4d17c080-6422-11eb-87c7-0b2e5c722414.png">


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
