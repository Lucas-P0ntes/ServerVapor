import Fluent
import Vapor

final class ProjectModel: Model, Content {
    init() {
        
    }
    
    static let schema = "projects"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "big_idea")
    var bigIdea: String
    
    @Field(key: "essential_question")
    var essentialQuestion: String
    
    @Field(key: "challenge")
    var challenge: String
    
    @Field(key: "description")
    var description: String
    
    @Field(key: "turma")
    var turma: String
    
    @Field(key: "link")
    var link: String
    
    @Field(key: "ativo")
    var ativo: String
    
    @Field(key: "img_screenshot")
    var imgScreenshot: String
    
    @Field(key: "img_icon")
    var imgIcon: String
    
    
    init(id: UUID? = nil, name: String, bigIdea: String, essentialQuestion: String, challenge: String, description: String, turma: String, link: String, ativo: String, imgScreenshot: String, imgIcon: String) {
        self.id = id
        self.name = name
        self.bigIdea = bigIdea
        self.essentialQuestion = essentialQuestion
        self.challenge = challenge
        self.description = description
        self.turma = turma
        self.link = link
        self.ativo = ativo
        self.imgScreenshot = imgScreenshot
        self.imgIcon = imgIcon
    }
}
