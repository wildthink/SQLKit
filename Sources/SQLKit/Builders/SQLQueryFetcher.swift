//import NIO

/// A `SQLQueryBuilder` that supports decoding results.
///
///     builder.all(decoding: Planet.self)
///
public protocol SQLQueryFetcher: SQLQueryBuilder { }

extension SQLQueryFetcher {
    // MARK: First

    public func first<D>(decoding: D.Type) -> D?
        where D: Decodable
    {
        guard let row = first() else {
            return nil
        }
        return try? row.decode(model: D.self)
    }
    
    /// Collects the first raw output and returns it.
    ///
    ///     builder.first()
    ///
    public func first() -> SQLRow? {
        return self.all().first
    }
    
    // MARK: All


    public func all<D>(decoding: D.Type) -> [D]
        where D: Decodable
    {
        self.all(decoding: D.self).map {
                try $0.decode(model: D.self)
            }
        }
    }
    
    /// Collects all raw output into an array and returns it.
    ///
    ///     builder.all()
    ///
    public func all() -> [SQLRow] {
        var all: [SQLRow] = []
        self.run { row in
            all.append(row)
        }
        return all
    }
    
    // MARK: Run


    public func run<D>(decoding: D.Type, _ handler: @escaping (Result<D, Error>) -> ())
        where D: Decodable
    {
        self.run {
            do {
                try handler(.success($0.decode(model: D.self)))
            } catch {
                handler(.failure(error))
            }
        }
    }
    
    
    /// Runs the query, passing output to the supplied closure as it is recieved.
    ///
    ///     builder.run { print($0) }
    ///
    /// The returned future will signal completion of the query.
    public func run(_ handler: @escaping (SQLRow) -> ()) {
        self.database.execute(sql: self.query) { row in
            handler(row)
        }
    }
}
