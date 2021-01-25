//
//  File.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation


/// Definition of categories
/// eg usage,
/// var userOrder: [Categories] = [.clothes, .restaurant, .park]
enum Categories : String {
  case amusement = "Amusement"
  case restaurant = "Restaurant"
  case clothes = "Clothes"
  case park = "Park"
  case cafe = "Cafe"
  case other = "Other"
}


/// Definition of categories used for yelp-API access.
/// In the future, we will match the name(not raw value), same as `Category`
enum CategoriesForAPI : String{
  case park = "parks,beaches"
  case cafe = "cafes,coffee,coffeeteasupplies,coffeeroasteries"
  case clothes = "menscloth,womenscloth"
  case artAndGallery = "museums,galleries,media,libraries,theater"
  case amusement = "arcades,amusementparks,aquariums,movietheaters"
}


