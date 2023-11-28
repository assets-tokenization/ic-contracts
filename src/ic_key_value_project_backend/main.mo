import Iter "mo:base/Iter";
import Principal "mo:base/Principal";
import Array "mo:base/Array";
import Option "mo:base/Option";
import DataStore "./store";
import Blob "mo:base/Blob";
import Utils "./utils";

actor StoreREInfo {

    type UserId = Principal;

    type UserProfile = {
        firstName: Text;
        lastName: Text;
        status: Bool;
        ipn: Text;
        wallet: Text;
        description: Text;
    };

    type Asset = {
        name: Text;
        id: Text;
        status: Bool;
        addr: Text;
    };

    type P2P_Platforms_whitelist = {
        addr: Text;
        status: Bool;
    };


    private let storeAsset: DataStore.DataStore<Asset> = DataStore.DataStore<Asset>();
    private let storeUserProfile: DataStore.DataStore<UserProfile> = DataStore.DataStore<UserProfile>();
    private let storeP2P_Platforms: DataStore.DataStore<P2P_Platforms_whitelist> = DataStore.DataStore<P2P_Platforms_whitelist>();

    private stable var asset_entries : [(Text, Asset)] = [];
    private stable var user_profile_entries : [(Text, UserProfile)] = [];
    private stable var p2p_platforms_entries : [(Text, P2P_Platforms_whitelist)] = [];

    //get self user ID
    public shared query(msg) func getOwnId(): async UserId { msg.caller };
    

    //CRUD Asset

    public shared query(msg) func asset_get(key: Text) : async (?Asset) {
        if(not Utils.isAdmin(msg.caller)) return null;
        let entry: ?Asset = storeAsset.get(key);
        return entry;
    };

    public shared(msg) func asset_set(key: Text, data: Asset) : async () {
        if(not Utils.isAdmin(msg.caller)) return;
        storeAsset.put(key, data);
    };

    public shared(msg) func asset_del(key: Text) : async () {
        if(not Utils.isAdmin(msg.caller)) return;
        let entry: ?Asset = storeAsset.del(key);
    };

    public shared query(msg) func asset_list(filter: ?DataStore.Filter) : async [(Text, Asset)] {
        if(not Utils.isAdmin(msg.caller)) return [];
        let results: [(Text, Asset)] = storeAsset.list_items(filter);
        return results;
    };

    
    //CRUD UserProfile

    public shared query(msg) func user_profile_get(key: Text) : async (?UserProfile) {
        if(not Utils.isAdmin(msg.caller)) return null;
        let entry: ?UserProfile = storeUserProfile.get(key);
        return entry;
    };

    public shared(msg) func user_profile_set(key: Text, data: UserProfile) : async () {
        if(not Utils.isAdmin(msg.caller)) return;
        storeUserProfile.put(key, data);
    };

    public shared(msg) func user_profile_block(key: Text, data: Bool) : async () {
        if(not Utils.isAdmin(msg.caller)) return;

        let entry: ?UserProfile = storeUserProfile.get(key);

        switch(entry){
            case null return;
            case (?entry) {
                let newEntry: UserProfile = {
                    firstName =  entry.firstName;
                    lastName = entry.lastName;
                    ipn = entry.ipn;
                    status = data;
                    description = entry.description;
                    wallet = entry.wallet;
                };

                storeUserProfile.put(key, newEntry);
            }
        }        
    };


    public shared(msg) func user_profile_del(key: Text) : async () {
        if(not Utils.isAdmin(msg.caller)) return;
        let entry: ?UserProfile = storeUserProfile.del(key);
    };

    public shared query(msg) func user_profile_list(filter: ?DataStore.Filter) : async [(Text, UserProfile)] {
        if(not Utils.isAdmin(msg.caller)) return [];
        let results: [(Text, UserProfile)] = storeUserProfile.list_items(filter);
        return results;
    };


    //CRUD P2P_Platforms

    public shared query(msg) func p2p_platforms_get(key: Text) : async (?P2P_Platforms_whitelist) {
        if(not Utils.isAdmin(msg.caller)) return null;
        let entry: ?P2P_Platforms_whitelist = storeP2P_Platforms.get(key);
        return entry;
    };

    public shared(msg) func p2p_platforms_set(key: Text, data: P2P_Platforms_whitelist) : async () {
        if(not Utils.isAdmin(msg.caller)) return;
        storeP2P_Platforms.put(key, data);
    };

    public shared(msg) func p2p_platforms_del(key: Text) : async () {
        if(not Utils.isAdmin(msg.caller)) return;
        let entry: ?P2P_Platforms_whitelist = storeP2P_Platforms.del(key);
    };

    public shared query(msg) func p2p_platforms_list(filter: ?DataStore.Filter) : async [(Text, P2P_Platforms_whitelist)] {
        if(not Utils.isAdmin(msg.caller)) return [];
        let results: [(Text, P2P_Platforms_whitelist)] = storeP2P_Platforms.list_items(filter);
        return results;
    };

    system func preupgrade() {
        asset_entries := Iter.toArray(storeAsset.preupgrade().entries());
        user_profile_entries := Iter.toArray(storeUserProfile.preupgrade().entries());
        p2p_platforms_entries := Iter.toArray(storeP2P_Platforms.preupgrade().entries());
    };

    system func postupgrade() {
        storeAsset.postupgrade(asset_entries);
        storeUserProfile.postupgrade(user_profile_entries);
        storeP2P_Platforms.postupgrade(p2p_platforms_entries);
        asset_entries := [];
        user_profile_entries := [];
        p2p_platforms_entries := [];
    };
};
