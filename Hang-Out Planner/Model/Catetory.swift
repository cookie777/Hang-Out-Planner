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
  case restaurantAndCafe = "Food & Cafe"
  case fashion = "Fashion"
  case artAndGallery = "Art & Gallery"
  case cafe = "Cafe"
  case other = "Other"
  
  static func color(_ categories: Categories)->UIColor{
    switch categories {
    case .fashion:
      return .systemPurple
    case .amusement:
      return .systemPink
    case .restaurantAndCafe:
      return .systemYellow
    case .cafe:
      return .systemOrange
    case .artAndGallery:
      return .systemGreen
    case .other:
      return UIColor.systemGray.withAlphaComponent(0.2)
    }
  }
  
  static func iconImage(_ categories: Categories)->UIImage?{
    switch categories {
    case .fashion:
      return UIImage(named: "store_mall_directory")
    case .amusement:
      return UIImage(named: "heart_fill")
    case .restaurantAndCafe:
      return UIImage(named: "restaurant")
    case .cafe:
      return UIImage(named: "local_cafe")
    case .artAndGallery:
      return UIImage(named: "book_fill")
    case .other:
      return UIImage(named: "")
    }
  }
  
  static func overrideImageColor(imgV : UIImageView,  category : Categories){
    let img = imgV.image
    imgV.image =  img?.withRenderingMode(.alwaysTemplate)
    imgV.tintColor = color(category)
  }
}


/// Definition of categories used for yelp-API access.
/// In the future, we will match the name(not raw value), same as `Category`
enum CategoriesForAPI : String{
  case restaurantAndCafe = "restaurants"
  case fashion = "accessories,menscloth,womenscloth,clothingrental,hats,shoes,sleepwear,sportsswear,vintage,formalwear,leather"
  case artAndGallery = "museums,galleries,media,libraries,theater,planetarium"
  case amusement = "arcades,amusementparks,aquariums,movietheaters,lasertag,escapegames,gokarts,waterparks,zoos,hauntedhouses,casinos"
  case cafe = "cafes,coffee,coffeeteasupplies,coffeeroasteries,bubbletea,juicebars,milkshakebars"
}

  
