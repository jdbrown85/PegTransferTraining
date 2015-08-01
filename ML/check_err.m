<<<<<<< HEAD
function [err, max_err, near] = check_err(pred, ratings, threshold)
=======
function [err, max_err, near] = check_err(pred, ratings)
% Function to print current error metrics, also prints out latex to make reports
% easier.
>>>>>>> origin/master

err = sqrt(mean((pred(:)- ratings(:)).^2));
max_err = max(abs(pred(:) - ratings(:)));
near = mean(abs(pred(:)-ratings(:)) < threshold);

fprintf('%f & %f & %f \\\\ \\hline \n', err, max_err, near);
fprintf('RMSE: %f, MAX: %f, FRAC WITHIN %d: %f \n', err, max_err, threshold, near);
