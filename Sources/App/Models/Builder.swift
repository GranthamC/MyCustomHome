import Vapor
import FluentPostgreSQL

final class Builder: Codable
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

extension Builder: PostgreSQLModel {}

extension Builder: Migration {}

extension Builder: Content {}

extension Builder: Parameter {}

