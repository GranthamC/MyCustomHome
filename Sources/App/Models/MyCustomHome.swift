import Vapor
import FluentPostgreSQL

final class MyCustomHome: Codable
{
    var id: Int?
    var short: String
    var long: String
    
    init(short: String, long: String)
    {
        self.short = short
        self.long = long
    }
}

extension MyCustomHome: PostgreSQLModel {}

extension MyCustomHome: Migration {}

extension MyCustomHome: Content
{
}

extension MyCustomHome: Parameter {}
