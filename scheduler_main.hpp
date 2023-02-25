

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

struct InputParams {
    int num_clients;
    int regime_selection;
    int policy;
    int timesteps;	
}; // struct input_params



class Client {

private:


std::string client_type; // client can either be a "aoi" or "delay" client.


public: // defining the variables, setters, and getters.

Client(int idx_value) : idx(idx_value) {}
Client(int idx_value, double delay_value, double period_value, 
double p_value, double q_value, double mean_value, double variance_value) : idx(idx_value),delay(delay_value), period(period_value), p(p_value), q(q_value), mean(mean_value), variance(variance_value) {}

int idx;
double delay;
double period;
double p;
double q; 
std::vector<double> delay_values_per_time;
std::vector<double> aoi_values_per_time;
double mean;
double variance;
double weight; 

double A_t; // number of activations up to time t.
double U_t; // number of dummy packets up to time t.
double D_t; // number of dropped packets up to time t.


double vwd_deficit; // only for the VWD policy.


double get_delay();
double get_period();
double get_p();
double get_q();
double get_mean();
double get_variance();


void update_delay_values_per_time_vector(int current_timestep);
void update_aoi_values_per_time_vector(int current_timestep);

}; // Class Client.


void print_clients_values(std::list<Client>& my_clients);
InputParams parse_input_params(int argc, char **argv);



void read_values_from_file(Client& client, const std::string& fileName, InputParams params);


class BaseScheduler {
public:
    std::list<Client>& my_clients; 
    std::default_random_engine generator;
    std::uniform_real_distribution<double> distribution;
    
    InputParams params;
    bool* states;

    BaseScheduler(std::list<Client>& my_clients, InputParams params) 
        : my_clients{my_clients}, generator{}, distribution{0.0, 1.0}, params{params}, states{new bool[params.num_clients]}
    {}

    void get_clients_channel_states(); // get current channel state at the current timestep.

    std::vector<int> check_clients_in_on_channel();
}; // class BaseScheduler



class VWD : public BaseScheduler {
public:
    // constructor that calls BaseScheduler constructor
    VWD(std::list<Client>& my_clients, InputParams params) 
        : BaseScheduler(my_clients, params) {
        // additional constructor code for VWD class
    }
    
    // additional member functions for VWD class
};





class WLD : public BaseScheduler {
public:
    // constructor that calls BaseScheduler constructor
    WLD(std::list<Client>& my_clients, InputParams params) 
        : BaseScheduler(my_clients, params) {
        // additional constructor code for WLD class
    }
    
    // additional member functions for WLD class
};


class EDF : public BaseScheduler {
public:
    // constructor that calls BaseScheduler constructor
    EDF(std::list<Client>& my_clients, InputParams params) 
        : BaseScheduler(my_clients, params) {
        // additional constructor code for EDF class
    }
    
    // additional member functions for EDF class
};


class DBLDF : public BaseScheduler {
public:
    // constructor that calls BaseScheduler constructor
    DBLDF(std::list<Client>& my_clients, InputParams params) 
        : BaseScheduler(my_clients, params) {}
    
    // additional member functions for DBLDF class
};













#endif 