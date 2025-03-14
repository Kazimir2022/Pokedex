//
//  PokemonController.swift
//  Pokedex
//
//  Created by Kazimir on 13.03.25.
//

import Fluent
import Vapor

/// Controllers querying and storing new Pokedex entries.
final class PokemonController {
  /// Lists all known pokemon in our pokedex.
   func index(_ req: Request) throws -> EventLoopFuture<[Pokemon]> {
    return Pokemon.query(on: req.db).all()
  }
  
  /// Stores a newly discovered pokemon in our pokedex.
  func create(_ req: Request) throws -> EventLoopFuture<Pokemon> {
    let newPokemon = try req.content.decode(Pokemon.self)
    /// Check to see if the pokemon already exists
    return Pokemon.query(on: req.db).filter(\.$name == newPokemon.name).count().flatMapThrowing { count in
      /// Ensure number of Pokemon with the same name is zero
      guard count == 0 else {
        throw Abort(.badRequest, reason: "You already caught \(newPokemon.name).")
      }
    }.flatMap { _ in
        /// Check if the pokemon is real. This will throw an error aborting
        /// the request if the pokemon is not real.
        return req.pokeAPI.verify(name: newPokemon.name)
      }.flatMap { nameVerified in
        /// Ensure the name verification returned true, or throw an error
        guard nameVerified else {
          return req.eventLoop.makeFailedFuture(Abort(.badRequest, reason: "Invalid Pokemon \(newPokemon.name)."))
        }
        
        /// Save the new Pokemon
        return newPokemon.save(on: req.db)
          .transform(to: newPokemon)
    }
  }
}
