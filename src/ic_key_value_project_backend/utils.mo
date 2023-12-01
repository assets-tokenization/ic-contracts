import Array "mo:base/Array";
import Option "mo:base/Option";
import Principal "mo:base/Principal";

module {

    public type UserId = Principal;

    public func checkAdmin(userId: UserId, _admin: Text): Bool {
        return getTextRepresUser(userId) == _admin;
    };

    public func getTextRepresUser(userId: UserId): Text {

        return Principal.toText(userId);

    }
}