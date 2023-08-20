import NIOSSL
import Fluent
import FluentPostgresDriver
import Vapor
import Leaf


// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    
    
    if let databaseURL = Environment.get("DATABASE_URL") {
        var tlsConfig: TLSConfiguration = .makeClientConfiguration()
        tlsConfig.certificateVerification = .none
        let nioSSLContext = try NIOSSLContext(configuration: tlsConfig)
        var postgresConfig = try SQLPostgresConfiguration(url: databaseURL)
        postgresConfig.coreConfiguration.tls = .require(nioSSLContext)

        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    } else {
        // ...
    }
    
    app.migrations.add(CreatePessoa())
    app.migrations.add(CreateProject())

    app.views.use(.leaf)

    // register routes
    try routes(app)
}
