import Fluent
import Vapor

struct PessoaController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let pessoa = routes.grouped("pessoa")
        
        pessoa.get(use: getPessoa)
        pessoa.post(use: create)
        
        pessoa.group(":pessoaID") { pessoa in
            pessoa.delete(use: delete)
        }
    }
    
    func getPessoa(req: Request) async throws -> [Pessoa] {
        
        try await Pessoa.query(on: req.db).all()
        
    }
    func createWithProfilePicture(req: Request) async throws -> HTTPStatus {
        // Aqui estamos tentando decodificar o conteúdo da requisição (que é do tipo Pessoa) para um objeto Pessoa.
        var pessoa = try await req.content.decode(Pessoa.self)
        
        // Decode the image data from the request content
        let imageData = try await req.content.decode(ImageUploadData.self)
        // Agora estamos tentando salvar o objeto Pessoa no banco de dados associado à requisição.
 
        
       
        let imageFolder = "/Public/images/"
        let imageName = "profile.jpg" // Use o ID da pessoa para gerar um nome único
        
        // O caminho onde a imagem será salva é composto pela pasta de trabalho do aplicativo, pasta de imagens e nome do arquivo.
        let path = req.application.directory.workingDirectory + imageFolder + imageName
        
        // Tenta gravar o arquivo da imagem no caminho especificado.
        try await req.fileio.writeFile(.init(data: imageData.picture), at: path)
        
        // Atualiza a URL da imagem de perfil na Pessoa e salva no banco de dados
        //pessoa.profilePictureURL = "http://localhost:8080/xxx/\(imageName)" // Atualize a URL conforme sua configuração
        pessoa.img_profile = "https://boiling-thicket-76996-175f21afe3b7.herokuapp.com/images/\(imageName)"
        try await pessoa.save(on: req.db)
        // Retorna a Pessoa com a imagem de perfil atualizada.
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
