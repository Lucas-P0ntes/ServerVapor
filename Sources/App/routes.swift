import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    /// config max upload file size
    app.routes.defaultMaxBodySize = "100mb"
    
    /// setup public file middleware (for hosting our uploaded files)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    // MARK: /collect
    let collectFileController = CollectFileController()
    app.get("collect", use: collectFileController.index)
    
    /// Using `body: .collect` we can load the request into memory.
    /// This is easier than streaming at the expense of using much more system memory.
    app.on(.POST, "collect",
           body: .collect(maxSize: 10_000_000),
           use: collectFileController.upload)

   
    
    
    app.get{ req -> EventLoopFuture<View> in
        return req.view.render("hello", ["name": "Leaf"])
    }
    try app.register(collection: PessoaController())
    try app.register(collection: ImageController())
}
