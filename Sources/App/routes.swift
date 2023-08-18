import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    /// config max upload file size
    app.routes.defaultMaxBodySize = "100mb"
    
    /// setup public file middleware (for hosting our uploaded files)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    

    app.get{ req -> EventLoopFuture<View> in
        return req.view.render("hello", ["name": "Leaf"])
    }
    try app.register(collection: PessoaController())
    try app.register(collection: ImageController())
}
