

objclass = h5read('objclass_filtered.h5', '/exported_data');
objclass = permute(objclass, [2, 1, 3]);

class_sum = zeros(size(objclass, 1), size(objclass, 3));
class_count = zeros(size(objclass, 1), size(objclass, 3));

window = 15;
for frame = 1:size(objclass, 3)
    [I,J] = find(objclass(:,:,frame) > 0);
    
    for ii = 1:length(I)
        ind = max(I(ii) - window, 1):min(I(ii) + window, size(objclass, 1));
        class_sum(ind, frame) = class_sum(ind, frame) + double(objclass(I(ii), J(ii), frame));
        class_count(ind, frame) = class_count(ind, frame) + 1;
    end

    if mod(frame, 1) == 0
        fprintf('%d/%d\n', frame, size(objclass, 3));
    end
end

class_mean = class_sum ./ class_count;
class_mean(isnan(class_mean)) = 0;

XY_res = 0.3787880;
T_res = 6 / 60;

AP_axis = (0:(size(class_mean, 1)-1)) * XY_res;
time = (0:(size(class_mean, 2)-1)) * T_res;

figure;
imagesc(time, AP_axis, class_mean);
clim([1, 2]);
set(gca, 'FontSize', 14, 'FontWeight', 'bold');

xlabel('Time (min)');
ylabel('AP Axis (\mu m)', 'Interpreter', 'tex');