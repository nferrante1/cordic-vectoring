/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                         */
/*  \   \        Copyright (c) 2003-2013 Xilinx, Inc.                 */
/*  /   /        All Right Reserved.                                  */
/* /---/   /\                                                         */
/* \   \  /  \                                                        */
/*  \___\/\___\                                                       */
/**********************************************************************/


#include "iki.h"
#include <string.h>
#include <math.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
typedef void (*funcp)(char *, char *);
extern int main(int, char**);
extern void execute_16(char*, char *);
extern void execute_17(char*, char *);
extern void execute_98(char*, char *);
extern void execute_99(char*, char *);
extern void execute_30(char*, char *);
extern void execute_36(char*, char *);
extern void execute_41(char*, char *);
extern void execute_46(char*, char *);
extern void execute_51(char*, char *);
extern void execute_56(char*, char *);
extern void execute_61(char*, char *);
extern void execute_66(char*, char *);
extern void execute_71(char*, char *);
extern void execute_76(char*, char *);
extern void execute_81(char*, char *);
extern void execute_86(char*, char *);
extern void execute_91(char*, char *);
extern void execute_96(char*, char *);
extern void execute_15(char*, char *);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
extern void transaction_4(char*, char*, unsigned, unsigned, unsigned);
extern void transaction_5(char*, char*, unsigned, unsigned, unsigned);
funcp funcTab[22] = {(funcp)execute_16, (funcp)execute_17, (funcp)execute_98, (funcp)execute_99, (funcp)execute_30, (funcp)execute_36, (funcp)execute_41, (funcp)execute_46, (funcp)execute_51, (funcp)execute_56, (funcp)execute_61, (funcp)execute_66, (funcp)execute_71, (funcp)execute_76, (funcp)execute_81, (funcp)execute_86, (funcp)execute_91, (funcp)execute_96, (funcp)execute_15, (funcp)vhdl_transfunc_eventcallback, (funcp)transaction_4, (funcp)transaction_5};
const int NumRelocateId= 22;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/cordic_behav/xsim.reloc",  (void **)funcTab, 22);
	iki_vhdl_file_variable_register(dp + 15592);
	iki_vhdl_file_variable_register(dp + 15648);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/cordic_behav/xsim.reloc");
}

void simulate(char *dp)
{
		iki_schedule_processes_at_time_zero(dp, "xsim.dir/cordic_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

extern SYSTEMCLIB_IMP_DLLSPEC void local_register_implicit_channel(int, char*);
extern void implicit_HDL_SCinstatiate();

extern SYSTEMCLIB_IMP_DLLSPEC int xsim_argc_copy ;
extern SYSTEMCLIB_IMP_DLLSPEC char** xsim_argv_copy ;

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/cordic_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/cordic_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/cordic_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
