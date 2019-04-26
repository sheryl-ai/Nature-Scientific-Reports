function [qdata] = back_quantization ( qdata )
%transfer the data into the form before quantization
%%
%%%%%CONDCAT£»DXYREST%%%%%
load CONDCAT_code
load DXYREST_code
for n=1:length(qdata)-3
    if isnan(qdata{n+3,1})~=1
        qdata(n+3,1)=CONDCAT_code(qdata{n+3,1});
    end
    if isnan(qdata{n+3,2})~=1
        qdata(n+3,2)=DXYREST_code(qdata{n+3,2});
    end
end
%%
%%%%%VSINTRPT%%%%%
for n=1:length(qdata)-3
    if isequal(qdata{n+3,3},0)
        qdata{n+3,3}='N';
    end
end
%%
%%%%%DFDOPRSP;DFCTSCAN;DFMRI;DFATYP%%%%%
for n=1:length(qdata)-3
    if isequal(qdata{n+3,4},2)
        qdata{n+3,4}='N';
    end
    if isequal(qdata{n+3,5},2)
        qdata{n+3,5}='N';
    end
    if isequal(qdata{n+3,6},2)
        qdata{n+3,6}='N';
    end
    if isequal(qdata{n+3,7},2)
        qdata{n+3,7}='n';
    end
end
%%
%%%%%PAG_NAME%%%%%
load PAG_NAME_code
for n=1:length(qdata)-3
    if isnan(qdata{n+3,8})~=1
        qdata(n+3,8)=PAG_NAME_code(qdata{n+3,8});
    end
end
%%
%%%%%13_dti_sequences_E1_C3%%%%%
load PAG_NAME_code
for n=1:length(qdata)-3
    if isequal(qdata{n+3,9},2)
        qdata{n+3,9}='NA';
    end
end
%%
%%%%%PDDXEST;DXTREMOR;DXRIGID;DXBRADY;DXPOSINS;DXOTHSX;DOMSIDE%%%%%
for n=1:length(qdata)-3
    if isequal(qdata{n+3,10},2)
        qdata{n+3,10}='ACT';
    elseif isequal(qdata{n+3,10},3)
        qdata{n+3,10}='DAY';
    elseif isequal(qdata{n+3,10},4)
        qdata{n+3,10}='MD';   
    elseif isequal(qdata{n+3,10},5)
        qdata{n+3,10}='MON';
    end
    if isequal(qdata{n+3,11},100)
        qdata{n+3,11}='U';
    end
    if isequal(qdata{n+3,12},100)
        qdata{n+3,12}='U';
    end
    if isequal(qdata{n+3,13},100)
        qdata{n+3,13}='U';
    end
    if isequal(qdata{n+3,14},100)
        qdata{n+3,14}='U';
    end
    if isequal(qdata{n+3,15},100)
        qdata{n+3,15}='U';
    end
    if isequal(qdata{n+3,16},100)
        qdata{n+3,16}='U';
    end
end
%%
%%%%%TMDISMED;CNTRLDSM%%%%%
for n=1:length(qdata)-3
    if isequal(qdata{n+3,17},2)
        qdata{n+3,17}='N';
    end
    if isequal(qdata{n+3,18},2)
        qdata{n+3,18}='N';
    end
end
%%
%%%%%FULNUPDR%%%%%
for n=1:length(qdata)-3
    if isequal(qdata{n+3,19},2)
        qdata{n+3,19}='N';
    end
end
end

