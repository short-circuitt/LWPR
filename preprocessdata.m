% preprocess data
function preprocessdata
  
    params =  defaultparameters();
    
    % Code depends on the Yael library.
    % Available from http://yael.gforge.inria.fr/
    % Assumes that installed in Yael sub-directory. 
    % Change path as required.
    addpath(genpath(params.yaeldir));  
        
    dim = params.dim;
    k = params.k;
    bpw = params.bpw;
    wordnum = params.pickdims;
    datadir = params.datadir;
        
    c = loadpca(params.trainingdir,params.pcafilename);
    
    c1 = c(:,1:dim);
   
    if ~exist(datadir,'dir')
        mkdir(datadir)
    end
       
    fname = sprintf('%s/vocab_%d_%d.mat',params.trainingdir,k,dim);
    load(fname,'vocab');
    VLADvocab = vocab;

    fname = sprintf('%s/vocab_%d_%d.mat',params.trainingdir,wordnum,dim);
    load(fname,'vocab');
    BOWvocab = vocab;

    planes = getreferenceplanes(dim, bpw);

    preprocessdata1(params,1,VLADvocab,BOWvocab,planes,c1,k,dim,bpw,wordnum,datadir);
    preprocessdata1(params,2,VLADvocab,BOWvocab,planes,c1,k,dim,bpw,wordnum,datadir);

end

function preprocessdata1(params,DIRNUM,VLADvocab,BOWvocab,planes,c1,k,dim,bpw,wordnum,datadir)

    if DIRNUM == 1
        dlength = params.dlength1;
        dd = params.d1;
    elseif DIRNUM == 2
        dlength = params.dlength2;
        dd = params.d2;
    else
        error('Unknown DIRNUM')
    end
    dname = params.dname;

    fnum = params.fnum;

        vladcodes = false(k,bpw,dlength);
        bowcodes = false(k,dlength);

        words = false(wordnum, dlength);
        
        for ss = 1:dlength
            
            if ~mod(ss,50)
                disp(ss)
            end
            
            [df1,~] = loadtestdata(dd,ss,params);
            feats = df1 * c1; 
                        
            if params.SAVEFEATS
               featsname = sprintf('%s/%s_%s_%i_feats_%i_%i_%i.mat',datadir,dname,dd,ss,k,dim,fnum);
               save(featsname,'feats'); 
            end
            
            [sig1, ~, bow1] = vladlsh(VLADvocab',feats',planes);
                        
            vladcodes(:,:,ss) = sig1;
            bowcodes(:,ss) = bow1;
            
            % ALso need to save BOW
            bwords = getbow (BOWvocab', feats');
            words(:,ss) = bwords;
            
        end

        if params.SAVEVLAD
           vladname = sprintf('%s/%s_%s_vlad_%i_%i_%i_%i.mat',datadir,dname,dd,k,dim,fnum,bpw);
           save(vladname,'vladcodes','bowcodes','planes'); 
        end 
        
        if params.SAVEBOW
           bowname = sprintf('%s/%s_%s_bow_%i_%i_%i.mat',datadir,dname,dd,wordnum,dim,fnum);
           save(bowname,'words'); 
        end 
end

function ref_planes = getreferenceplanes(dim, bits)

		% reference planes as many as bits (= signature bits)
		ref_planes = randn(dim, bits);

end

function c = loadpca(trainingdir,pcafilename)

    pcafile = sprintf('%s/%s.mat',trainingdir,pcafilename);
    if (exist(pcafile,'file'))
        load(pcafile,'c');
    else
        error('pcafile does not exist');
    end
end

function [feats1,validPts1] = loadtestdata(dname,jj,params)
        
            IM = loadimage(params,dname,jj);

            % select features
            pts = detectSURFFeatures(rgb2gray(IM),'MetricThreshold',params.metric_threshold,'NumScaleLevels',params.scale_levels,'NumOctaves',params.num_octaves);
            
            % extract SURF 
            [feats1,validPts1] = extractHOGFeaturesFromSURF(IM,pts,params.p,params.fnum);    
            
            feats1 = single(feats1);
end

function IM = loadimage(params,dname,jj)
        IM = imread(sprintf(params.imagefile,dname,jj-1));
           
        % Special case for GPW dataset
	    if strcmp(dname,'day_left') || strcmp(dname, 'day_right')
            IM = imresize(IM,[360,640]);
        end
end

function [feats,validPts] = extractHOGFeaturesFromSURF(Im,Pts,params,FNUM)

   bs = params{1}; 
   nb = params{2};
   radius_factor = params{3};

   ptSizeInPixels = 2*radius_factor * Pts.Scale;
      
   feats = zeros(Pts.Count,prod(bs)*nb);
   skip_these = [];
   
   count = 0;
   
   for p = 1:Pts.Count
        cs = int32(ceil(ptSizeInPixels(p) ./ double(bs)));
        f1 = extractHOGFeatures(Im,Pts(p),'BlockSize',bs,'NumBins',nb,'CellSize',cs);
        if isempty(f1)
            skip_these = [skip_these ; p];
        else
            feats(p,:) = f1;
            count = count + 1;
        end
        if count>=FNUM
           % stop here
           feats = feats(1:p,:);
           validPts = Pts(1:p);
           break;
        end
   end
   
   feats(skip_these,:) = [];
   validPts(skip_these) = [];
end

% Compute a vlad descriptors and a LSH hash from a set of local descriptors
function [sig, v, bwords] = vladlsh (centroids, s, planes)

n = size (s, 2);          % number of descriptors
d = size (s, 1);          % descriptor dimensionality
k = size (centroids, 2);  % number of centroids

% find the nearest neigbhors for each descriptor
[idx, ~] = yael_nn (centroids, s);

bwords = false(1,k);
bwords(idx)=true;

v = zeros (d, k);

for i = 1:n
   v (:, idx(i)) = v (:, idx(i)) + s(:, i) - centroids (:, idx(i));
end

% normalize
vnr = sqrt(sum(sum (v.^2)));

v = v ./ vnr;

if norm( v(:) )== 0
    v = ones(d, k);
end

sig = signaturebit(v, planes);

v = v(:);

end

function [bwords] = getbow (centroids, s)

k = size (centroids, 2);  % number of centroids

% find the nearest neigbhors for each descriptor
[idx, ~] = yael_nn (centroids, s);

bwords = false(1,k);
bwords(idx)=true;

end

 function sig = signaturebit(data, planes)
% 	LSH signature generation using random projection
% 	Returns the signature bits for two data points.
    sig = (data'*planes>=0);
 end 
