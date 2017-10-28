//
//  Quiz.swift
//  Hello_VaporPackageDescription
//
//  Created by TriNgo on 10/27/17.
//

import Vapor
import FluentProvider
import HTTP

final class Quiz: Model {
    let storage = Storage()
    
    // MARK: Properties and database type
    var content: String
    var type: String
    var rightAnswerId: Int
    var rightAnswerString: String
    var mediaUrl: String
    var mediaType: String
    var level: Int
    var categoryId: Identifier
    var points: Double
    
    // The column names for properties in the Quiz table
    struct Keys {
        static let id = "id"
        static let content = "content"
        static let type = "type"
        static let rightAnswerId = "rightAnswerId"
        static let rightAnswerString = "rightAnswerString"
        static let mediaUrl = "mediaUrl"
        static let mediaType = "mediaType"
        static let level = "level"
        static let categoryId = "category_id"
        static let category = "category"
        static let answers = "answers"
        static let points = "points"
    }
    
    // Creates a new Quiz
    init(content: String, type: String, rightAnswerId: Int, rightAnswerString: String, mediaUrl: String, mediaType: String, level: Int, categoryId: Identifier, points: Double) {
        self.content = content
        self.type = type
        self.rightAnswerId = rightAnswerId
        self.rightAnswerString = rightAnswerString
        self.mediaUrl = mediaUrl
        self.mediaType = mediaType
        self.level = level
        self.categoryId = categoryId
        self.points = points
    }
    
    // MARK: Fluent Serialization
    
    // Initializes the Quiz from the database row
    init(row: Row) throws {
        content = try row.get(Quiz.Keys.content)
        type = try row.get(Quiz.Keys.type)
        rightAnswerId = try row.get(Quiz.Keys.rightAnswerId)
        rightAnswerString = try row.get(Quiz.Keys.rightAnswerString)
        mediaUrl = try row.get(Quiz.Keys.mediaUrl)
        mediaType = try row.get(Quiz.Keys.mediaType)
        level = try row.get(Quiz.Keys.level)
        categoryId = try row.get(Quiz.Keys.categoryId)
        points = try row.get(Quiz.Keys.points)
    }
    
    // Serializes the Quiz to the database
    func makeRow() throws -> Row {
        var row = Row()
        try row.set(Quiz.Keys.content, content)
        try row.set(Quiz.Keys.type, type)
        try row.set(Quiz.Keys.rightAnswerId, rightAnswerId)
        try row.set(Quiz.Keys.rightAnswerString, rightAnswerString)
        try row.set(Quiz.Keys.mediaUrl, mediaUrl)
        try row.set(Quiz.Keys.mediaType, mediaType)
        try row.set(Quiz.Keys.level, level)
        try row.set(Quiz.Keys.categoryId, categoryId)
        try row.set(Quiz.Keys.points, points)
        return row
    }
}

// MARK: Fluent Preparation

extension Quiz: Preparation {
    // Prepares a table/collection in the database for storing Quizzes
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string(Quiz.Keys.content)
            builder.string(Quiz.Keys.type, length: nil, optional: true, unique: false, default: nil)
            builder.int(Quiz.Keys.rightAnswerId, optional: true, unique: false, default: 0)
            builder.string(Quiz.Keys.rightAnswerString, length: nil, optional: true, unique: false, default: nil)
            builder.string(Quiz.Keys.mediaUrl, length: nil, optional: true, unique: false, default: nil)
            builder.string(Quiz.Keys.mediaType, length: nil, optional: true, unique: false, default: nil)
            builder.int(Quiz.Keys.level, optional: true, unique: false, default: 0)
            builder.foreignId(for: Category.self)
            builder.double(Quiz.Keys.points, optional: true, unique: false, default: nil)
            
            // Able to generate fake data here
        }
    }
    
    // Undoes what was done in `prepare`
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

// MARK: JSON

// How the model converts from / to JSON.
// For example when:
//      - Creating a new Quiz (POST /quizzes)
//      - Fetching a quiz (GET /quizzes, GET /quizzes/:id)
// If it is an optional field, set the default value, for example:
// type: try json.get(Quiz.Keys.type) ?? ""

extension Quiz: JSONConvertible {
    convenience init(json: JSON) throws {
        self.init(
            content: try json.get(Quiz.Keys.content),
            type: try json.get(Quiz.Keys.type) ?? "",
            rightAnswerId: try json.get(Quiz.Keys.rightAnswerId) ?? 0,
            rightAnswerString: try json.get(Quiz.Keys.rightAnswerString) ?? "",
            mediaUrl: try json.get(Quiz.Keys.mediaUrl) ?? "",
            mediaType: try json.get(Quiz.Keys.mediaType) ?? "",
            level: try json.get(Quiz.Keys.level) ?? 0,
            categoryId: try json.get(Quiz.Keys.categoryId) ?? 0,
            points: try json.get(Quiz.Keys.points) ?? 0.0
        )
    }
    
    func makeJSON() throws -> JSON {
        var json = JSON()
        try json.set(Quiz.Keys.id, id)
        try json.set(Quiz.Keys.content, content)
        try json.set(Quiz.Keys.type, type)
        try json.set(Quiz.Keys.rightAnswerId, rightAnswerId)
        try json.set(Quiz.Keys.rightAnswerString, rightAnswerString)
        try json.set(Quiz.Keys.mediaUrl, mediaUrl)
        try json.set(Quiz.Keys.mediaType, mediaType)
        try json.set(Quiz.Keys.level, level)
        try json.set(Quiz.Keys.category, category.first())
        try json.set(Quiz.Keys.answers, answers.all())
        try json.set(Quiz.Keys.points, points)
        return json
    }
}

// MARK: HTTP

// This allows Quiz models to be returned directly in route closures
extension Quiz: ResponseRepresentable { }

// MARK: Update

// This allows the Quiz model to be updated dynamically by the request
extension Quiz: Updateable {
    // Updateable keys are called when `quiz.update(for: req)` is called
    // Add as many updateable keys as you like here
    public static var updateableKeys: [UpdateableKey<Quiz>] {
        return [
            // If the request contains a String at key "content" the setter callback will be called
            UpdateableKey(Quiz.Keys.content, String.self) { quiz, content in quiz.content = content },
            UpdateableKey(Quiz.Keys.type, String.self) { quiz, type in quiz.type = type },
            UpdateableKey(Quiz.Keys.rightAnswerId, Int.self) { quiz, rightAnswerId in quiz.rightAnswerId = rightAnswerId },
            UpdateableKey(Quiz.Keys.rightAnswerString, String.self) { quiz, rightAnswerString in quiz.rightAnswerString = rightAnswerString },
            UpdateableKey(Quiz.Keys.mediaUrl, String.self) { quiz, mediaUrl in quiz.mediaUrl = mediaUrl },
            UpdateableKey(Quiz.Keys.mediaType, String.self) { quiz, mediaType in quiz.mediaType = mediaType },
            UpdateableKey(Quiz.Keys.level, Int.self) { quiz, level in quiz.level = level },
            UpdateableKey(Quiz.Keys.categoryId, Identifier.self) { quiz, categoryId in quiz.categoryId = categoryId },
            UpdateableKey(Quiz.Keys.points, Double.self) { quiz, points in quiz.points = points }
        ]
    }
}

extension Quiz {
    var category: Parent<Quiz, Category> {
        return parent(id: categoryId)
    }
    
    var answers: Children<Quiz, Answer> {
        return children()
    }
}










