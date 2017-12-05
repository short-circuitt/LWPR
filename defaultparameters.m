function params = defaultparameters()

    params.dim = 128;
    params.k = 256;
    params.pickdims = 16384;
    params.fnum = 300;
    params.tpdist = 2;
    
    bpw = params.pickdims/params.k;

    if (abs(floor(bpw)-bpw)>0)
        error('BPW is not whole number')
    end
    
    params.bpw = bpw;

    params.datadir = 'Data/';
    params.yaeldir = 'Yael/';
        
    % Save parameters
    params.SAVEFEATS = false;
    params.SAVEBOW = true;
    params.SAVEVLAD = true;    
    
    % Training parameters
    params.trainingdir = 'Training/';
    params.pcafilename = 'pcabasis';
        
    % Detector parameters
    params.metric_threshold = 50;
    params.scale_levels = 4;    
    params.num_octaves = 4;

    % Descriptor parameters
    params.p = {[14 14], 9, 10};
        
    % Dataset parameters    
    params.dname = 'gpw';
    
    params.d1 = 'day_left';
    params.d2 = 'night_right';
    
    params.dlength1 = 200;
    params.dlength2 = 200;
    
    params.imagedir = 'Images/';
    %%params.imagedir = sprintf('~/Datasets/%s/',params.dname);
    
    params.imageprefix = 'Image';
    params.imagefile = sprintf('%s%%s/%s%%03i.jpg',params.imagedir,params.imageprefix);
            
end