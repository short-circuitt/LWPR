function [results,results2] = matchplaces(datadir,dname,d1,d2,k,dim,fnum,bpw,wordnum)
        
           vladname = sprintf('%s/%s_%s_vlad_%i_%i_%i_%i.mat',datadir,dname,d1,k,dim,fnum,bpw);
           load(vladname,'vladcodes','bowcodes','planes'); 
           vlad1 = vladcodes;
           b1 = bowcodes;
           L1 = size(b1,2);
          
           vladname = sprintf('%s/%s_%s_vlad_%i_%i_%i_%i.mat',datadir,dname,d2,k,dim,fnum,bpw);
           load(vladname,'vladcodes','bowcodes','planes'); 
           vlad2 = vladcodes; 
           b2 = bowcodes;
           L2 = size(b2,2);
           
           bowname = sprintf('%s/%s_%s_bow_%i_%i_%i.mat',datadir,dname,d1,wordnum,dim,fnum);
           load(bowname,'words'); 
           words1 = words;
    
           bowname = sprintf('%s/%s_%s_bow_%i_%i_%i.mat',datadir,dname,d2,wordnum,dim,fnum);
           load(bowname,'words'); 
           words2 = words;
    
        results = zeros(L1,L2);
        results2 = zeros(L1,L2);
        
        for ss1 = 1:L1
            for ss2 = 1:L2
                results(ss1,ss2) = docosinehashbyrow(vlad1(:,:,ss1),vlad2(:,:,ss2),bpw,b1(:,ss1),b2(:,ss2));               
                results2(ss1,ss2) = hammingdistance(words1(:,ss1),words2(:,ss2),wordnum);
            end
        end
end
     
function C = docosinehashbyrow(sig1, sig2, bitsperrow,s1,s2)
    bitcountperrow = bitcount(xor(sig1,sig2)');   % Same size as number of words
    sparsify = (s1(:) & s2(:));
    cosinehashrow = bitcountperrow/bitsperrow;
    
    C = cos(cosinehashrow*pi);  % Invert results
    C(~sparsify) = 0;
    C = sum(C);
end

 function count = bitcount(s)
% 	"""
% 	counts the number of bits set to 1
% 	"""
    count = sum(s);
 end
 
 function hdist = hammingdistance(words1,words2,wordnum)
    hdist = 1-sum(xor(words1,words2))/wordnum;
 end