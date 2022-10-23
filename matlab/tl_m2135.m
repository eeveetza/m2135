function L = tl_m2135(f, d, h1, h2, W, h, env, lostype, variations)
%tl_m2135 computes path loss for path loss according to ITU-R M.2135 model
%
% Input parameters:
%     f       -   Frequency (GHz)
%     d       -   Tx-Rx distance (m) - range (10, 5000) m
%     h1      -   base station height (m) - typical 35 m - range (10, 150) m
%     h2      -   mobile station height (m) - typical 1.5 m - range (1, 10) m
%     W       -   street width - typical 20 m - range (5, 50) m
%     h       -   avg. building height - typical 5 m - range (5, 50) m
%     env     -   'RURAL', 'SUBURBAN', or 'URBAN'
%     lostype -   flag: 1 = Line of Sight, 2 = Non Line of Sight, 3 = LoS probabilities
%     variations - false: function returns median value of path loss
%                  true:  function returns Gaussian random value of path loss
% Output parameters:
%     L       - path loss (median value for variations = false,
%                          Gaussian random variable for variations = true)


% Numbers refer to Report ITU-R M.2135-1

%     Rev   Date        Author                          Description
%     -------------------------------------------------------------------------------
%     v0    23OCT22     Ivica Stevanovic, OFCOM         Initial version

L = 0.0;
StdDev = 0.0;

hbs = h1;
hms = h2;

if (h1 < h2)
    hbs = h2;
    hms = h1;
end

fmin = 2;
fmax = 6;


dmin = 10;
dmax = 5000;

hbsmin = 10.0;
hmsmin = 1.0;

hbsmax = 150;
hmsmax = 10.0;

if (~strcmp(env, 'RURAL') && ~strcmp(env,'SUBURBAN') && ~strcmp(env,'URBAN'))
    error('The parameter env must be either ''RURAL'', ''SUBURBAN'' or ''URBAN'' ');
end

if (lostype ~=1 && lostype ~=2 && lostype ~=3)
    error('The parameter lostype must be either 1, 2, or 3 designating LoS condition, NLoS condition, or LoS probabilities, respectively.');
end

if ~islogical(variations)
    error('The parameter variations must be boolean true or false.');
end

if (strcmp(env, 'RURAL'))
    fmin = 0.450;
end

if (strcmp(env, 'RURAL') && (lostype == 1))
    dmax = 10000;
end


if (f < fmin || f > fmax)
    warning(['The chosen model is valid for frequencies in the range [' num2str(fmin) ', ' num2str(fmax)  '] GHz']);
end

if (hbs < hbsmin || hbs > hbsmax)

    warning(['The chosen model is valid for base station heights in the range ['  num2str(hbsmin)  ', '  num2str(hbsmax)  '] m']);

end

if (d < dmin || d > dmax)
    warning(['The chosen model is valid for distances in the range ['  num2str(dmin)  ', '  num2str(dmax)  '] m']);
end

if (hms <= hmsmin || hms > hmsmax)
    warning(['The chosen model is valid for mobile station heights in the range ['  num2str(hmsmin)  ', '  num2str(hmsmax)  '] m']);

end

if (W < 5 || W > 50)
    warning('The model is valid for street widths in the range [5, 50] m');
end


if (h < 5 || h > 50)
    warning('The model is valid for average building heights in the range [5, 50] m');
end


prob = 1; % probability that the path is LOS

switch (lostype)
    case 2
        prob = 0;

    case 3
        switch (env)
            case 'URBAN'
                prob = min(18.0/d,1.0)*(1-10.^(-d/63.0)) + 10.^(-d/63.0);

            case 'SUBURBAN'
                if (d > 10)
                    prob = 10.^(-(d-10)/200);
                end

            case 'RURAL'
                if (d > 10)
                    prob = 10.^(-(d-10)/1000.0);
                end
        end
end


switch (lostype)
    case 1
        switch (env)
            case 'URBAN'
                [L, StdDev] = m2135_UMa(f, d, hbs, hms, W, h, true);


                if (variations)
                    std = StdDev* randn;

                    L = L + std;
                end

            otherwise % SMa or RMa
                [L, StdDev] =m2135_SMa(f, d, hbs, hms, W, h, true);

                if (variations)
                    std = StdDev* randn;

                    L = L + std;
                end
        end

    case 2
        switch (env)
            case 'URBAN'
                [L, StdDev] =m2135_UMa(f, d, hbs, hms, W, h, false);


                if (variations)
                    std = StdDev* randn;

                    L = L + std;
                end

            otherwise % SMa or RMa
                [L, StdDev] =m2135_SMa(f, d, hbs, hms, W, h, false);

                if (variations)
                    std = StdDev* randn;

                    L = L + std;
                end
        end

    case 3
        switch (env)
            case 'URBAN'
                [L1, StdDev1] =m2135_UMa(f, d, hbs, hms, W, h, true);

                [L2, StdDev2] =m2135_UMa(f, d, hbs, hms, W, h, false);

                if (variations)
                    std1 = StdDev1 * randn;
                    std2 = StdDev2 * randn;
                    L1 = L1 + std1;
                    L2 = L2 + std2;
                end

                %L = prob*L1 + (1-prob)*L2;
                p_trial = rand;
                if (p_trial < prob)
                    L = L1; %LOS
                else
                    L = L2; %NLOS
                end


            otherwise %SMa or RMa
                [L1, StdDev1] = m2135_SMa(f, d, hbs, hms, W, h, true);

                [L2, StdDev2] = m2135_SMa(f, d, hbs, hms, W, h, false);

                if (variations)
                    std1 = StdDev1 * randn;
                    std2 = StdDev2 * randn;
                    L1 = L1 + std1;
                    L2 = L2 + std2;
                end

                %L = prob*L1 + (1-prob)*L2;
                p_trial = rand;
                if (p_trial < prob)
                    L = L1; %LOS
                else
                    L = L2; %NLOS
                end
        end
end

return
end
