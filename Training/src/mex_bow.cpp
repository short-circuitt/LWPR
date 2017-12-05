/*
 * mex_main.cpp
 */

#include <ctime>
#include <string>
using std::string;
#include <exception>

#include "mex_main.h"
#include <mex.h>

// Need to clear memory if exception occurs.....
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {

	// seed random number gen
	//srand ( time(NULL) );

	// define persistent static pointers
	static Codebook *codebook;

	// check first argument is a string
	const char *function_name;
	if (!mxIsChar(prhs[0]) || mxGetM(prhs[0]) != 1 || mxIsClass(prhs[0],
			"sparse") || mxIsComplex(prhs[0])) {
		mexErrMsgTxt(
				"must specify function name as row vector string, first argument");
	}
	function_name = mxArrayToString(prhs[0]);
	mexPrintf("Function: %s\n",function_name);
    
	if (!strcmp(function_name, "initialiseCodebook")) {
		codebook = new Codebook();
		return;
	}
    
    if (!strcmp(function_name, "addCodebookData")) {
		codebook->addCodebookData(plhs, prhs);
		return;
	}
    
    	if (!strcmp(function_name, "buildCodebook")) {
		codebook->buildCodebook(plhs, prhs);
		return;
	}

	mexErrMsgTxt("Function name did not match any known functions");
	return;
}