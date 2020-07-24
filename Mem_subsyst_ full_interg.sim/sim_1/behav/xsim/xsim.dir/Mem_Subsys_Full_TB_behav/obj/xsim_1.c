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
extern void execute_429(char*, char *);
extern void execute_430(char*, char *);
extern void execute_60(char*, char *);
extern void execute_62(char*, char *);
extern void execute_63(char*, char *);
extern void execute_64(char*, char *);
extern void execute_65(char*, char *);
extern void execute_66(char*, char *);
extern void execute_67(char*, char *);
extern void execute_68(char*, char *);
extern void execute_69(char*, char *);
extern void execute_70(char*, char *);
extern void execute_71(char*, char *);
extern void execute_72(char*, char *);
extern void execute_73(char*, char *);
extern void execute_74(char*, char *);
extern void execute_75(char*, char *);
extern void execute_76(char*, char *);
extern void execute_77(char*, char *);
extern void execute_78(char*, char *);
extern void execute_83(char*, char *);
extern void execute_84(char*, char *);
extern void execute_85(char*, char *);
extern void execute_86(char*, char *);
extern void execute_87(char*, char *);
extern void execute_88(char*, char *);
extern void execute_89(char*, char *);
extern void execute_90(char*, char *);
extern void execute_91(char*, char *);
extern void execute_92(char*, char *);
extern void execute_93(char*, char *);
extern void execute_94(char*, char *);
extern void execute_95(char*, char *);
extern void execute_96(char*, char *);
extern void execute_97(char*, char *);
extern void execute_98(char*, char *);
extern void execute_99(char*, char *);
extern void execute_100(char*, char *);
extern void execute_101(char*, char *);
extern void execute_80(char*, char *);
extern void execute_82(char*, char *);
extern void execute_405(char*, char *);
extern void execute_406(char*, char *);
extern void execute_407(char*, char *);
extern void execute_408(char*, char *);
extern void execute_409(char*, char *);
extern void execute_410(char*, char *);
extern void execute_106(char*, char *);
extern void execute_107(char*, char *);
extern void execute_108(char*, char *);
extern void execute_112(char*, char *);
extern void execute_113(char*, char *);
extern void execute_114(char*, char *);
extern void execute_118(char*, char *);
extern void execute_119(char*, char *);
extern void execute_120(char*, char *);
extern void execute_124(char*, char *);
extern void execute_125(char*, char *);
extern void execute_126(char*, char *);
extern void execute_130(char*, char *);
extern void execute_131(char*, char *);
extern void execute_132(char*, char *);
extern void execute_136(char*, char *);
extern void execute_137(char*, char *);
extern void execute_138(char*, char *);
extern void execute_142(char*, char *);
extern void execute_143(char*, char *);
extern void execute_144(char*, char *);
extern void execute_148(char*, char *);
extern void execute_149(char*, char *);
extern void execute_150(char*, char *);
extern void execute_154(char*, char *);
extern void execute_155(char*, char *);
extern void execute_156(char*, char *);
extern void execute_160(char*, char *);
extern void execute_161(char*, char *);
extern void execute_162(char*, char *);
extern void execute_166(char*, char *);
extern void execute_167(char*, char *);
extern void execute_168(char*, char *);
extern void execute_172(char*, char *);
extern void execute_173(char*, char *);
extern void execute_174(char*, char *);
extern void execute_178(char*, char *);
extern void execute_179(char*, char *);
extern void execute_180(char*, char *);
extern void execute_184(char*, char *);
extern void execute_185(char*, char *);
extern void execute_186(char*, char *);
extern void execute_190(char*, char *);
extern void execute_191(char*, char *);
extern void execute_192(char*, char *);
extern void execute_196(char*, char *);
extern void execute_197(char*, char *);
extern void execute_198(char*, char *);
extern void execute_202(char*, char *);
extern void execute_203(char*, char *);
extern void execute_204(char*, char *);
extern void execute_208(char*, char *);
extern void execute_209(char*, char *);
extern void execute_210(char*, char *);
extern void execute_214(char*, char *);
extern void execute_215(char*, char *);
extern void execute_216(char*, char *);
extern void execute_220(char*, char *);
extern void execute_221(char*, char *);
extern void execute_222(char*, char *);
extern void execute_226(char*, char *);
extern void execute_227(char*, char *);
extern void execute_228(char*, char *);
extern void execute_232(char*, char *);
extern void execute_233(char*, char *);
extern void execute_234(char*, char *);
extern void execute_238(char*, char *);
extern void execute_239(char*, char *);
extern void execute_240(char*, char *);
extern void execute_244(char*, char *);
extern void execute_245(char*, char *);
extern void execute_246(char*, char *);
extern void execute_250(char*, char *);
extern void execute_251(char*, char *);
extern void execute_252(char*, char *);
extern void execute_256(char*, char *);
extern void execute_257(char*, char *);
extern void execute_258(char*, char *);
extern void execute_262(char*, char *);
extern void execute_263(char*, char *);
extern void execute_264(char*, char *);
extern void execute_268(char*, char *);
extern void execute_269(char*, char *);
extern void execute_270(char*, char *);
extern void execute_274(char*, char *);
extern void execute_275(char*, char *);
extern void execute_276(char*, char *);
extern void execute_280(char*, char *);
extern void execute_281(char*, char *);
extern void execute_282(char*, char *);
extern void execute_286(char*, char *);
extern void execute_287(char*, char *);
extern void execute_288(char*, char *);
extern void execute_292(char*, char *);
extern void execute_293(char*, char *);
extern void execute_294(char*, char *);
extern void execute_297(char*, char *);
extern void execute_298(char*, char *);
extern void execute_300(char*, char *);
extern void execute_301(char*, char *);
extern void execute_303(char*, char *);
extern void execute_304(char*, char *);
extern void execute_306(char*, char *);
extern void execute_307(char*, char *);
extern void execute_309(char*, char *);
extern void execute_310(char*, char *);
extern void execute_312(char*, char *);
extern void execute_313(char*, char *);
extern void execute_315(char*, char *);
extern void execute_316(char*, char *);
extern void execute_318(char*, char *);
extern void execute_319(char*, char *);
extern void execute_321(char*, char *);
extern void execute_322(char*, char *);
extern void execute_324(char*, char *);
extern void execute_325(char*, char *);
extern void execute_327(char*, char *);
extern void execute_328(char*, char *);
extern void execute_330(char*, char *);
extern void execute_331(char*, char *);
extern void execute_333(char*, char *);
extern void execute_334(char*, char *);
extern void execute_336(char*, char *);
extern void execute_337(char*, char *);
extern void execute_339(char*, char *);
extern void execute_340(char*, char *);
extern void execute_342(char*, char *);
extern void execute_343(char*, char *);
extern void execute_345(char*, char *);
extern void execute_346(char*, char *);
extern void execute_348(char*, char *);
extern void execute_349(char*, char *);
extern void execute_351(char*, char *);
extern void execute_352(char*, char *);
extern void execute_354(char*, char *);
extern void execute_355(char*, char *);
extern void execute_357(char*, char *);
extern void execute_358(char*, char *);
extern void execute_360(char*, char *);
extern void execute_361(char*, char *);
extern void execute_363(char*, char *);
extern void execute_364(char*, char *);
extern void execute_366(char*, char *);
extern void execute_367(char*, char *);
extern void execute_369(char*, char *);
extern void execute_370(char*, char *);
extern void execute_372(char*, char *);
extern void execute_373(char*, char *);
extern void execute_375(char*, char *);
extern void execute_376(char*, char *);
extern void execute_378(char*, char *);
extern void execute_379(char*, char *);
extern void execute_381(char*, char *);
extern void execute_382(char*, char *);
extern void execute_384(char*, char *);
extern void execute_385(char*, char *);
extern void execute_387(char*, char *);
extern void execute_388(char*, char *);
extern void execute_390(char*, char *);
extern void execute_391(char*, char *);
extern void execute_105(char*, char *);
extern void execute_394(char*, char *);
extern void execute_395(char*, char *);
extern void execute_396(char*, char *);
extern void execute_397(char*, char *);
extern void execute_398(char*, char *);
extern void execute_399(char*, char *);
extern void execute_400(char*, char *);
extern void execute_401(char*, char *);
extern void execute_402(char*, char *);
extern void execute_403(char*, char *);
extern void execute_404(char*, char *);
extern void execute_414(char*, char *);
extern void execute_415(char*, char *);
extern void execute_416(char*, char *);
extern void execute_418(char*, char *);
extern void execute_419(char*, char *);
extern void execute_420(char*, char *);
extern void execute_421(char*, char *);
extern void execute_422(char*, char *);
extern void execute_423(char*, char *);
extern void execute_424(char*, char *);
extern void execute_425(char*, char *);
extern void execute_426(char*, char *);
extern void execute_427(char*, char *);
extern void execute_428(char*, char *);
extern void transaction_0(char*, char*, unsigned, unsigned, unsigned);
extern void vhdl_transfunc_eventcallback(char*, char*, unsigned, unsigned, unsigned, char *);
funcp funcTab[235] = {(funcp)execute_429, (funcp)execute_430, (funcp)execute_60, (funcp)execute_62, (funcp)execute_63, (funcp)execute_64, (funcp)execute_65, (funcp)execute_66, (funcp)execute_67, (funcp)execute_68, (funcp)execute_69, (funcp)execute_70, (funcp)execute_71, (funcp)execute_72, (funcp)execute_73, (funcp)execute_74, (funcp)execute_75, (funcp)execute_76, (funcp)execute_77, (funcp)execute_78, (funcp)execute_83, (funcp)execute_84, (funcp)execute_85, (funcp)execute_86, (funcp)execute_87, (funcp)execute_88, (funcp)execute_89, (funcp)execute_90, (funcp)execute_91, (funcp)execute_92, (funcp)execute_93, (funcp)execute_94, (funcp)execute_95, (funcp)execute_96, (funcp)execute_97, (funcp)execute_98, (funcp)execute_99, (funcp)execute_100, (funcp)execute_101, (funcp)execute_80, (funcp)execute_82, (funcp)execute_405, (funcp)execute_406, (funcp)execute_407, (funcp)execute_408, (funcp)execute_409, (funcp)execute_410, (funcp)execute_106, (funcp)execute_107, (funcp)execute_108, (funcp)execute_112, (funcp)execute_113, (funcp)execute_114, (funcp)execute_118, (funcp)execute_119, (funcp)execute_120, (funcp)execute_124, (funcp)execute_125, (funcp)execute_126, (funcp)execute_130, (funcp)execute_131, (funcp)execute_132, (funcp)execute_136, (funcp)execute_137, (funcp)execute_138, (funcp)execute_142, (funcp)execute_143, (funcp)execute_144, (funcp)execute_148, (funcp)execute_149, (funcp)execute_150, (funcp)execute_154, (funcp)execute_155, (funcp)execute_156, (funcp)execute_160, (funcp)execute_161, (funcp)execute_162, (funcp)execute_166, (funcp)execute_167, (funcp)execute_168, (funcp)execute_172, (funcp)execute_173, (funcp)execute_174, (funcp)execute_178, (funcp)execute_179, (funcp)execute_180, (funcp)execute_184, (funcp)execute_185, (funcp)execute_186, (funcp)execute_190, (funcp)execute_191, (funcp)execute_192, (funcp)execute_196, (funcp)execute_197, (funcp)execute_198, (funcp)execute_202, (funcp)execute_203, (funcp)execute_204, (funcp)execute_208, (funcp)execute_209, (funcp)execute_210, (funcp)execute_214, (funcp)execute_215, (funcp)execute_216, (funcp)execute_220, (funcp)execute_221, (funcp)execute_222, (funcp)execute_226, (funcp)execute_227, (funcp)execute_228, (funcp)execute_232, (funcp)execute_233, (funcp)execute_234, (funcp)execute_238, (funcp)execute_239, (funcp)execute_240, (funcp)execute_244, (funcp)execute_245, (funcp)execute_246, (funcp)execute_250, (funcp)execute_251, (funcp)execute_252, (funcp)execute_256, (funcp)execute_257, (funcp)execute_258, (funcp)execute_262, (funcp)execute_263, (funcp)execute_264, (funcp)execute_268, (funcp)execute_269, (funcp)execute_270, (funcp)execute_274, (funcp)execute_275, (funcp)execute_276, (funcp)execute_280, (funcp)execute_281, (funcp)execute_282, (funcp)execute_286, (funcp)execute_287, (funcp)execute_288, (funcp)execute_292, (funcp)execute_293, (funcp)execute_294, (funcp)execute_297, (funcp)execute_298, (funcp)execute_300, (funcp)execute_301, (funcp)execute_303, (funcp)execute_304, (funcp)execute_306, (funcp)execute_307, (funcp)execute_309, (funcp)execute_310, (funcp)execute_312, (funcp)execute_313, (funcp)execute_315, (funcp)execute_316, (funcp)execute_318, (funcp)execute_319, (funcp)execute_321, (funcp)execute_322, (funcp)execute_324, (funcp)execute_325, (funcp)execute_327, (funcp)execute_328, (funcp)execute_330, (funcp)execute_331, (funcp)execute_333, (funcp)execute_334, (funcp)execute_336, (funcp)execute_337, (funcp)execute_339, (funcp)execute_340, (funcp)execute_342, (funcp)execute_343, (funcp)execute_345, (funcp)execute_346, (funcp)execute_348, (funcp)execute_349, (funcp)execute_351, (funcp)execute_352, (funcp)execute_354, (funcp)execute_355, (funcp)execute_357, (funcp)execute_358, (funcp)execute_360, (funcp)execute_361, (funcp)execute_363, (funcp)execute_364, (funcp)execute_366, (funcp)execute_367, (funcp)execute_369, (funcp)execute_370, (funcp)execute_372, (funcp)execute_373, (funcp)execute_375, (funcp)execute_376, (funcp)execute_378, (funcp)execute_379, (funcp)execute_381, (funcp)execute_382, (funcp)execute_384, (funcp)execute_385, (funcp)execute_387, (funcp)execute_388, (funcp)execute_390, (funcp)execute_391, (funcp)execute_105, (funcp)execute_394, (funcp)execute_395, (funcp)execute_396, (funcp)execute_397, (funcp)execute_398, (funcp)execute_399, (funcp)execute_400, (funcp)execute_401, (funcp)execute_402, (funcp)execute_403, (funcp)execute_404, (funcp)execute_414, (funcp)execute_415, (funcp)execute_416, (funcp)execute_418, (funcp)execute_419, (funcp)execute_420, (funcp)execute_421, (funcp)execute_422, (funcp)execute_423, (funcp)execute_424, (funcp)execute_425, (funcp)execute_426, (funcp)execute_427, (funcp)execute_428, (funcp)transaction_0, (funcp)vhdl_transfunc_eventcallback};
const int NumRelocateId= 235;

void relocate(char *dp)
{
	iki_relocate(dp, "xsim.dir/Mem_Subsys_Full_TB_behav/xsim.reloc",  (void **)funcTab, 235);
	iki_vhdl_file_variable_register(dp + 44576);
	iki_vhdl_file_variable_register(dp + 44632);


	/*Populate the transaction function pointer field in the whole net structure */
}

void sensitize(char *dp)
{
	iki_sensitize(dp, "xsim.dir/Mem_Subsys_Full_TB_behav/xsim.reloc");
}

void simulate(char *dp)
{
	iki_schedule_processes_at_time_zero(dp, "xsim.dir/Mem_Subsys_Full_TB_behav/xsim.reloc");
	// Initialize Verilog nets in mixed simulation, for the cases when the value at time 0 should be propagated from the mixed language Vhdl net
	iki_execute_processes();

	// Schedule resolution functions for the multiply driven Verilog nets that have strength
	// Schedule transaction functions for the singly driven Verilog nets that have strength

}
#include "iki_bridge.h"
void relocate(char *);

void sensitize(char *);

void simulate(char *);

int main(int argc, char **argv)
{
    iki_heap_initialize("ms", "isimmm", 0, 2147483648) ;
    iki_set_sv_type_file_path_name("xsim.dir/Mem_Subsys_Full_TB_behav/xsim.svtype");
    iki_set_crvs_dump_file_path_name("xsim.dir/Mem_Subsys_Full_TB_behav/xsim.crvsdump");
    void* design_handle = iki_create_design("xsim.dir/Mem_Subsys_Full_TB_behav/xsim.mem", (void *)relocate, (void *)sensitize, (void *)simulate, 0, isimBridge_getWdbWriter(), 0, argc, argv);
     iki_set_rc_trial_count(100);
    (void) design_handle;
    return iki_simulate_design();
}
