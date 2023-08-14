import Fluent

struct CreateTodo: AsyncMigration {
    func prepare(on database: Database) async throws {
        do {
            try await database.schema("todos")
                .id()
                .field("title", .string, .required)
                .create()
        } catch {
            throw MigrationError.creationFailed(reason: error.localizedDescription)
        }
    }

    func revert(on database: Database) async throws {
        do {
            try await database.schema("todos").delete()
        } catch {
            throw MigrationError.revertFailed(reason: error.localizedDescription)
        }
    }
}

enum MigrationError: Error {
    case creationFailed(reason: String)
    case revertFailed(reason: String)
}
