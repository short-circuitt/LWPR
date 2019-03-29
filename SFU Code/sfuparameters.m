function params = sfuparameters()

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
    params.dname = 'sfu';
    
    params.d1 = 'dry'; 
    params.d2 = 'dusk';
    
    params.offsetimage = true;
    
    params.offset = 20;
    
    params.offsetdirn1 = 0;
    params.offsetdirn2 = 1;
    
    params.dlength1 = 239;
    params.dlength2 = 239;
    
    params.imagedir = 'Images/';
    
    params.imageprefix = '';
    params.imagefile = sprintf('%s%%s/%s%%03i.jpg',params.imagedir,params.imageprefix);
            
end