import Fluent
import Vapor

final class Pessoa: Model, Content {
    static let schema = "pessoa"
    
    @ID(key: .id)
    var id: UUID?
    @Field(key: "name")
    var name: String
    @Field(key: "img_profile")
    var img_profile: String?
    


    init() { }

    init(id: UUID? = nil, name: String ) {
        self.id = id
        self.name = name
        self.img_profile = img_profile
    
    }
}
