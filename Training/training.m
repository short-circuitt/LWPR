function training(feats,pcafile,dim,k)

% Load training data

% Build PCA basis
    if ~exist(pcafile,'file')
        c = pca(feats,'Centered','off');
        c = single(c);
        save(pcafile,'c');
    else
        load(pcafile,'c');
    end
    
    c1 = c(:,1:dim);
    tf = feats * c1;

% Build bag of words
    fprefix = sprintf('vocab_%d_%d',k,dim);

    fname = sprintf('%s.yaml',fprefix);
    if ~exist(fname,'file')
        bagofwords(tf,k,fname);
    end

% Convert YAML to .MAT
fmat = sprintf('%s.mat',fprefix);

vocab = readBOW(fname);
vocab = single(vocab);
save(fmat,'vocab');

% Delete YAML
delete(fname);

end

function bagofwords(feats,k,filePath)

    % Using cosine distance need to remove zero length elements
    Xnorm = sqrt(sum(feats.^2, 2));
    all_feats = feats(Xnorm>eps(max(Xnorm)),:);

    UpdateMEX;
    
    mex_quant_bow('initialiseCodebook')
    sz = size(all_feats);
    
    mex_quant_bow('addCodebookData',all_feats,sz(1),sz(2));
        
    mex_quant_bow('buildCodebook',k,filePath);
end

function UpdateMEX

codedir = 'src/';

f1 = sprintf('%smex_bow.cpp ',codedir);
f2 = sprintf('%sCodebook.cpp ',codedir);

mex_string = [f1, ... 
            f2, ...
            '-v -I/usr/include/opencv-2.3.1 -lopencv_core -lopencv_imgproc ', ...
            '-lopencv_highgui -lopencv_flann -lopencv_features2d'];
 eval(['mex ' mex_string]);        
        clear mex
end