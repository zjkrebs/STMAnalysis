% do the radio average for a 2D matrix
% The origin is set at the center
% output res is a 2D array 
% res(j,1) is the radio-distance (j_max is set by the length)
% res(j,2) is the radio-average value

function res = radio_average_yuanbo(input, length)

[nx, ny] = size(input);

% Setup the k axis
kn = length;
kx_Max = max(nx); ky_Max = max(ny);
k_Max = sqrt(kx_Max^2 + ky_Max^2)/2;
k_Step = k_Max/kn;

res_T = zeros(kn,3);
for j=1:kn,
    res_T(j,1) = k_Step*(j-0.5);
end

% Find total values of res_T for each of the k
% kind of like making a histogram 
center_kx = ((kx_Max + 1)/2);
center_ky = ((ky_Max + 1)/2);
for i=1:kx_Max,
    for j=1:ky_Max,
        k = sqrt((i-center_kx)^2 + (j-center_ky)^2);
        ind = int32(k/k_Step);
        if ind <= kn
            if ind == 0
                res_T(1,2) = res_T(1,2) + input(i,j);
                res_T(1,3) = res_T(1,3) + 1;
            else
                res_T(ind,2) = res_T(ind,2) + input(i,j);
                res_T(ind,3) = res_T(ind,3) + 1;
            end
        end
    end
end

% Take the average of each 'bin' to get the radio-avg value
for j=1:kn,
    if res_T(j,3) > 0
        res_T(j,2) = res_T(j,2)/res_T(j,3);
    end
end

res = res_T(:,1:2);
