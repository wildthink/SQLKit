//import NIO

/// Builds queries and executes them on a connection.
///
///     builder.run()
///
public protocol SQLQueryBuilder: AnyObject {
    /// Query being built.
    var query: SQLExpression { get }
    
    /// Connection to execute query on.
    var database: SQLDatabase { get }

//    func run() -> EventLoopFuture<Void>
    func run() -> Void
}

extension SQLQueryBuilder {
    /// Runs the query.
    ///
    ///     builder.run()
    ///
    /// - returns: A future signaling completion.
    public func run() -> Void {
        self.database.execute(sql: self.query) { _ in }
    }
}
