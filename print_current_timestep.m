





function print_current_timestep(current_timestep)

interval = 100;

if mod(current_timestep, interval) == 0

    fprintf("Current timestep: %d.\n", current_timestep);

end