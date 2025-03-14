import Fluent
import Vapor

func routes(_ app: Application) throws {
  let controller = PokemonController()
  app.get("pokemon", use: controller.index)
  app.post("pokemon", use: controller.create)
}
