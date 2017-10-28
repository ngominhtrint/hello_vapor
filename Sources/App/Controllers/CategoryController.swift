//
//  CategoryController.swift
//  Hello_VaporPackageDescription
//
//  Created by TriNgo on 10/27/17.
//
import Vapor
import HTTP

// Here we have a controller that helps facilitate
// RESTful interactions with our Categories table
final class CategoryController: ResourceRepresentable {
    
    // When users call 'GET' on '/posts'
    // it should return an index of all available posts
    func index(_ req: Request) throws -> ResponseRepresentable {
        return try Category.all().makeJSON()
    }
    
    // When consumers call 'POST' on '/categories' with valid JSON
    // construct and save the category
    func store(_ req: Request) throws -> ResponseRepresentable {
        let category = try req.postCategory()
        try category.save()
        return category
    }
    
    // When consumers calls 'GET' on a specific resource, ie:
    // /categories/12rt3 we should show that specific category
    func show(_ req: Request, category: Category) throws -> ResponseRepresentable {
        return category
    }
    
    // When the consumer calls 'DELETE' on a specific resource, ie:
    // '/categories/78hy1' we should remove that resource from the database
    func delete(_ req: Request, category: Category) throws -> ResponseRepresentable {
        try category.delete()
        return Response(status: .ok)
    }
    
    // When the consumer calls 'DELETE' on the entire table, ie:
    // '/categories' we should remove the entire table
    func clear(_ req: Request) throws -> ResponseRepresentable {
        try Category.makeQuery().delete()
        return Response(status: .ok)
    }
    
    // When the user calls 'PATCH' on a specific resource, we should
    // update that resource to the new values
    func update(_ req: Request, category: Category) throws -> ResponseRepresentable {
        // See extension Category: Updateable
        try category.update(for: req)
        
        // Save an return the updated category
        try category.save()
        return category
    }
    
    // When a user calls 'PUT' on a specific resource, we should replaces any
    // values that do not exists in the request with null
    // This is equivalent to creating a new Category with the same ID.
    func replace(_ req: Request, category: Category) throws -> ResponseRepresentable {
        // First attempt to create a new Category from the supplied JSON.
        // If any required fields are missing, this request will be denied
        let new = try req.postCategory()
        
        // Update the category with all of the properties from the new Category
        category.name = new.name
        category.imageUrl = new.imageUrl
        category.describe = new.describe
        
        try category.save()
        
        // Return the updated Category
        return category
    }
    
    // When making a controller, it is pretty flexible in that it
    // only expects closures, this is useful for advanced scenarios, but
    // most of the time, it should look almost identical to this implementation
    func makeResource() -> Resource<Category> {
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
    // Create a category from the JSON body
    // return BadRequest error if invalid
    // or no JSON
    func postCategory() throws -> Category {
        guard let json = json else { throw Abort.badRequest }
        return try Category(json: json)
    }
}

// Since CategoryController doesn't require anything to
// be initialize we can conform it to EmptyInitializable
// This will allow it to be passed by type
extension CategoryController: EmptyInitializable { }
