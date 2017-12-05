params =  defaultparameters();

[results,results2] = matchplaces(params.datadir,params.dname,params.d1,params.d2,params.k,params.dim,params.fnum,params.bpw,params.pickdims);

[aa,bb] = max(results,[],2);
hdistrec = abs((1:length(bb))-bb');
cc = sum(hdistrec<=params.tpdist);

[aa2,bb2] = max(results2,[],2);
hdistrec2 = abs((1:length(bb2))-bb2');
cc2 = sum(hdistrec2<=params.tpdist);

fprintf('VLAD with %i bits correctly matches %0.1f%% of places\n',params.pickdims,100*cc/length(bb));
fprintf('BOW with %i bits correctly matches %0.1f%% of places\n',params.pickdims,100*cc2/length(bb2));
