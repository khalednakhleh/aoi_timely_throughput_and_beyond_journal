


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


//BaseScheduler scheduler(my_clients, params);

    std::unique_ptr<BaseScheduler> scheduler_ptr;
    if (params.policy == 6) {
        scheduler_ptr = std::unique_ptr<BaseScheduler>(new VWD(my_clients, params));
    } else if (params.policy == 1) {
        scheduler_ptr = std::unique_ptr<BaseScheduler>(new WLD(my_clients, params));
    } else if (params.policy == 3) {
        scheduler_ptr = std::unique_ptr<BaseScheduler>(new EDF(my_clients, params));
    } else if (params.policy == 4) {
        scheduler_ptr = std::unique_ptr<BaseScheduler>(new DBLDF(my_clients, params));
    } else {
        std::cout << "Invalid policy\n";
        return 1;
    }

//print_clients_values(my_clients);

    return 0;

} // int main 