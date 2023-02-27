


#include "scheduler_main.hpp"


int main(int argc, char* argv[]) {

InputParams const params = parse_input_params(argc, argv);


std::unique_ptr<BaseScheduler> scheduler_ptr;

if (params.policy == 6) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new VWD(params, params.seed_value));
} else if (params.policy == 1) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new WLD(params, params.seed_value));
} else if (params.policy == 3) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new EDF(params, params.seed_value));
} else if (params.policy == 4) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new DBLDF(params, params.seed_value));
} else {
    std::cout << "Invalid policy\n";
    return 1;
}


scheduler_ptr->get_clients();          // initialize clients given their parameters (e.g. p,q, mean, etc)
scheduler_ptr->start_scheduler_loop(); // main scheduling loop
scheduler_ptr->print_clients_values(); // print onto terminal
scheduler_ptr->save_results(params.num_runs);      // save results to directory


return 0;

} // int main 