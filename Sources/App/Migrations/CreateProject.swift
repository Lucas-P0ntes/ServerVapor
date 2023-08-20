import Fluent

struct CreateProject: AsyncMigration {
    func prepare(on database: Database) async throws {
        do {
            try await  database.schema("projectModel")
           
                        .id()
                        .field("name", .string, .required)
                        .field("big_idea", .string, .required)
                        .field("essential_question", .string, .required)
                        .field("challenge", .string, .required)
                        .field("description", .string, .required)
                        .field("turma", .string, .required)
                        .field("link", .string, .required)
                        .field("ativo", .string, .required)
                        .field("img_screenshot", .string, .required)
                        .field("img_icon", .string, .required)
                     
                .create()
        } catch {
            throw MigrationError.creationFailed(reason: error.localizedDescription)
        }
    }

    func revert(on database: Database) async throws {
        do {
            try await database.schema("projectModel").delete()
        } catch {
            throw MigrationError.revertFailed(reason: error.localizedDescription)
        }
    }
}


