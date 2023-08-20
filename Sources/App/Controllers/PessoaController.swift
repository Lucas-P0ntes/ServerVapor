import Fluent
import Vapor

struct PessoaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let pessoa = routes.grouped("pessoa")
        
        pessoa.get(use: index)
        pessoa.post(use: create)
        
        
        pessoa.group(":id") { pessoa in
            pessoa.delete(use: delete)
            pessoa.delete(use: update)

        }
    }
    
    func index(req: Request) async throws -> [PessoaModel] {
        
        try await PessoaModel.query(on: req.db).all()
        
    }
    func create(req: Request) async throws -> HTTPStatus {
        
        let imageData = try await req.content.decode(ImageUploadData.self)
        
        let imageFolder = "/Public/images/"
        let imageName = "\(UUID()).jpg" // Use o ID da pessoa para gerar um nome único
        
        let path = req.application.directory.workingDirectory + imageFolder + imageName
        
        try await req.fileio.writeFile(.init(data: imageData.picture), at: path)
        
        var pessoa = try await req.content.decode(PessoaModel.self)
        
        pessoa.img_profile = "https://boiling-thicket-76996-175f21afe3b7.herokuapp.com/images/\(imageName)"
        try await pessoa.save(on: req.db)
        
        return HTTPStatus.accepted
    }
    
    func update(req: Request)async throws -> HTTPStatus {
        guard let pessoa = try await PessoaModel.find(req.parameters.get("id"), on: req.db) else {
               throw Abort(.notFound)
           }
           let updatedPessoa = try req.content.decode(PessoaModel.self)
        pessoa.name = updatedPessoa.name
           try await pessoa.save(on: req.db)
        return .accepted
    }
        
        func delete(req: Request) async throws -> HTTPStatus {
            guard let pessoa = try await PessoaModel.find(req.parameters.get("id"), on: req.db) else {
                throw Abort(.notFound)
            }
            try await pessoa.delete(on: req.db)
            return .noContent
        }
    }
