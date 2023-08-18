//
//  File.swift
//  
//
//  Created by Lucas Pontes on 18/08/23.
//

import Foundation
import Fluent
import Vapor

final class CollectModel: Model, Content {
    init() { }
    
    static let schema = "collect"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "data")
    var data: Data
    
    init(id: UUID? = nil, data: Data) {
        self.id = id
        self.data = data
    }
}
