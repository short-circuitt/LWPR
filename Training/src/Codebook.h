/*
 * Codebook.h
 */

#ifndef CODEBOOK_H_
#define CODEBOOK_H_

#include <opencv2/opencv.hpp>
#include <mex.h>

class Codebook {
public:

	Codebook();

	unsigned int frameNum;
	cv::Mat all_descriptors;

	void addCodebookData(mxArray **plhs, const mxArray **prhs);
	void buildCodebook(mxArray **plhs, const mxArray **prhs);

};

#endif /* CODEBOOK_H_ */