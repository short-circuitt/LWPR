/*
 * Codebook.cpp
 */

#include "Codebook.h"

#include "mex_main.h"
#include "mex.h"

Codebook::Codebook() {
	all_descriptors.release();
}

void Codebook::addCodebookData(mxArray **plhs, const mxArray **prhs) {
    int elements = mxGetNumberOfElements(prhs[1]);
    double* dd = (double*)mxGetData(prhs[1]);
    
    double* numrows = (double*)mxGetData(prhs[2]);
    double* numcols = (double*)mxGetData(prhs[3]);
       
    int nr = (int)(*numrows);
    int nc = (int)(*numcols);
        
    cv::Mat* descriptors = new cv::Mat(nc,nr,CV_64F,dd);
    cv::Mat d2 = descriptors->t();
    
    all_descriptors.push_back(d2);
}

void Codebook::buildCodebook(mxArray **plhs, const mxArray **prhs) {
	const Eigen::Map<Eigen::MatrixXd> nWords(mxGetPr(prhs[1]), 1, 1);
	string codebookPath(mxArrayToString(prhs[2]));

	unsigned int numWords = (unsigned int) nWords(0, 0);

     mexPrintf("Number of words: %d\n", numWords);
    
    all_descriptors.convertTo(all_descriptors, CV_32F);
    
	cv::TermCriteria tc(cv::TermCriteria::EPS,1000,0.01);
	cv::BOWKMeansTrainer bowTrainer(numWords,tc,1,cv::KMEANS_PP_CENTERS);
	mexPrintf("Clustering descriptors...\n");
	Mat new_codebook = bowTrainer.cluster(all_descriptors);
    
    mexPrintf("Clustering done...\n");

	mexPrintf("Writing codebook to %s\n",codebookPath.c_str());
	cv::FileStorage fs(codebookPath, cv::FileStorage::WRITE);
	fs << "codebook" << new_codebook;
	fs.release();

	mexPrintf("Releasing data\n");
	all_descriptors.release();
	new_codebook.release();

}