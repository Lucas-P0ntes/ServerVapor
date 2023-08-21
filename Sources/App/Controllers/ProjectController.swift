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
        
        try await ProjectModel.query(on: req.db).all()
        
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

        
        try await req.fileio.writeFile(.init(data: data.picture), at: pathPicture)
        try await req.fileio.writeFile(.init(data: data.imgIcon), at: pathIcon )
        
       
        let project = try req.content.decode(ProjectModel.self)
        project.id = id
        project.imgIcon = "https://api-project-academy-9cf71ea0cac6.herokuapp.com/images/\(pathIcon)"
        project.imgScreenshot = "https://api-project-academy-9cf71ea0cac6.herokuapp.com/images/\(pathPicture)"

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


