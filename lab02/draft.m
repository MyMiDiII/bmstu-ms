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
