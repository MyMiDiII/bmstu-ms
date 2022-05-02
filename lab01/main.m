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
     
fprintf('Задание а\n');

Mmax = max(x);
Mmin = min(x);

fprintf('M_max = %6.3f\n', Mmax);
fprintf('M_min = %6.3f\n', Mmin);

fprintf('\nЗадание б\n');

R = Mmax - Mmin;

fprintf('R = %5.3f\n', R)

fprintf('\nЗадание в\n');

mu = sum(x) / n;
sqrS = sum((x - mu) .^ 2) / (n - 1);

fprintf('mu  = %5.3f\n', mu);
fprintf('S^2 = %5.3f\n', sqrS);

fprintf('\nЗадание г\n');

m = floor(log2(n)) + 2;

limit_points = linspace(Mmin, Mmax, m + 1);

fprintf('m = %d\n', m);

nums = zeros(m, 1);

for i = 1:m
  left = limit_points(i);
  right = limit_points(i + 1);
  
  for j = 1:n
    if x(j) >= left && x(j) < right
      nums(i)++;
    endif
  endfor
  
endfor

nums(m)++;

for i = 1:m
  fprintf('В интервале [%6.3f, %6.3f%c %2d элементов.\n', limit_points(i),...
         limit_points(i + 1), ifelse(i == m, ']', ')'), nums(i));
endfor

fprintf('\nЗадание д\n');
fprintf('График в окне "Задание д"\n');

centers = zeros(m, 1);
f_emp   = zeros(m, 1);

Delta = (Mmax - Mmin) / m;

for i = 1:m
    centers(i) = (limit_points(i) + limit_points(i + 1)) / 2;
    f_emp(i)   = nums(i) / (n * Delta);
endfor

sigma = sqrt(sqrS);
x_vals = (Mmin:1e-3:Mmax);
f_theor = normpdf(x_vals, mu, sigma);

h = figure();
set(h,'numbertitle','off')
set(h, 'name', 'Задание д');
hold on;
bar(centers, f_emp, 1, 'facecolor', 'r');
plot(x_vals, f_theor, 'LineWidth', 2, 'color', 'b');

fprintf('\nЗадание е\n');
fprintf('График в окне "Задание е"\n');

F_theor = normcdf(x_vals, mu, sigma);

g = figure();
set(g,'numbertitle','off')
set(g, 'name', 'Задание е');
plot(x_vals, F_theor, 'LineWidth', 10);

waitfor(h);
waitfor(g);
