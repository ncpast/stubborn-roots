#include "api_client.h"
#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/classes/file_access.hpp>
#include <godot_cpp/classes/json.hpp>
#include <godot_cpp/variant/dictionary.hpp>

using namespace godot;

void APIClient::_bind_methods() {
    ClassDB::bind_method(D_METHOD("connect_to_server"), &APIClient::connect_to_server);
    ClassDB::bind_method(D_METHOD("get_money"), &APIClient::get_money);
}

APIClient::APIClient() {}
APIClient::~APIClient() {}

void APIClient::connect_to_server() {
    String path = "res://player_data.json";

    if (FileAccess::file_exists(path)) {
        Ref<FileAccess> file = FileAccess::open(path, FileAccess::READ);
        String content = file->get_as_text();

        Variant data = JSON::parse_string(content);
        
        if (data.get_type() == Variant::DICTIONARY) {
            Dictionary dict = data;
            if (dict.has("money")) {
                int money = dict["money"];

                UtilityFunctions::print("--- Farm Data Loaded via C++ ---");
                UtilityFunctions::print("Current Wallet Balance: ", money);
                UtilityFunctions::print("-------------------------------");
            }
        } else {
            UtilityFunctions::print("ERROR: JSON format is invalid!");
        }
    } else {
        UtilityFunctions::print("ERROR: player_data.json not found!");
    }   
}
int APIClient::get_money() {
    String path = "res://player_data.json";
    if (FileAccess::file_exists(path)) {
        Ref<FileAccess> file = FileAccess::open(path, FileAccess::READ);
        Variant data = JSON::parse_string(file->get_as_text());
        Dictionary dict = data;
        return dict["money"];
    }
    return 0;
}
