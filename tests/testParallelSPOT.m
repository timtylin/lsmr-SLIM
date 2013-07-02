% Tests for Matlab PCT and pSPOT compatibility
function test_suite = testParallelSPOT
initTestSuite;

    % BEGIN INITIALIZATION

    function opt = setup
        % Make sure environment is pristine
        clear all
        clear functions
        
        % Make sure LSMR exists in path
        addpath('..')
        
        % Open matlabpool
        matlabpool local 4
        
        % Fix random generator for repeatable experiments
        defaultStream = RandStream.getDefaultStream;
        savedState = defaultStream.State;
        RandStream.setDefaultStream(RandStream('mt19937ar','seed',8888));
        
        % Make test cases
        m = 1000;
        n = 300;
        
        A = randn(m,n);
        x = randn(n,1);
        b = A*x;
        
        % Set sparse recovery element-wise relative tolerance
        recov_tol = 1e-3;
        
        % Toggle whether to show the LSMR logs
        show_logs = false;
        
        % Inject options into test cases
        opt.A = A;
        opt.b = b;
        opt.x = x;
        opt.recov_tol = recov_tol;
        opt.show_logs = show_logs;
        opt.savedState = savedState;

    function teardown(opt)
        % Restore random stream and restore variables
        defaultStream.State = opt.savedState;
        clear opt
        
        % clear workers
        matlabpool close
        
        % Remove the test LSMR from path
        rmpath('..')
        clear all
        clear functions
    


    % BEGIN TESTS
    
    function testParallelBworks(opt)
        
        b = distributed(opt.b);
        x = lsmr(opt.A,b,[],[],[],[],[],[],opt.show_logs);
        
        assertElementsAlmostEqual(undist(x), opt.x, 'absolute', opt.recov_tol);
        
    function testParallelBworks_dampedLS(opt)

        b = distributed(opt.b);
        x = lsmr(opt.A,b,10,[],[],[],[],[],opt.show_logs);
        
    function testParallelBworks_dampedLS_showLog(opt)

        b = distributed(opt.b);
        x = lsmr(opt.A,b,10,[],[],[],[],[],true);
        
    function testParallelAworks(opt)
    
        A = distributed(opt.A);
        x = lsmr(A,opt.b,[],[],[],[],[],[],opt.show_logs);
        
        assertElementsAlmostEqual(undist(x), opt.x, 'absolute', opt.recov_tol);
    
    function testParallelAworks_dampedLS(opt)
        
        A = distributed(opt.A);
        x = lsmr(A,opt.b,10,[],[],[],[],[],opt.show_logs);
        
    function testParallelAworks_dampedLS_showLog(opt)
    
        A = distributed(opt.A);
        x = lsmr(A,opt.b,10,[],[],[],[],[],1);



