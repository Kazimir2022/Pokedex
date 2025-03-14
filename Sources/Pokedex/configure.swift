import NIOSSL
import Fluent
import FluentSQLiteDriver
import Vapor

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
  /// Setup a simple in-memory SQLite database
  app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

  /// Configure migrations
  app.migrations.add(CreatePokemon())
  //Кэшированные значения сохраняются между перезапусками приложений.
  app.migrations.add(CacheEntry.migration)
  
  try await app.autoMigrate().get()
  app.caches.use(.fluent)
  /// Register routes
  try routes(app)
}
