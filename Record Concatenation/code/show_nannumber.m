function [ nannumber ] = show_nannumber( patient_feature )
%NAN number of patient
SIZE=size(patient_feature);
nannumber=zeros(1,SIZE(2));
for n=1:SIZE(2)
    for m=1:SIZE(1)
        if isnan(patient_feature(m,n))
            nannumber(n)=nannumber(n)+1;
        end
    end
end

end

