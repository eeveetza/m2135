function [pl, sigma] = m2135_UMa( f, d, hbs, hms, W, h, los)
%m2135_UMa computes path loss for urban macro cell
%   This function computes path loss according to ITU-R M.2135-1 model for
%   urban macro cell (UMa)
% Input parameters:
%     f       -   Frequency (GHz)
%     d       -   Tx-Rx distance (m) - range (10, 5000) m
%     hbs     -   base station height (m) - typical 25 m - range (10, 150) m
%     hms     -   mobile station height (m) - typical 1.5 m - range (1, 10) m
%     W       -   street width - typical 20 m - range (5, 50) m
%     h       -   avg. building height - typical 20 m - range (5, 50) m
%     los     -   flag: 1 = Line of Sight, 0 = Non Line of Sight
% Output parameters:
%     pl      - path loss
%     sigma   - standard deviation


% Numbers refer to Report ITU-R M.2135-1

%     Rev   Date        Author                          Description
%     -------------------------------------------------------------------------------
%     v0    06JUN18     Ivica Stevanovic, OFCOM         Initial version
%     v1    28OCT18     Ivica Stevanovic, OFCOM         corrected NLOS equation (hms instead of hbs in the second last term)

% check the parameter values and issue warnings

if (f < 2 || f > 6)
    warning('ITU-R M.2135 UMa model is valid for the frequency range [2, 6] GHz.');
end

if (d < 10 || d > 5000)
    warning('Tx-Rx distance should be within the range [10, 5000 m].');
    
end

if (h < 5 || h > 50)
    warning('ITU-R M.2135 UMa model is valid for the street width range [5, 50] m.');
end

if (W < 5 || W > 50)
    warning('ITU-R M.2135 UMa model is valid for the street width range [5, 50] m.');
end

if (hms < 1 || hms > 10)
    warning('ITU-R M.2135 UMa model is valid for the mobile station height range [1, 10] m.');
end

if (hbs < 10 || hbs > 150)
    warning('ITU-R M.2135 UMa model is valid for the base station height range [10, 150] m.');
end


if (los == 1)
        
    % make sure antenna heights are larger than 1 m
    if (hbs <= 1 || hms <= 1)
        error('Antenna heights for ITU-R M.2135-1 UMa must be larger than 1 m.');
    end
    % compute the effective antenna heights
    hbs1 = hbs - 1.0;
    hms1 = hms - 1.0;
    % compute the break point
    
    dbp = 4 * (hbs1) * (hms1) * f * 10.0 / 3.0; % computed accroding to the note 1) in Table A1-2
    
    if (d < dbp)
        sigma = 4;
        A = 22;
        B = 28;
        C = 20;
        
        pl = A*log10(d) + B + C*log10(f);
        
    else
        sigma = 4;
        
        pl = 40.0*log10(d) + 7.8 - 18.0*log10(hbs1)-18.0*log10(hms1) + 2.0*log10(f);
        
    end
    
else % NLOS
    
    sigma = 6;
    
    pl = 161.04 - 7.1*log10(W) + 7.5*log10(h) - (24.37 - 3.7*(h/hbs).^2)*log10(hbs) + ...
        (43.42 - 3.1*log10(hbs))*(log10(d)-3) + 20*log10(f) - (3.2*(log10(11.75*hms)).^2 - 4.97);
    
end

out(1) = pl;
out(2) = sigma;

return
end

