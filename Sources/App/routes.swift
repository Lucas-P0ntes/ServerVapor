import Fluent
import Vapor

func routes(_ app: Application) throws {
  
  
    
    

    app.get{ req -> EventLoopFuture<View> in
        return req.view.render("hello", ["name": "Leaf"])
    }
    try app.register(collection: PessoaController())
    try app.register(collection: ImageController())
}
