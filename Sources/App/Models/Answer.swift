//
//  Answer.swift
//  Hello_VaporPackageDescription
//
//  Created by TriNgo on 10/28/17.
//

import Vapor
import FluentProvider
import HTTP

final class Answer: Model {
    let storage = Storage()
    
    // MARK: Properties and database type
    var content: String
    var imageUrl: String
    var quizId: Identifier
    
    // The column names for properties in the Answer table
    struct Keys {
        static let id = "id"
        static let content = "content"
        static let imageUrl = "imageUrl"
        static let quizId = "quiz_id"
    }
    
    // Create a new Answer
    init(content: String, imageUrl: String, quizId: Identifier) {
        self.content = content
        self.imageUrl = imageUrl
        self.quizId = quizId
    }
    
    // MARK: Fluent Serialization

    // Initializes the Answer from the database row
    init(row: Row) throws {
        content = try row.get(Answer.Keys.content)
        imageUrl = try row.get(Answer.Keys.imageUrl)
        quizId = try row.get(Answer.Keys.quizId)
    }
    
    // Serializes the Answer to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Answer.Keys.content, content)
        try row.set(Answer.Keys.imageUrl, imageUrl)
        try row.set(Answer.Keys.quizId, quizId)
        return row
    }
}

// MARK: Fluent Preparation

extension Answer: Preparation {
    // Prepares a table/collection in the database for storing Answers
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Answer.Keys.content)
            builder.string(Answer.Keys.imageUrl, length: nil, optional: true, unique: false, default: nil)
            builder.foreignId(for: Quiz.self)
            
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
//      - Creating a new Answer (POST /categories)
//      - Fetching a category (GET /categories, GET /categories/:id)
// If it is an optional field, set the default value, for example:
// try json.get(Answer.Keys.imageUrl) ?? ""

extension Answer: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            content: try json.get(Answer.Keys.content),
            imageUrl: try json.get(Answer.Keys.imageUrl) ?? "",
            quizId: try json.get(Answer.Keys.quizId) ?? 0
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Answer.Keys.id, id)
        try json.set(Answer.Keys.content, content)
        try json.set(Answer.Keys.imageUrl, imageUrl)
        try json.set(Answer.Keys.quizId, quizId)
        return json
    }
}

// MARK: HTTP

// This allows Answer models to be returned directly in route closures
extension Answer: ResponseRepresentable { }

// MARK: Update

// This allows the Answer model to be updated dynamically by the request
extension Answer: Updateable {
    // Updateable keys are called when `answer.update(for: req)`
    // Add as many updateable keys as you like here
    static var updateableKeys: [UpdateableKey<Answer>] {
        return [
            // If request contains a String at key "content" the setter callback will be call
            UpdateableKey(Answer.Keys.content, String.self) { answer, content in answer.content = content },
            UpdateableKey(Answer.Keys.imageUrl, String.self) { answer, imageUrl in answer.imageUrl = imageUrl },
            UpdateableKey(Answer.Keys.quizId, Identifier.self) { answer, quizId in answer.quizId = quizId }
        ]
    }
}















