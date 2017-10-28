//
//  Category.swift
//  Hello_VaporPackageDescription
//
//  Created by TriNgo on 10/27/17.
//

import Vapor
import FluentProvider
import HTTP

final class Category: Model {
    let storage = Storage()
    
    // MARK: Properties and database type
    var name: String
    var imageUrl: String
    var describe: String
    
    // The column names for properties in the Category table
    struct Keys {
        static let id = "id"
        static let name = "name"
        static let imageUrl = "imageUrl"
        static let describe = "describe"
    }
    
    // Creates a new Category
    init(name: String, imageUrl: String, describe: String) {
        self.name = name
        self.imageUrl = imageUrl
        self.describe = describe
    }
    
    // MARK: Fluent Serialization
    
    // Initializes the Category from the database row
    init(row: Row) throws {
        name = try row.get(Category.Keys.name)
        imageUrl = try row.get(Category.Keys.imageUrl)
        describe = try row.get(Category.Keys.describe)
    }
    
    // Serializes the Category to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Category.Keys.name, name)
        try row.set(Category.Keys.imageUrl, imageUrl)
        try row.set(Category.Keys.describe, describe)
        return row
    }
}

// MARK: Fluent Preparation

extension Category: Preparation {
    // Prepares a table/collection in the database for storing Categoryies
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Category.Keys.name)
            builder.string(Category.Keys.imageUrl, length: nil, optional: true, unique: false, default: nil)
            builder.string(Category.Keys.describe, length: nil, optional: true, unique: false, default: nil)
            
            // Able to generate fake data here
        }
    }
    
    // Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON
// How the model converts from / to JSON
// For example when:
//      - Creating a new Category (POST /categories)
//      - Fetching a category (GET /categories, GET /categories/:id)
// If it is an optional field, set the default value, for example:
// try json.get(Category.Keys.imageUrl) ?? ""

extension Category: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            name: try json.get(Category.Keys.name),
            imageUrl: try json.get(Category.Keys.imageUrl) ?? "",
            describe: try json.get(Category.Keys.describe) ?? ""
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Category.Keys.id, id)
        try json.set(Category.Keys.name, name)
        try json.set(Category.Keys.imageUrl, imageUrl)
        try json.set(Category.Keys.describe, describe)
        return json
    }
}

// MARK: HTTP

// This allows Category models to be returned directly in route closures
extension Category: ResponseRepresentable { }

// MARK: Update

// This allows the Category model to be updated dynamically by the request
extension Category: Updateable {
    // Updateable keys are called when `category.update(for: req)` is called
    // Add as many updateable keys as you like here
    static var updateableKeys: [UpdateableKey<Category>] {
        return [
            // If the request contains a String at key "content" the setter callback will be called
            UpdateableKey(Category.Keys.name, String.self) { category, name in category.name = name },
            UpdateableKey(Category.Keys.imageUrl, String.self) { category, imageUrl in category.imageUrl = imageUrl },
            UpdateableKey(Category.Keys.describe, String.self) { category, describe in category.describe = describe }
        ]
    }
}

extension Category {
    var quizzes: Children<Category, Quiz> {
        return children()
    }
}
