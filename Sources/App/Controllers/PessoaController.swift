import Fluent
import Vapor

struct PessoaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let pessoa = routes.grouped("pessoa")
        
        pessoa.get(use: getPessoa)
        pessoa.post(use: createWithProfilePicture)
        
        
        pessoa.group(":pessoaID") { pessoa in
            pessoa.delete(use: delete)
        }
    }
    
    func getPessoa(req: Request) async throws -> [Pessoa] {
        
        try await Pessoa.query(on: req.db).all()
        
    }
    func createWithProfilePicture(req: Request) async throws -> HTTPStatus {
        
        let imageData = try await req.content.decode(ImageUploadData.self)
     
        let imageFolder = "/Public/images/"
        let imageName = "\(UUID()).jpg" // Use o ID da pessoa para gerar um nome único
        
        let path = req.application.directory.workingDirectory + imageFolder + imageName
        
        try await req.fileio.writeFile(.init(data: imageData.picture), at: path)
        
        var pessoa = try await req.content.decode(Pessoa.self)
        pessoa.img_profile = "https://boiling-thicket-76996-175f21afe3b7.herokuapp.com/images/\(imageName)"
        try await pessoa.save(on: req.db)
        
        return HTTPStatus.accepted
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
