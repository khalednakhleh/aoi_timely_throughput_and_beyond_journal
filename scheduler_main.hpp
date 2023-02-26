

#ifndef SCHEDULER_MAIN
#define SCHEDULER_MAIN



#include <stdio.h>
#include <stdlib.h>
#include <iostream>
#include <vector>
#include <list>
#include <string>
#include <cstdlib>
#include <unistd.h>
#include <fstream>
#include <random>
#include <math.h>
#include <cmath>
#include <memory>
#include <iomanip>




struct InputParams {
    int num_clients;
    int regime_selection;
    int policy;
    int timesteps;	
    int seed_value;
    int current_run;
}; // struct input_params


InputParams parse_input_params(int argc, char **argv);


class Client {
public: // defining the variables, setters, and getters.
std::string client_type; // client can either be a "aoi" or "delay" client.


//Client(int idx_value) : idx(idx_value) {}
Client(int idx_value, double delay_value, double period_value, double p_value, double q_value, double mean_value, double variance_value, double weight_value, double lambda_value) 
: idx(idx_value),delay(delay_value), period(period_value), p(p_value), q(q_value), mean(mean_value), variance(variance_value), weight(weight_value), lambda(lambda_value) {}

const int idx;
const int delay;
const int period;
const double p;
const double q; 
const double mean;
const double variance;
const double weight; 
const double lambda;
int buffer = 0;

std::vector<double> delay_values_per_time;
std::vector<double> aoi_values_per_time;

int A_t = 0; // number of activations up to time t.
int U_t = 0; // number of dummy packets up to time t.
int D_t = 0; // number of dropped packets up to time t.
int AoI = 0;
int time_since_aoi_packet_generated = 0; // for AoI clients only.

int activations = 0; // only for VWD policy (equal to A_t + U_t).
std::vector<int> aoi_values;
std::vector<int> delay_values;
int final_aoi_value; 

double deficit = 0.0; // For VWD, WLD, and DBLDF.



}; // Class Client.


class BaseScheduler {
public:

    std::list<Client> my_clients;
    const int seed_value;
    std::default_random_engine generator;
    std::uniform_real_distribution<double> distribution;
    
    const InputParams params;
    bool* states;
    bool* aoi_packets;
    int client_to_schedule; // index to schedule a client in a timestep

    std::string filepath;

    BaseScheduler(InputParams params, int seed_value)
        : generator(seed_value), seed_value(seed_value), distribution(0.0, 1.0), params(params),
          states(new bool[params.num_clients]), aoi_packets(new bool[params.num_clients])
    {}
    
    void get_clients();
    void read_values_from_file(int client_index, const std::string& fileName, InputParams params);
    void get_clients_channel_states(); // get current channel state at the current timestep.
    void start_scheduler_loop(); // main iteration loop over clients.
    void save_results(int current_run);
    void print_clients_values();
    int pick_client_to_schedule();
    void aoi_client_packet_arrival(int current_timestep);
    void schedule_client_and_update_values(int current_timestep);
    virtual void update_client_parameters(int current_timestep);

    
}; // class BaseScheduler



class VWD : public BaseScheduler {
public:
    // constructor that calls BaseScheduler constructor
    VWD(InputParams params, int seed_value) : BaseScheduler(params, seed_value) {}
    
    void update_client_parameters(int current_timestep) override;

};



class WLD : public BaseScheduler {
public:
    // constructor that calls BaseScheduler constructor
    WLD(InputParams params, int seed_value) : BaseScheduler(params, seed_value) {}
    
    void update_client_parameters(int current_timestep) override;


};


class EDF : public BaseScheduler {
public:
    // constructor that calls BaseScheduler constructor
    EDF(InputParams params, int seed_value) : BaseScheduler(params, seed_value) {}

    void update_client_parameters(int current_timestep) override;

    
    // additional member functions for EDF class
};


class DBLDF : public BaseScheduler {
public:
    // constructor that calls BaseScheduler constructor
    DBLDF(InputParams params, int seed_value) : BaseScheduler(params, seed_value) {}

    void update_client_parameters(int current_timestep) override;

    
    // additional member functions for DBLDF class
};





#endif 