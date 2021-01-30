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


### Yelp API
Yelp is a popular online directory for discovering local businesses ranging from bars, restaurants, and cafes to hairdressers, spas, and gas stations.


## Usage
1, Select maximum 5 categories and tap go button.

<img width="200" alt="image" src="https://user-images.githubusercontent.com/60034714/106366955-f90ebe00-62f3-11eb-8bc4-b8d37ebff380.png"> <img width="184" alt="image" src="https://user-images.githubusercontent.com/60034714/106366969-2491a880-62f4-11eb-8fa1-daaa2c2e5985.png">

Then, the application is going to generate some daily plan near your current place.

2, Tap a plan which application generated.

<img width="200" alt="image" src="https://user-images.githubusercontent.com/60034714/106366972-28252f80-62f4-11eb-95d0-c99bbbb6c383.png"> <img width="200" alt="image" src="https://user-images.githubusercontent.com/60034714/106366973-2b202000-62f4-11eb-94a6-595819e9aa5f.png">

Then, the application is going to show the route and concise introduction of each place.

3, Tap a place in the plan.

<img width="200" alt="image" src="https://user-images.githubusercontent.com/60034714/106366977-2e1b1080-62f4-11eb-8247-a533ad26deb3.png"> <img width="204" alt="image" src="https://user-images.githubusercontent.com/60034714/106366979-307d6a80-62f4-11eb-81c8-a25afedba572.png">

Then, the application is going to show the detail of the place. If you tap the “Yelp” label right bottom of the screen, you can go to the Yelp website of the place in Safari.


<img width="200" alt="image" src="https://user-images.githubusercontent.com/60034714/106366981-33785b00-62f4-11eb-9a64-1258575cf92f.png">

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

