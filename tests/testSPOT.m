% Tests for SPOT compatibility
function test_suite = testSPOT
initTestSuite;

    % BEGIN INITIALIZATION

    function opt = setup
        % Make sure environment is pristine
        clear all
        clear functions
        
        % Make sure LSMR exists in path
        addpath('..')
        
        % Fix random generator for repeatable experiments
        defaultStream = RandStream.getDefaultStream;
        savedState = defaultStream.State;
        RandStream.setDefaultStream(RandStream('mt19937ar','seed',8888));
        
        % Make test cases
        m = 1000;
        n = 300;
        
        A = opMatrix(randn(m,n));
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
        
        % Remove the test LSMR from path
        rmpath('..')
        clear all
        clear functions
    


    % BEGIN TESTS
    
    function testSPOTworks_LS(opt)
    
        x = lsmr(opt.A,opt.b,[],[],[],[],[],[],opt.show_logs);
        
        assertElementsAlmostEqual(x, opt.x, 'absolute', opt.recov_tol);
        
    function testSPOTworks_dampedLS(opt)

        x = lsmr(opt.A,opt.b,10,[],[],[],[],[],opt.show_logs);
    



