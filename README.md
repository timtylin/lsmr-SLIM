## LSMR-SLIM: SLIM extensions of LSMR
Copyright (c) 2010-2011, David C.L. Fong, SOL, Stanford University  
Copyright (c) 2013, Tim T.Y. Lin, SLIM, University of British Columbia  
All rights reserved.

### Purpose
[LSMR](http://www.stanford.edu/group/SOL/software/lsmr.html) is a least-squares solver that ensures monotonic decrease in the norm of the gradient of each iteration.

The main purpose of the SLIM fork of LSMR is to ensure compatibility with [SPOT](http://www.cs.ubc.ca/labs/scl/spot/) and [pSPOT](https://github.com/slimgroup/pSPOT) as well as the `distributed` array type introduced by the MATLAB [Parallel Computing Toolbox](http://www.mathworks.com/products/parallel-computing/parallel/distarrays.html). This means that a standard call to LSMR `x = lsmr(A,b)` should accept `A` of the following types:

- numeric
- `distributed` array
- function handle (see help text of `lsmr.m`)
- `SPOT` object
- `pSPOT` object
    
As well as `b` of the following types:  

- numeric
- `distributed` array

Note that, if any of `A` or `b` is of type `distrubted`, the resulting `x` will also be of type `distributed`.

### Note: warm-starting with a pervious estimate of the solution
Currently LSMR does not accept inputs of `x` as the initial solution. Any warm-start procedure involving LSMR must be done externally, as described in the help text of the FROTRAN version of LSMR:

    If some initial estimate x0 is known and if damp = 0,
    one could proceed as follows:

    1. Compute a residual vector     r0 = b - A*x0.
    2. Use LSMR to solve the system  A*dx = r0.
    3. Add the correction dx to obtain a final solution x = x0 + dx.

    This requires that x0 be available before and after the call
    to LSMR.  To judge the benefits, suppose LSMR takes k1 iterations
    to solve A*x = b and k2 iterations to solve A*dx = r0.
    If x0 is "good", norm(r0) will be smaller than norm(b).
    If the same stopping tolerances atol and btol are used for each
    system, k1 and k2 will be similar, but the final solution x0 + dx
    should be more accurate.  The only way to reduce the total work
    is to use a larger stopping tolerance for the second system.
    If some value btol is suitable for A*x = b, the larger value
    btol*norm(b)/norm(r0)  should be suitable for A*dx = r0.

