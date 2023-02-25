


#include "scheduler_main.hpp"



void print_clients_values(std::list<Client>& my_clients){

for (auto it = my_clients.begin(); it != my_clients.end(); ++it){

	std::cout << "-------------------------------------------" << std::endl;
	std::cout << "Client index: " << it->idx << std::endl;
	std::cout << "delay: " << it->delay << std::endl;
	std::cout << "period: " << it->period << std::endl;
	std::cout << "p value: " << it->p << std::endl;
	std::cout << "q value: " << it->q << std::endl;
	std::cout << "mean value: " << it->mean << std::endl;
	std::cout << "variance value: " << it->variance << std::endl;
	std::cout << "weight value: " << it->weight << std::endl;
}

}; // void print_clients_values


InputParams parse_input_params(int argc, char **argv) {
    InputParams params;

    int opt;
    bool n_set = false, r_set = false, p_set = false, t_set = false;
    while ((opt = getopt(argc, argv, "n:r:p:t:")) != -1) {
        switch (opt) {
            case 'n':
                params.num_clients = atoi(optarg);
                if (params.num_clients != 5 && params.num_clients != 10 && params.num_clients != 20) {
                    std::cerr << "Error: number of clients must be 5, 10, or 20." << std::endl;
                    exit(1);
                }
                n_set = true;
                break;
            case 'r':
                params.regime_selection = atoi(optarg);
                if (params.regime_selection != 1 && params.regime_selection != 2 && params.regime_selection != 3) {
                    std::cerr << "Error: regime selection must be 1 (half aoi clients), 2 (heavy-traffic regime), or 3 (heavy-traffic regime with added delay)." << std::endl;
                    exit(1);
                }
                r_set = true;
                break;
            case 'p':
                params.policy = atoi(optarg);
                if (params.policy != 1 && params.policy != 3 && params.policy != 4 && params.policy != 6) {
                    std::cerr << "Error: policy must be 1 (WLD), 3 (EDF), 4 (DBLDF), or 6 (VWD)." << std::endl;
                    exit(1);
                }
                p_set = true;
                break;
            case 't':
                params.timesteps = atoi(optarg);
                if (params.timesteps <= 0) {
                    std::cerr << "Error: timesteps must be a positive integer." << std::endl;
                    exit(1);
                }
                t_set = true;
                break;
            default:
                std::cerr << "Usage: " << argv[0] << " -n num_clients -r regime_selection -p policy -t timesteps" << std::endl;
                exit(1);
        }
    }

    // Check that all input parameters have been set
    if (!n_set || !r_set || !p_set || !t_set) {
        std::cerr << "Error: Missing input parameter." << std::endl;
        std::cerr << "Usage: " << argv[0] << " -n num_clients -r regime_selection -p policy -t timesteps" << std::endl;
        exit(1);
    }

    std::cout << "number of clients = " << params.num_clients << std::endl;
    std::cout << "regime selection = " << params.regime_selection << std::endl;
    std::cout << "policy = " << params.policy << std::endl;
    std::cout << "timesteps = " << params.timesteps << std::endl;

    return params;
}


void read_values_from_file(Client& client, const std::string& fileName, InputParams params) {

    
    std::string filepath = std::string("results/")+std::string("policy_")+std::to_string(params.policy)+\
    std::string("_regime_selection_")+std::to_string(params.regime_selection)+\
    std::string("_tot_timesteps_")+std::to_string(params.timesteps)+std::string("_num_clients_")+\
    std::to_string(params.num_clients)+std::string("/");
    

    std::ifstream file(filepath+fileName);

    if (file.is_open()) {
        double delay, period, p, q, mean, variance, weight;
        while (file >> delay >> period >> p >> q >> mean >> variance >> weight) {
            client.delay = delay;
            client.period = period;
            client.p = p;
            client.q = q;
            client.mean = mean;
            client.variance = variance;
            client.weight = weight;
        }
        file.close();
    } else {
        std::cerr << "Error: Could not open file " << filepath+fileName << std::endl;
    }
} // void read_values_from_file




void BaseScheduler::get_clients_channel_states() {
    int i = 0;
    for (auto it = my_clients.begin(); it != my_clients.end(); ++it) {
        Client& client = *it;
        double number = distribution(generator);
        if (states[i]) {
            if (number < client.p) {
                states[i] = 0;
            }
        } else {
            if (number < client.q) {
                states[i] = 1;
            }
        }
        ++i;
    }


}; // void BaseScheduler::get_clients_channel_states



std::vector<int> BaseScheduler::check_clients_in_on_channel() {
    std::vector<int> clients_on_channel;
    int i = 0;
    for (auto it = my_clients.begin(); it != my_clients.end(); ++it) {
        if (states[i] == 1) {
            clients_on_channel.push_back(i);
        }
        ++i;
    }
    return clients_on_channel;
};

