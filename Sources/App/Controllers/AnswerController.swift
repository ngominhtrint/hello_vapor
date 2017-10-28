//
//  AnswerController.swift
//  Hello_VaporPackageDescription
//
//  Created by TriNgo on 10/28/17.
//

import Vapor
import HTTP

// Here we have a controller that helps facilitate
// RESTful interactions with our Categories table
final class AnswerController: ResourceRepresentable {
    
    // When users call 'GET' on '/posts'
    // it should return an index of all available posts
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Answer.all().makeJSON()
    }
    
    // When consumers call 'POST' on '/answers' with valid JSON
    // construct and save the answer
    func store(_ req: Request) throws -> ResponseRepresentable {
        let answer = try req.postAnswer()
        try answer.save()
        return answer
    }
    
    // When consumers calls 'GET' on a specific resource, ie:
    // /answers/12rt3 we should show that specific answer
    func show(_ req: Request, answer: Answer) throws -> ResponseRepresentable {
        return answer
    }
    
    // When the consumer calls 'DELETE' on a specific resource, ie:
    // '/answers/78hy1' we should remove that resource from the database
    func delete(_ req: Request, answer: Answer) throws -> ResponseRepresentable {
        try answer.delete()
        return Response(status: .ok)
    }
    
    // When the consumer calls 'DELETE' on the entire table, ie:
    // '/answers' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try Answer.makeQuery().delete()
        return Response(status: .ok)
    }
    
    // When the user calls 'PATCH' on a specific resource, we should
    // update that resource to the new values
    func update(_ req: Request, answer: Answer) throws -> ResponseRepresentable {
        // See extension Answer: Updateable
        try answer.update(for: req)
        
        // Save an return the updated answer
        try answer.save()
        return answer
    }
    
    // When a user calls 'PUT' on a specific resource, we should replaces any
    // values that do not exists in the request with null
    // This is equivalent to creating a new Answer with the same ID.
    func replace(_ req: Request, answer: Answer) throws -> ResponseRepresentable {
        // First attempt to create a new Answer from the supplied JSON.
        // If any required fields are missing, this request will be denied
        let new = try req.postAnswer()
        
        // Update the answer with all of the properties from the new Answer
        answer.content = new.content
        answer.imageUrl = new.imageUrl
        
        try answer.save()
        
        // Return the updated Answer
        return answer
    }
    
    // When making a controller, it is pretty flexible in that it
    // only expects closures, this is useful for advanced scenarios, but
    // most of the time, it should look almost identical to this implementation
    func makeResource() -> Resource<Answer> {
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
    // Create a answer from the JSON body
    // return BadRequest error if invalid
    // or no JSON
    func postAnswer() throws -> Answer {
        guard let json = json else { throw Abort.badRequest }
        return try Answer(json: json)
    }
}

// Since AnswerController doesn't require anything to
// be initialize we can conform it to EmptyInitializable
// This will allow it to be passed by type
extension AnswerController: EmptyInitializable { }
