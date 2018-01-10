#! /usr/bin/awk -f
BEGIN {
simulation_start=0;
simulation_end=0;
}

{
time=$3;

if ( $2=="-t" && time < simulation_start || simulation_start == 0 )  simulation_start=time;

if ( $2=="-t" && time > simulation_end ) simulation_end=time;
}
END {
# ===== TOTAL RUNTIME =====
total_runtime=simulation_end-simulation_start;

print total_runtime;

}
