//
//  File.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-01-17.
//

import Foundation
import UIKit


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
  
  static func color(_ categories: Categories)->UIColor{
    switch categories {
    case .clothes:
      return .systemPurple
    case .amusement:
      return .systemPink
    case .restaurant:
      return .systemOrange
    case .cafe:
      return .systemYellow
    case .park:
      return .systemGreen
    case .other:
      return UIColor.systemGray.withAlphaComponent(0.2)
    }
  }
  
  static func sfSymbolImage(_ categories: Categories)->UIImage?{
    switch categories {
    case .clothes:
      return setImage("bag", categories)
    case .amusement:
      return setImage("music.mic", categories)
    case .restaurant:
      return setImage("photo", categories)
    case .cafe:
      return setImage("tornado", categories)
    case .park:
      return setImage("tortoise", categories)
    case .other:
      return setImage("person", categories)
    }
  }
  
  static func setImage(_ str: String, _ category : Categories)->UIImage{
    return (UIImage(systemName: str, withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))?.withTintColor(Categories.color(category), renderingMode: .alwaysOriginal))!
  }
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


