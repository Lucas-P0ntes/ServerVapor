//
//  File.swift
//  
//
//  Created by Lucas Pontes on 16/08/23.
//

import Foundation

import Vapor
import Fluent

struct ImageController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        // Define uma rota para buscar uma imagem por nome de arquivo
        routes.get("images", ":filename", use: getImage)
        routes.post("images", use: addProfilePictureHandler)

        
    }
    
    func getImage(req: Request) throws -> EventLoopFuture<Response> {
        guard let filename = req.parameters.get("filename") else {
            throw Abort(.badRequest)
        }
        
        let fileManager = FileManager.default
        let imagePath = fileManager.currentDirectoryPath + "/Public/images/" + filename // Certifique-se de ajustar o caminho do diretório das imagens conforme necessário
        
        let response = req.eventLoop.makePromise(of: Response.self)
        
        if fileManager.fileExists(atPath: imagePath) {
            do {
                let imageData = try Data(contentsOf: URL(fileURLWithPath: imagePath))
                let imageResponse = Response(status: .ok, body: .init(data: imageData))
                imageResponse.headers.add(name: "Content-Type", value: "image/jpeg") // Substitua pelo tipo de conteúdo correto, se necessário
                response.succeed(imageResponse)
            } catch {
                response.fail(error)
            }
        } else {
            response.fail(Abort(.notFound))
        }
        
        return response.futureResult
    }
    
    func addProfilePictureHandler(for req: Request) async throws -> String  {
        // Decode the image data from the request content
        let data = try await req.content.decode(ImageUploadData.self)
        
        // Get the authenticated user from the request
        
        
        // Find the user in the database based on the authenticated user's ID
        
        
    
        
        let imageFolder  = "/Public/images/"
        let imageName = "lucas.jpg"
        
        // It can be a path outside the main program
        let path = req.application.directory.workingDirectory + imageFolder + imageName
        
        try await req.fileio.writeFile(.init(data: data.imgScreenshot), at: path)
        
        
       // return
        return " http://localhost:8080/xxx/xxx.jpg"
    }
}

struct ImageUploadData: Content {
    var imgScreenshot: Data
    var imgIcon: Data
}
