function [err, max_err, near] = check_err(pred, ratings)

err = sqrt(mean((pred(:)- ratings(:)).^2));
max_err = max(abs(pred(:) - ratings(:)));
near = mean(abs(pred(:)-ratings(:)) < 5);

fprintf('%f & %f & %f \\\\ \\hline \n', err, max_err, near);
fprintf('RMSE: %f, MAX: %f, FRAC WITHIN 1: %f \n', err, max_err, near);
