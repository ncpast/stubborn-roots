#ifndef API_CLIENT_H
#define API_CLIENT_H

#include <godot_cpp/classes/http_request.hpp>
#include <godot_cpp/core/class_db.hpp>

namespace godot {

class APIClient : public HTTPRequest {
    GDCLASS(APIClient, HTTPRequest)

protected:
    static void _bind_methods();

public:
    APIClient();
    ~APIClient();
    int get_money();

    void connect_to_server();
    void _on_request_completed(int result, int response_code, PackedStringArray headers, PackedByteArray body);
};

}

#endif