


#include "scheduler_main.hpp"


int main(int argc, char* argv[]) {

InputParams const params = parse_input_params(argc, argv);


int seed = params.seed_value;

std::unique_ptr<BaseScheduler> scheduler_ptr;

if (params.policy == 6) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new VWD(params, seed));
} else if (params.policy == 1) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new WLD(params, seed));
} else if (params.policy == 3) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new EDF(params, seed));
} else if (params.policy == 4) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new DBLDF(params, seed));
} else {
    std::cout << "Invalid policy\n";
    return 1;
}


scheduler_ptr->get_clients(); // initialize clients given their parameters (p,q, mean, variance, weight, delay)
scheduler_ptr->start_scheduler_loop(); // main scheduling loop per run
scheduler_ptr->print_clients_values();
scheduler_ptr->save_results(1);




return 0;

} // int main 