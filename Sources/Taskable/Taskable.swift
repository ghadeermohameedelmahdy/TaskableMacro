// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(peer, names: overloaded)
public macro Taskable() = #externalMacro(module: "TaskableMacros", type: "TaskableMacro")

