function fm = feedback_update(fm,i,dalpha,dbeta)

        fm{i}.alpha = (1-fm{i}.gamma_rate) * fm{i}.alpha + fm{i}.gamma_rate * dalpha;
        fm{i}.beta = (1-fm{i}.gamma_rate) * fm{i}.beta +  fm{i}.gamma_rate  * dbeta;
end