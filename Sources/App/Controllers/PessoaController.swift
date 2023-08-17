import Fluent
import Vapor

struct PessoaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let pessoa = routes.grouped("pessoa")
        pessoa.get(use: index)
        pessoa.post(use: create)
        pessoa.group(":pessoaID") { pessoa in
            pessoa.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Pessoa] {
        try await Pessoa.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Pessoa {
        let Pessoa = try req.content.decode(Pessoa.self)
        try await Pessoa.save(on: req.db)
        return Pessoa
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let pessoa = try await Pessoa.find(req.parameters.get("pessoaID"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await pessoa.delete(on: req.db)
        return .noContent
    }
}
