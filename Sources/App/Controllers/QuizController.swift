//
//  QuizController.swift
//  Hello_VaporPackageDescription
//
//  Created by TriNgo on 10/27/17.
//

import Vapor
import HTTP

// Here we have a controller that helps facilitate
// RESTful interactions with our Quiz table
final class QuizController: ResourceRepresentable {
 
    // When users call 'GET' on '/quizzes'
    // it should return an index of all available quizzes
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Quiz.all().makeJSON()
    }
    
    // When consumers call 'POST' on '/quizzes' with valid JSON
    // construct and save the quiz
    func store(_ req: Request) throws -> ResponseRepresentable {
        let quiz = try req.postQuiz()
        try quiz.save()
        return quiz
    }
    
    // When the consumer calls 'GET' on a specific resource, ie:
    // '/quizzes/13rd88' we should show that specific quiz
    func show(_ req: Request, quiz: Quiz) throws -> ResponseRepresentable {
        return quiz
    }
    
    // When the consumer calls 'DELETE' on a specific resource, ie:
    // '/quizzes/12jd9' we should remove that resource from the database
    func delete(_ req: Request, quiz: Quiz) throws -> ResponseRepresentable {
        try quiz.delete()
        return Response(status: .ok)
    }
    
    // When the consumer calls 'DELETE' on the entire table, ie:
    // 'quizzes' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try Quiz.makeQuery().delete()
        return Response(status: .ok)
    }
    
    // When the user calls 'PATCH' on a specific resource, we should
    // update that resource to the new value
    func update(_ req: Request, quiz: Quiz) throws -> ResponseRepresentable {
        // See `extension Quiz: Updateable`
        try quiz.update(for: req)
        
        // Save an return the updated post
        try quiz.save()
        return quiz
    }
    
    // When a user calls 'PUT' on a specific resource, we should replace any
    // values that do not exists in the request with null.
    // This is equivalent to creating a new Quiz with the same ID
    func replace(_ req: Request, quiz: Quiz) throws -> ResponseRepresentable {
        // First attempt to create a new Quiz from the supplied JSON
        // If any required fields are missing, this request will be denied
        let new = try req.postQuiz()
        
        // Update the post with all of the properties from the new quiz
        quiz.content = new.content
        quiz.type = new.type
        quiz.rightAnswerId = new.rightAnswerId
        quiz.rightAnswerString = new.rightAnswerString
        quiz.mediaUrl = new.mediaUrl
        quiz.mediaType = new.mediaType
        quiz.level = new.level
        quiz.category = new.category
        quiz.points = new.points
        try quiz.save()
        
        // Return the updated quiz
        return quiz
    }
    
    func makeResource() -> Resource<Quiz> {
        return Resource(
            index: index,
            store: store,
            show: show,
            update: update,
            replace: replace,
            destroy: delete,
            clear: clear
        )
    }
}

extension Request {
    // Create a quiz from the JSON body
    // Return BadRequest error id invalid or no JSON
    func postQuiz() throws -> Quiz {
        guard let json = json else { throw Abort.badRequest }
        return try Quiz(json: json)
    }
}

// Since QuizController doesn't require anything to
// be initialize we can conform it to EmptyInitializable
// This will allow it to be passed by type
extension QuizController: EmptyInitializable { }
