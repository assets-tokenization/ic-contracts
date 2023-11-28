import Array "mo:base/Array";
import Option "mo:base/Option";

module {

    public type UserId = Principal;

    let adminIds: [UserId] = [];

    public func isAdmin(userId: UserId): Bool {
        func identity(x: UserId): Bool { x == userId };
        Option.isSome(Array.find<UserId>(adminIds,identity))
    };
}