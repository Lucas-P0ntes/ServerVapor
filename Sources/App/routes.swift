import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    /// config max upload file size
    app.routes.defaultMaxBodySize = "100mb"
    
    /// setup public file middleware (for hosting our uploaded files)
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
    app.post("upload") { req -> EventLoopFuture<View> in
        struct Input: Content {
            var file: File
        }
        let input = try req.content.decode(Input.self)

        guard input.file.data.readableBytes > 0 else {
            throw Abort(.badRequest)
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "y-m-d-HH-MM-SS-"
        let prefix = formatter.string(from: .init())
        let fileName = prefix + input.file.filename
        let path = app.directory.publicDirectory + fileName
        let isImage = ["png", "jpeg", "jpg", "gif"].contains(input.file.extension?.lowercased())

        return req.application.fileio.openFile(path: path,
                                               mode: .write,
                                               flags: .allowFileCreation(posixMode: 0x744),
                                               eventLoop: req.eventLoop)
            .flatMap { handle in
                req.application.fileio.write(fileHandle: handle,
                                             buffer: input.file.data,
                                             eventLoop: req.eventLoop)
                    .flatMapThrowing { _ in
                        try handle.close()
                    }
                    .flatMap {
                        req.leaf.render(template: "result", context: [
                            "fileUrl": .string(fileName),
                            "isImage": .bool(isImage),
                        ])
                    }
            }
    }
    
    
    app.get{ req -> EventLoopFuture<View> in
        return req.view.render("hello", ["name": "Leaf"])
    }
    try app.register(collection: PessoaController())
    try app.register(collection: ImageController())
}
