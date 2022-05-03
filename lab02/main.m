pkg load statistics

x = [11.89,9.60,9.29,10.06,9.50,8.93,9.58,6.81,8.69,9.62,...
     9.01,10.59,10.50,11.53,9.94,8.84,8.91,6.90,9.76,7.09,...
     11.29,11.25,10.84,10.76,7.42,8.49,10.10,8.79,11.87,8.77,...
     9.43,12.41,9.75,8.53,9.72,9.45,7.20,9.23,8.93,9.15,...
     10.19,9.57,11.09,9.97,8.81,10.73,9.57,8.53,9.21,10.08,...
     9.10,11.03,10.10,9.47,9.72,9.60,8.21,7.78,10.21,8.99,...
     9.14,8.60,9.14,10.95,9.33,9.98,9.09,10.35,8.61,9.35,...
     10.04,7.85,9.64,9.99,9.65,10.89,9.08,8.60,7.56,9.27,...
     10.33,10.09,8.51,9.86,9.24,9.63,8.67,8.85,11.57,9.85,...
     9.27,9.69,10.90,8.84,11.10,8.19,9.26,9.93,10.15,8.42,...
     9.36,9.93,9.11,9.07,7.21,8.22,9.08,8.88,8.71,9.93,...
     12.04,10.41,10.80,7.17,9.00,9.46,10.42,10.43,8.38,9.01];

n = length(x);

cnt = 0;

while !cnt
    fprintf('Введите gamma: ');
    [gamma, cnt] = scanf('%f', 1);

    if !cnt || gamma > 1 || gamma < 0
        tmp = scanf('%s', 'C');
        fprintf('%d\n', cnt);
        fprintf('gamma in [0, 1]\n');
        cnt = 0;
    endif
endwhile
     
fprintf('gamma = %.2f\n', gamma);

fprintf('\nЗадание 1.а/2\n');

function res = sample_mean(x)
    n = length(x);
    res = sum(x) / n;
endfunction

function res = unbiased_sample_variance(x)
    n = length(x);
    mu = sample_mean(x);

    res = sum((x - mu) .^ 2) / (n - 1);
endfunction

mu = sample_mean(x);
sqrS = unbiased_sample_variance(x);

fprintf('mu  = %5.4f\n', mu);
fprintf('S^2 = %5.4f\n', sqrS);

fprintf('\nЗадание 1.б\n');

function [lower_bound, upper_bound] = get_mx_confidence(x, gamma)
    sm = sample_mean(x);
    s  = sqrt(unbiased_sample_variance(x));
    n  = length(x);
    t  = tinv((1 + gamma) / 2, n - 1);

    lower_bound = sm - s * t / sqrt(n);
    upper_bound = sm + s * t / sqrt(n);
endfunction

[lower_mu, upper_mu] = get_mx_confidence(x, gamma);

fprintf('%.2f-доверительный интервал для математического ожидания\n', gamma);
fprintf('(%5.6f, %5.6f)\n', lower_mu, upper_mu);

fprintf('\nЗадание 1.в\n');

function [lower_bound, upper_bound] = get_dx_confidence(x, gamma)
    s2  = unbiased_sample_variance(x);
    n  = length(x);
    t_low  = chi2inv((1 + gamma) / 2, n - 1);
    t_up  = chi2inv((1 - gamma) / 2, n - 1);

    lower_bound = (n - 1) * s2 / t_low;
    upper_bound = (n - 1) * s2 / t_up;
endfunction

[lower_sigma2, upper_sigma2] = get_dx_confidence(x, gamma);

fprintf('%.2f-доверительный интервал для дисперсии\n', gamma);
fprintf('(%5.6f, %5.6f)\n', lower_sigma2, upper_sigma2);


fprintf('\nЗадание 3.a\n');
fprintf('График в отдельном окне\n');

hat_mu_x_N = zeros(n, 1) + mu;
hat_mu_x_n = zeros(n, 1);
low_mu = zeros(n, 1);
up_mu  = zeros(n, 1);

for i=1:n
    cur_x = x(1:i);
    hat_mu_x_n(i) = sample_mean(cur_x);
    [low_mu(i), up_mu(i)] = get_mx_confidence(cur_x, gamma);
endfor

h = figure();
set(h, 'numbertitle', 'off', 'name', 'Задание 3.а');
hold on;
plot(1:n, hat_mu_x_N, 'color', 'g', 'linewidth', 2);
plot(1:n, hat_mu_x_n, 'color', 'b', 'linewidth', 2);
plot(1:n, low_mu,     'color', 'm', 'linewidth', 2);
plot(1:n, up_mu,      'color', 'r', 'linewidth', 2);
l = legend('y = \mu_{hat}(x⃗_N)', 'y = \mu_{hat}(x⃗_n)',
           'y = \mu_{low}(x⃗_n)', 'y = \mu_{up}(x⃗_n)');
set(l, 'interpreter', 'tex', 'fontsize', 16);
grid;

fprintf('\nЗадание 3.б\n');
fprintf('График в отдельном окне\n');

begin = 4;

S_x_N = zeros(n - begin + 1, 1) + sqrS;
S_x_n = zeros(n - begin + 1, 1);
low_sig2 = zeros(n - begin + 1, 1);
up_sig2  = zeros(n - begin + 1, 1);

for i=begin:n
    cur_x = x(1:i);
    S_x_n(i-begin+1) = unbiased_sample_variance(cur_x);
    [low_sig2(i-begin+1), up_sig2(i-begin+1)] = get_dx_confidence(cur_x, gamma);
endfor

g = figure();
set(g, 'numbertitle', 'off', 'name', 'Задание 3.б');
hold on;
plot(1:n-begin+1, S_x_N,    'color', 'g', 'linewidth', 2);
plot(1:n-begin+1, S_x_n,    'color', 'b', 'linewidth', 2);
plot(1:n-begin+1, low_sig2, 'color', 'm', 'linewidth', 2);
plot(1:n-begin+1, up_sig2,  'color', 'r', 'linewidth', 2);
l = legend('z = S^2(x⃗_N)', 'z = S^2(x⃗_n)',
           'z = \sigma^2_{low}(x⃗_n)', 'z = \sigma^2_{up}(x⃗_n)');
set(l, 'interpreter', 'tex', 'fontsize', 16);
grid;

waitfor(h);
waitfor(g);
