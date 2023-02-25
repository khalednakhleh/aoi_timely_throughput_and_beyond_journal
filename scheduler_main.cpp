


#include "scheduler_main.hpp"


int main(int argc, char* argv[]) {

InputParams params = parse_input_params(argc, argv);
std::list<Client> my_clients;


// setting the clients with their respective values
for (int i = 0; i < params.num_clients; i++) {
    Client client(i+1);
    std::string filename = "client_" + std::to_string(i+1) + "_values.txt";
    read_values_from_file(client, filename, params);
    my_clients.push_back(client);
}





//print_clients_values(my_clients);

} // int main 