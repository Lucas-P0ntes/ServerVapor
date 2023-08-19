import Fluent

struct CreatePessoa: AsyncMigration {
    func prepare(on database: Database) async throws {
        do {
            try await database.schema("pessoa")
                .id()
                .field("name", .string, .required)
                .field("img_profile", .string)

                .create()
        } catch {
            throw MigrationError.creationFailed(reason: error.localizedDescription)
        }
    }

    func revert(on database: Database) async throws {
        do {
            try await database.schema("pessoa").delete()
        } catch {
            throw MigrationError.revertFailed(reason: error.localizedDescription)
        }
    }
}

enum MigrationError: Error {
    case creationFailed(reason: String)
    case revertFailed(reason: String)
}
