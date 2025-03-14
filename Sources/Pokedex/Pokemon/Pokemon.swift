//
//  Pokemon.swift
//  Pokedex
//
//  Created by Kazimir on 13.03.25.
//

import Fluent
import Vapor

/// Represents a Pokemon we have captured and logged in our Pokedex.
final class Pokemon: Model {
  static let schema = "pokemon"
  
  /// See `Model.id`
  @ID(key: .id)
  var id: UUID?
  
  /// The Pokemon's name.
  @Field(key: "name")
  var name: String
  
  /// See `Timestampable.createdAt`
  @Timestamp(key: "created_at", on: .create)
  var createdAt: Date?
  
  /// See `Timestampable.updatedAt`
  @Timestamp(key: "updated_at", on: .update)
  var updatedAt: Date?
  
  init() { }
  
  /// Creates a new `Pokemon`.
  init(id: UUID? = nil, name: String) {
    self.id = id
    self.name = name
  }
}

/// Allows this model to be parsed/serialized to HTTP messages
/// as JSON or any other supported format.
extension Pokemon: Content { }

/// Allows this Model to be used as its own database migration.
/// The database schema will be inferred from the Model's properties.
struct CreatePokemon: Migration {
  func prepare(on database: Database) -> EventLoopFuture<Void> {
    database.schema("pokemon")
      .id()
      .field("name", .string, .required)
      .field("created_at", .datetime)
      .field("updated_at", .datetime)
      .create()
  }
  
  func revert(on database: Database) -> EventLoopFuture<Void> {
    database.schema("pokemon").delete()
  }
}
