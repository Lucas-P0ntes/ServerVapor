import Fluent
import Vapor
//
//enum Position: String, Codable {
//    case senior = "SeniorLearner"
//    case junior = "JuniorLearner"
//}

final class PessoaModel: Model, Content {
    static let schema = "persons"
    
    @ID(key: .id)
    var id: UUID?
    @Field(key: "name")
    var name: String
    @Field(key: "position")
    var position: String
    @Field(key: "img_profile")
    var img_profile: String?
    


    init() { }

    init(id: UUID? = nil, name: String, position:String , img_profile: String? = nil) {
        self.id = id
        self.name = name
        self.position = position
        self.img_profile = img_profile
    
    }
}


