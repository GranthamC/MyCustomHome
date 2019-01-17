import Vapor
import FluentSQLite

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

extension MyCustomHome: SQLiteModel {}

extension MyCustomHome: Migration {}

extension MyCustomHome: Content
{
}

