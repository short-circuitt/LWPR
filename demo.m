% demo.m

tpdist = 2;

addpath(genpath('/home/stephanie/3rdParty/vlad_cvpr2010'));

[params,dparams] =  defaultparameters();

[results,results2] = matchplaces(params.datadir,dparams.dname,dparams.d1,dparams.d2,params.k,params.dim,params.fnum,params.bpw,params.pickdims);

[aa,bb] = max(results,[],2);
hdistrec = abs((1:length(bb))-bb');
cc = sum(hdistrec<=tpdist);

disp(params.pickdims)
disp(cc)

[aa2,bb2] = max(results2,[],2);
hdistrec2 = abs((1:length(bb2))-bb2');
cc2 = sum(hdistrec2<=tpdist);

disp(cc2)