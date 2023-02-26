


#include "scheduler_main.hpp"

InputParams parse_input_params(int argc, char **argv) {
    InputParams params;

    int opt;
    bool n_set = false, r_set = false, p_set = false, t_set = false, s_set = false;
    while ((opt = getopt(argc, argv, "n:r:p:t:s:")) != -1) {
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
            case 's':
                params.seed_value = atoi(optarg);
                s_set = true;
                break;
            default:
                std::cerr << "Usage: " << argv[0] << " -n num_clients -r regime_selection -p policy -t timesteps -s seed_value" << std::endl;
                exit(1);
        }
    }

    // Check that all input parameters have been set
    if (!n_set || !r_set || !p_set || !t_set || !s_set) {
        std::cerr << "Error: Missing input parameter." << std::endl;
        std::cerr << "Usage: " << argv[0] << " -n num_clients -r regime_selection -p policy -t timesteps -s seed_value" << std::endl;
        exit(1);
    }

    std::cout << "number of clients = " << params.num_clients << std::endl;
    std::cout << "regime selection = " << params.regime_selection << std::endl;
    std::cout << "policy = " << params.policy << std::endl;
    std::cout << "timesteps = " << params.timesteps << std::endl;
    std::cout << "seed value = " << params.seed_value << std::endl;

    return params;
}


void BaseScheduler::print_clients_values(){

for (auto it = my_clients.begin(); it != my_clients.end(); it++){

    std::cout << "-------------------------------------------" << std::endl;
    std::cout << "Client index: " << it->idx << std::endl;
    std::cout << "delay: " << it->delay << std::endl;
    std::cout << "period: " << it->period << std::endl;
    std::cout << "p value: " << it->p << std::endl;
    std::cout << "q value: " << it->q << std::endl;
    std::cout << "mean value: " << it->mean << std::endl;
    std::cout << "variance value: " << it->variance << std::endl;
    std::cout << "weight value: " << it->weight << std::endl;
    std::cout << "transmitted packets A_t: " << it->A_t << std::endl;
    std::cout << "dummy packet U_t: " << it->U_t << std::endl;
    std::cout << "Dropped packets: " << it->D_t << std::endl;
    std::cout << "remaining packets in buffer: " << it->buffer << std::endl;
    std::cout << "activations for AoI clients: " << it->activations << std::endl;
    std::cout << "Empirical AoI for AoI clients: " << it->final_aoi_value << std::endl;
    std::cout << "Lambda for AoI clients: " << it->lambda << std::endl;
}

}; // void print_clients_values


void BaseScheduler::get_clients() {
// setting the clients with their respective values
for (int i = 0; i < params.num_clients; i++) {
    //Client client(i+1);
    std::string filename = "client_" + std::to_string(i+1) + "_values.txt";
    read_values_from_file(i, filename, params);
    //my_clients.push_back(client);
}
}; // void get_clients()

void BaseScheduler::read_values_from_file(int client_index, const std::string& fileName, InputParams params) {

    
    filepath = std::string("results/")+std::string("policy_")+std::to_string(params.policy)+\
    std::string("_regime_selection_")+std::to_string(params.regime_selection)+\
    std::string("_tot_timesteps_")+std::to_string(params.timesteps)+std::string("_num_clients_")+\
    std::to_string(params.num_clients)+std::string("/");
    

    std::ifstream file(filepath+fileName);

    if (file.is_open()) {
        
        double delay, period, p, q, mean, variance, weight, lambda;
        while (file >> delay >> period >> p >> q >> mean >> variance >> weight >> lambda) {
            Client client(client_index+1, delay, period, p, q, mean, variance, weight, lambda);
            my_clients.push_back(client);
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

void BaseScheduler::aoi_client_packet_arrival(int current_timestep){
int i = 0;

for(auto it = my_clients.begin(); it != my_clients.end(); ++it) {

double number = distribution(generator);
if(it->lambda > number){
        aoi_packets[i] = 1;
        it->time_since_aoi_packet_generated = current_timestep; // store the timestep where the packet was generated
}else{
        aoi_packets[i] = 0;
    }

++i;
}
};

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


void BaseScheduler::start_scheduler_loop() {

for(int current_timestep = 0; current_timestep < params.timesteps; current_timestep++){
    get_clients_channel_states(); // update clients' ON-OFF channel states.
    aoi_client_packet_arrival(current_timestep); // for AoI clients.
    client_to_schedule = pick_client_to_schedule(); // picks client in ON channel
    schedule_client_and_update_values(current_timestep); // performs scheduling depending on the selected regime
    update_client_parameters(current_timestep); // updates values related to deficit (depends on policy)


/*
    // for printing the ON channel vector.
    for (int i = 0; i < params.num_clients; i++) {
        std::cout << states[i] << " ";
    }
    std::cout << std::endl;
    for (int i = 0; i < params.num_clients; i++) {
        std::cout << aoi_packets[i]  << " ";
    }
    std::cout << std::endl;

    std::cout << "client to schedule is: " << client_to_schedule  << " at timestep " << current_timestep << std::endl;
    
    std::cout << "client index    A_t    U_t    D_t   buffer  AoI" << std::endl;
    for (auto it = my_clients.begin(); it != my_clients.end(); it++){
        std::cout << "client " << it->idx << " " << it->A_t << " " << it->U_t << " " << it->D_t << " " << it->buffer << " " << it->AoI << " " << std::endl;
    }
    std::cout << std::endl << "----------------------" << std::endl;
*/
}

for (auto it = my_clients.begin(); it != my_clients.end(); it++){
    it->final_aoi_value = std::accumulate(it->aoi_values.begin(), it->aoi_values.end(), 0.0);
}


};

void BaseScheduler::schedule_client_and_update_values(int current_timestep){  

int i = 0;


for (auto it = my_clients.begin(); it != my_clients.end(); it++){

if(params.regime_selection == 1 && (i <= floor(params.num_clients/2) - 1)){ // if the client is an AoI client (when selected regime is 1).

if(client_to_schedule == i){
    it->activations = it->activations + 1; // used by vwd only.

    it->AoI = current_timestep + 1 - it->time_since_aoi_packet_generated;
    
}else{
    it->AoI = it->AoI + 1;
}

it->aoi_values.push_back(it->AoI);


}else{ // if the client is a delay client. 

if((current_timestep % it->period) == 0) // a packet is generated for client i
{it->buffer = it->buffer + 1;

if(it->buffer > (it->delay * it->period)){
it->buffer = it->delay * it->period;
it->D_t = it->D_t + 1;
}
}

if(client_to_schedule == i){ // if the client is the one picked to schedule
    //std::cout << "picked client " << i+1 << " in timestep "<< current_timestep << std::endl;
if(it->buffer <= 0){
    it->U_t = it->U_t + 1;
    it->buffer = 0;
}else{
    it->A_t = it->A_t + 1;
    it->buffer = it->buffer - 1;
}
}
it->delay_values.push_back(it->D_t);
it->activations = it->A_t + it->U_t; // activations for delay clients.
} // end of delay client functions




i = i + 1;
}


}; // void BaseScheduler::schedule_client_and_update_values


void BaseScheduler::save_results(int current_run){ // saves the arrays from each client for each run.
int i = 0;
for (auto it = my_clients.begin(); it != my_clients.end(); it++){

std::string filename = "client_" + std::to_string(it->idx) +"_run_" + std::to_string(current_run) + "_results.txt";


std::ofstream outfile(filepath+filename);
    
if(params.regime_selection == 1 && (i <= floor(params.num_clients/2) - 1)){ // storing aoi values
 for (const auto& aoi_value : it->aoi_values){
    outfile << aoi_value << "\n";
}
    }else{ // storing delay values
 for (const auto& delay_value : it->delay_values){
    outfile << delay_value << "\n";
}
}

outfile.close();
i = i + 1;
}
}; // function BaseScheduler::save_results


// picking client based on deficit (deficit defined differently for each policy)
int BaseScheduler::pick_client_to_schedule() {
//std::cout << "base scheduler " << std::endl;  
int client_to_schedule = -1; // ID of the client to be selected for scheduling.
double max_deficit;
int n = 0;

for (auto it = my_clients.begin(); it != my_clients.end(); it++){

if(states[n] && client_to_schedule < 0){
    client_to_schedule = n;
    max_deficit = it->deficit;
}else{
if(states[n] && max_deficit < it->deficit){
    client_to_schedule = n;
    max_deficit = it->deficit;
}}
n = n + 1;
}
return client_to_schedule;
};


void BaseScheduler::update_client_parameters(int current_timestep) {
// nothing implemented here since it depends on policy.
};


void VWD::update_client_parameters(int current_timestep) {
//std::cout << "VWD " << std::endl;  

for (auto it = my_clients.begin(); it != my_clients.end(); it++){

it->deficit = ((it->mean * (double)current_timestep ) - it->activations) / sqrt(it->variance) ; 

}



}; // function VWD::pick_client_to_schedule


void WLD::update_client_parameters(int current_timestep) {
//std::cout << "WLD " << std::endl;  

for (auto it = my_clients.begin(); it != my_clients.end(); it++){

it->deficit = ((it->mean * (double)current_timestep ) - (it->A_t + it->U_t)) / pow(2, (it->delay)) ; 

}

}; // function WLD::pick_client_to_schedule



void EDF::update_client_parameters(int current_timestep) {
//std::cout << "EDF " << std::endl; 

for (auto it = my_clients.begin(); it != my_clients.end(); it++){
it->deficit = -1 * it->buffer; // deficit here is the shortest buffer value.
}

}; // function EDF::pick_client_to_schedule



void DBLDF::update_client_parameters(int current_timestep) {
//std::cout << "DBLDF " << std::endl; 

for (auto it = my_clients.begin(); it != my_clients.end(); it++){

it->deficit = ((it->mean * (double)current_timestep ) - (it->A_t + it->U_t)); 

}

}; // function DBLDF::pick_client_to_schedule



/*
void BaseScheduler::reset_clients(){
for (auto it = my_clients.begin(); it != my_clients.end(); it++){

it->buffer = 0;
it->A_t = 0;
it->U_t = 0;
it->D_t = 0;
it->AoI = 1;
it->time_since_aoi_packet_generated = 0;

it->aoi_values.clear();
it->delay_values.clear();

it->final_aoi_value = 0;
it->deficit = 0.0;



}

}
*/