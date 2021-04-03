//
//  SectionItem.swift
//  Hang-Out Planner
//
//  Created by Takayuki Yamaguchi on 2021-03-29.
//

import Foundation

// MARK: - Section
enum Section: Hashable {
  case list
  case other // not used. for scalability.
}

// MARK: - Item
enum Item {
  case category((id: UUID, val: Category)) // id is used to distinguish same category
  case plan(Plan)
  case route(Route)
  case location(Location)
}

// Category
extension Item {
  var categoryId: UUID? {
    if case let .category(c) = self {
      return c.id
    } else {
      return nil
    }
  }// wrapper -> associate value
  var category: Category? {
    if case let .category(c) = self {
      return c.val
    } else {
      return nil
    }
  }
  // associate value -> wrapper
  static func wrapCategory(items: [Category]) -> [Item] {
    return items.map {Item.category((UUID(), $0))}
  }
}

// Plan
extension Item {
  var plan: Plan? {
    if case let .plan(plan) = self {
      return plan
    } else {
      return nil
    }
  }
  // associate value -> wrapper
  static func wrapPlan(items: [Plan]) -> [Item] {
    return items.map {Item.plan($0)}
  }
}

// Route
extension Item {
  var route: Route? {
    if case let .route(r) = self {
      return r
    } else {
      return nil
    }
  }
  // associate value -> wrapper
  static func wrapRoute(items: [Route]) -> [Item] {
    return items.map {Item.route($0)}
  }
}

// Location
extension Item {
  var location: Location? {
    if case let .location(l) = self {
      return l
    } else {
      return nil
    }
  }
  // associate value -> wrapper
  static func wrapLocation(items: [Location]) -> [Item] {
    return items.map {Item.location($0)}
  }
}

// Hashable
extension Item: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.categoryId)
    hasher.combine(self.category)
    hasher.combine(self.plan)
    hasher.combine(self.route)
    hasher.combine(self.location)
  }
  static func == (lhs: Item, rhs: Item) -> Bool {
    return lhs.hashValue == rhs.hashValue
  }
}
