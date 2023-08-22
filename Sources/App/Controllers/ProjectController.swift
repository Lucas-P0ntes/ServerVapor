//
//  File.swift
//
//
//  Created by Lucas Pontes on 20/08/23.
//
import Fluent
import Vapor
import Foundation

struct ProjectController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let project = routes.grouped("project")
        
        project.get(use: index)
        project.post(use: create)
        
        
        project.group(":id") { pessoa in
            project.delete(use: delete)
            project.put(use: update)
            
        }
    }
    
    func index(req: Request) async throws -> [ProjectModel] {
        
        let projects = try await ProjectModel.query(on: req.db).all()
           
           // Decodificar URLs codificadas nas propriedades de imagem de cada projeto
           for var project in projects {
               if let decodedURL = project.link.removingPercentEncoding {
                   project.link = decodedURL
               }
               if let decodedURL = project.imgIcon?.removingPercentEncoding {
                   project.imgIcon = decodedURL
               }
               if let decodedURL = project.imgScreenshot?.removingPercentEncoding {
                   project.imgScreenshot = decodedURL
               }
               
           }
        return projects
        
    }
    
    func create(req: Request) async throws -> ProjectModel{
        let data = try await req.content.decode(ImageUploadData.self)
        
        let id = UUID()
        let imageFolder = "/Public/images/"
        
 
        
        let imageNameIcon = "\(id)Icon.jpg"
        let imageNamePicture = "\(id)Picture.jpg"
        // It can be a path outside the main program
        
        let pathIcon = req.application.directory.workingDirectory + imageFolder + imageNameIcon
        let pathPicture = req.application.directory.workingDirectory + imageFolder + imageNamePicture

        
        try await req.fileio.writeFile(.init(data: data.imgScreenshot), at: pathPicture)
        try await req.fileio.writeFile(.init(data: data.imgIcon), at: pathIcon )
        
       
        let project = try req.content.decode(ProjectModel.self)
        project.id = id
        project.imgIcon = "https://api-project-academy-9cf71ea0cac6.herokuapp.com/images/\(imageNameIcon)"
        project.imgScreenshot = "https://api-project-academy-9cf71ea0cac6.herokuapp.com/images/\(imageNamePicture)"

        try await project.create(on: req.db)
        return project
    }
    
    func update(req: Request)async throws -> HTTPStatus {
        
        return .accepted
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        
        return .noContent
    }
}


