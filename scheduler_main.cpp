


#include "scheduler_main.hpp"


int main(int argc, char* argv[]) {

InputParams const params = parse_input_params(argc, argv);




for (int i = 0; i < params.num_runs; i++){


int seed = params.seed_value + i*43916;

std::unique_ptr<BaseScheduler> scheduler_ptr;

if (params.policy == 6) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new VWD(params, seed));
} else if (params.policy == 1) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new WLD(params, seed));
} else if (params.policy == 3) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new EDF(params, seed));
} else if (params.policy == 4) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new DBLDF(params, seed));
} else if (params.policy == 7) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new STATIONARY_DBLDF(params, seed));
} 
else {
    std::cout << "Invalid policy\n";
    return 1;
}


scheduler_ptr->get_clients();          // initialize clients given their parameters (e.g. p,q, mean, etc)
scheduler_ptr->start_scheduler_loop(); // main scheduling loop
scheduler_ptr->print_clients_values(); // print onto terminal
scheduler_ptr->save_results(i+1);        // save results to directory
}

return 0;

} // int main 