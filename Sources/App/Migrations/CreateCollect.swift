//
//  File.swift
//  
//
//  Created by Lucas Pontes on 18/08/23.
//

import Foundation
import Fluent

struct CreateCollect: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(CollectModel.schema)
            .id()
            .field("data", .data, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(CollectModel.schema).delete()
    }
}
