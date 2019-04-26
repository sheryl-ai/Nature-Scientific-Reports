function [data, para] = LSTMBackward(data, para)

nBatch = size(data.x,2);

data.dJ_dCt_ = data.dJ_dht.*data.ot;
data.dJ_dot = data.dJ_dht.*data.Ct_;

data.dJ_dCt = data.dJ_dCt_.*(1 - data.Ct_.^2);
data.dJ_dCt = data.dJ_dCt + data.dJ1_dCt; % merge C

data.dJ_dgt = data.dJ_dCt.*data.it;
data.dJ_dit = data.dJ_dCt.*data.gt;
data.dJ_dft = data.dJ_dCt.*data.Ct_1;
data.dJ_dCt_1 = data.dJ_dCt.*data.ft; % send C

data.dJ_dgt0 = data.dJ_dgt.*(1-data.gt.^2);
data.dJ_dit0 = data.dJ_dit.*data.it.*(1-data.it);
data.dJ_dft0 = data.dJ_dft.*data.ft.*(1-data.ft);
data.dJ_dot0 = data.dJ_dot.*data.ot.*(1-data.ot);

data.dJ_du = [data.dJ_dot0;data.dJ_dit0;data.dJ_dgt0;data.dJ_dft0];
data.dJ_dv = para.Woigf'*data.dJ_du;
para.dJ_dWoigf = data.dJ_du*data.v'./nBatch;

n = size(data.ht_1,1);

data.dJ_dht_1 = data.dJ_dv(1:n,:);
data.dJ_dx = data.dJ_dv(1+n:end-1,:);