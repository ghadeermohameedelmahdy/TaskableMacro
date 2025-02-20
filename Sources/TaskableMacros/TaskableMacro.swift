import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct TaskableMacro: Macro, PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        // Ensure it's a function
        guard let function = declaration.as(FunctionDeclSyntax.self) else {
            throw MacroError.message("@Taskable can only be applied to functions")
        }

        // Extract function details
        let functionModifiers = function.modifiers.trimmedDescription  // e.g., "private"
        let functionName = function.name.trimmedDescription
        let parameters = function.signature.parameterClause.trimmedDescription
        let returnType = function.signature.returnClause?.trimmedDescription ?? ""
        
        // Get the original function body
        guard let functionBody = function.body else {
            throw MacroError.message("@Taskable function must have a body")
        }
        
        // Extract function statements while maintaining formatting
        let bodyStatements = functionBody.statements.map { $0.trimmedDescription }.joined(separator: "\n    ")
        
        // Ensure correct indentation for readability
        let transformedFunction = """
                \(functionModifiers) func \(functionName)\(parameters) \(returnType) {
                    Task {
                        await \(bodyStatements)
                    }
                }
                """
        return [DeclSyntax(stringLiteral: transformedFunction)]
    }
}

enum MacroError: Error, CustomStringConvertible {
    case message(String)

    var description: String {
        switch self {
        case .message(let text): return text
        }
    }
}

@main
struct TaskablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        TaskableMacro.self,
    ]
}
