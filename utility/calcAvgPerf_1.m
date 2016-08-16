%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate average performance, the micro average will be calculated.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Precision]=calcAvgPerf_1(P_points,C, size)

CUTOFF=2;
SAMPLE=20;
mean=zeros(1,SAMPLE);

for j = 1:SAMPLE
    valid = 0;
    for i = 1:size
        % only consider classes of a valid size and only average over real interpolated results this means avoid classes between precision 1 and 1/(classsize-1)
        if (C(i) < CUTOFF || C(i) < SAMPLE/j)
            continue;
        end
        [tmp] = interpolatePerf(P_points(i,:), C(i), j/SAMPLE); %
        mean(1,j)=mean(1,j)+tmp;
        valid=valid+1;
    end
    if (valid > 0)
        mean(1,j)=mean(1,j)/valid;
    end
end
Precision=mean;

