# MATLAB/Octave Implementation of ITU-R M.2135-1 Propagation Model

This code repository contains a MATLAB/Octave software implementation of path loss model from Report [ITU-R M.2135-1](https://www.itu.int/dms_pub/itu-r/opb/rep/R-REP-M.2135-1-2009-PDF-E.pdf) (Tables A1-2 and A1-3).  Note that only outdoor scenarios UMa (urban macro), SMa (suburban macro), and RMa (rural macro) are implemented  in this version. The model supports LoS and NLoS propagation conditions as well as the LoS probabilities. 

The following table describes the structure of the folder `./matlab/` containing the MATLAB/Octave implementation of the M.2135 model.

| File/Folder               | Description                                                         |
|----------------------------|---------------------------------------------------------------------|
|`tl_m2135.m`                | MATLAB/Octave implementation of propagation model in ITU-R M.2135-1        |
|`m2135_SMa.m`          | Outdoor SMa and RMa scenario         |
|`m2135_UMa.m`          | Outdoor UMa scenario         |


Function call
~~~ 
L = tl_m2135(f, d, hbs, hms, W, h, env, lostype, variations);
~~~

## Required input arguments of function `tl_m2135`

| Variable          | Type   | Units | Limits       | Description  |
|-------------------|--------|-------|--------------|--------------|
| `f`               | double | GHz   | 2 (0.45 for RURAL) ≤ `f`≤ 6   | Frequency | 
| `d`               | double | m   | 10 ≤ `d` ≤ 5000 (10000 for RURAL)   | 3D direct distance between Tx and Rx stations  |
| `hbs`               | double | m   | 10 ≤ `hbs` ≤ 150  | Base Station antenna height |
| `hms`               | double | m   | 1≤ `hms` ≤ 10   | Mobile station antenna height |
| `W`               | double | m   |   5 ≤ `W` ≤ 50 | Average street width |
| `h`               | double | m   |  5 ≤ `h` ≤ 50  | Average building height |
| `env`      | string |    | 'RURAL', 'SUBURBAN', 'URBAN' | Environment type |
| `lostype`      | int |     |  | 1 - LoS <br> 2 - NLoS <br> 3 - LoS Probability |
| `variations`      | boolean |     |  | Set to `true` to compute variation in path loss (shadow fading)|


## Output ##

| Variable   | Type   | Units | Description |
|------------|--------|-------|-------------|
| `L`    | double | dB    | Basic transmission loss |



## References

* [ITU-R M.2135-1](https://www.itu.int/dms_pub/itu-r/opb/rep/R-REP-M.2135-1-2009-PDF-E.pdf)
