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
        let project = try req.content.decode(ProjectModel.self)
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


