function [ model, model_E_g_2,model_E_dx_2] = updateModel_LSTM( model,modelB,epsilon,model_E_g_2,model_E_dx_2,opts)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
lambda = opts.lambda;
EPS = opts.EPS;
flag_adadelta = opts.flag_adadelta;
p = opts.p_adadelta;
if flag_adadelta
%     epsilon =1;
    
% E_g_2 = p * E_g_2 + (1-p) * g.^2;
% RMS_dx = sqrt(E_dx_2+EPS);
% RMS_g = sqrt(E_g_2 + EPS);
% t = RMS_dx./RMS_g;
% dx = - t.*g;
% E_dx_2 = p * E_dx_2 + (1-p) * dx.^2;
% x = y + dx;
    
    g_Woigf = modelB.areaLSTM.dWoigf/opts.miniBatch -lambda * model.areaLSTM.Woigf;
    g_theta0 = modelB.proMLP.dtheta0/opts.miniBatch -lambda * model.proMLP.theta0;
    
    model_E_g_2.areaLSTM.Woigf = p * model_E_g_2.areaLSTM.Woigf  + (1-p) * g_Woigf.^2 ;
    model_E_g_2.proMLP.theta0 = p * model_E_g_2.proMLP.theta0+ (1-p) * g_theta0.^2;
    
    RMS_dx_Woigf = sqrt(model_E_dx_2.areaLSTM.Woigf+EPS);
    RMS_dx_theta0 = sqrt(model_E_dx_2.proMLP.theta0+EPS);
    
    RMS_g_Woigf = sqrt(model_E_g_2.areaLSTM.Woigf+EPS);
    RMS_g_theta0 = sqrt(model_E_g_2.proMLP.theta0+EPS);
    
    t_Woigf = RMS_dx_Woigf ./ RMS_g_Woigf;
    t_theta0 = RMS_dx_theta0 ./ RMS_g_theta0;
    
    dx_Woigf =  2e-1* t_Woigf .* g_Woigf; 
    dx_theta0 = 2e-1*  t_theta0 .* g_theta0;
    
    model_E_dx_2.areaLSTM.Woigf = p * model_E_dx_2.areaLSTM.Woigf  + (1-p) * dx_Woigf.^2 ;
    model_E_dx_2.proMLP.theta0 = p * model_E_dx_2.proMLP.theta0+ (1-p) * dx_theta0.^2;
    
    model.areaLSTM.Woigf = model.areaLSTM.Woigf + dx_Woigf;
    model.proMLP.theta0 = model.proMLP.theta0 + dx_theta0;  
 
else
    
 
model.areaLSTM.Woigf = model.areaLSTM.Woigf + epsilon.* ( modelB.areaLSTM.dWoigf -lambda * model.areaLSTM.Woigf ) ; 
model.proMLP.theta0 = model.proMLP.theta0 + epsilon.* ( modelB.proMLP.dtheta0 - lambda * model.proMLP.theta0 ) ;

end
   
end