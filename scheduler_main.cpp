


#include "scheduler_main.hpp"


int main(int argc, char* argv[]) {

InputParams params = parse_input_params(argc, argv);


std::unique_ptr<BaseScheduler> scheduler_ptr;

if (params.policy == 6) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new VWD(params));
} else if (params.policy == 1) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new WLD(params));
} else if (params.policy == 3) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new EDF(params));
} else if (params.policy == 4) {
    scheduler_ptr = std::unique_ptr<BaseScheduler>(new DBLDF(params));
} else {
    std::cout << "Invalid policy\n";
    return 1;
}


scheduler_ptr->get_clients(); // initialize clients given their parameters (p,q, mean, variance, weight, delay)

scheduler_ptr->start_scheduler_loop(); // main scheduling loop
scheduler_ptr->print_clients_values();
//scheduler_ptr->save_results();







    return 0;

} // int main 