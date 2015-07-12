boss(boss).
proxy(proxy_agent).

/*
 * execution(test) 			-> nessuna GUI: tutto viene caricato direttamente da file di configurazione, compreso i goal da iniettare
 * execution(standalone) 	-> parte senza nessun goal precariato ma con solo con la tua GUI
 * execution(deployment) 	-> parte senza nessun goal precariato e senza nessuna GUI, quando ci sarà l’interfaccia web si usa quella
 */

execution(deployment).		 
//execution(test).
//execution(standalone).

local_ip_address("194.119.214.121").
url_for_agent_services("http://194.119.214.121:8080/HTTPAgent/AgentService").

frequency_periodic_update(10000).
frequency_term_update(1000).
frequency_perception_loop(1500).
frequency_short_perception_loop(5000).
frequency_long_perception_loop(15000).
frequency_very_long_perception_loop(90000).

time_for_collecting_answers(500).
time_for_organization_borns(200).
time_for_project_employment(2500).


simulated_request_delay(9000).

//#################################
//	BLACKLIST
//#################################
blacklist_enabled(true).
blacklist_verbose(false).
blacklist_expiration(0,1,0). //HH,MM,SS
//#################################

search_number_of_steps(5000).
search_number_of_solutions(5).
search_max_depth(24).
max_time_for_collecting(10).

//#################################
//	GUI FOR GOAL INJECTION
//#################################
use_gui(true).
//#################################


//#################################
//	GUI FOR CAPABILITY FAILURE
//#################################
use_capability_failure_gui(false).
//#################################



//#################################
//	VERBOSE FLAGS
//#################################
orchestrate_verbose(false).
accumulation_verbose(false).
verbose_par_condition(false).
project_manager_verbose(false).
blacklist_verbose(true).
//#################################




//#################################
//	GOAL FUSION
//#################################
goal_fusion_enabled(false).
goal_fusion_goalbase_first("src/asl/goalBaseSigmaIncendio.asl").
goal_fusion_goalbase_last("src/asl/goalBaseSigmaTerremoto.asl").


//#############################################
// DEFAULT DATABASE CONFIG (FOR TEST EXECUTION)
//#############################################
default_db_user("occp_root").
default_db_port("3306").
default_db_password("occp_root_password_2014").
default_db_database("musa_workflow").
default_db_ip("194.119.214.121").
