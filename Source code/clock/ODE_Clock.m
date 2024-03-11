function dydt = ODE_Clock(t, y, par_clock)
    
    dydt = zeros(12, 1);   
    
    % variables of clock model
    y_cell = num2cell(y);
    [Per, Cry, Rev, Ror, Bmal1, PER, CRY, REV, ROR, ...
        BMAL1, PER_CRY, CLOCK_BMAL1] = deal(y_cell{:});
    
    % parameters of clock model
    % mRNA and protein degradation rate constants (in h^-1)
    par_clock1 = num2cell(par_clock(1:12));
    [dm_per, dm_cry, dm_rev, dm_ror, dm_bmal, dp_per, ...
        dp_cry, dp_rev, dp_ror, dp_bmal, d_pc, d_cb] = deal(par_clock1{:});
    
    % maximal transcription rates (in nmol l^-1 h^-1)
    par_clock2 = num2cell(par_clock(13:17));
    [vmax_per, vmax_cry, vmax_rev, vmax_ror, vmax_bmal] = deal(par_clock2{:});
    
    % activation ratios (demensionless)
    par_clock3 = num2cell(par_clock(18:22));
    [fold_per, fold_cry, fold_rev, fold_ror, fold_bmal] = deal(par_clock3{:});
    
    % regulation thresholds (in nmol/l)
    par_clock4 = num2cell(par_clock(23:33));
    [Ka_per_cb, Ki_per_pc, Ka_cry_cb, Ki_cry_pc, Ki_cry_rev, Ka_rev_cb, ...
        Ki_rev_pc, Ka_ror_cb, Ki_ror_pc, Ka_bmal_ror, Ki_bmal_rev] = deal(par_clock4{:});
    
    % hill coefficients (dimensionless)
    par_clock5 = num2cell(par_clock(34:44));
    [hill_per_cb, hill_per_pc, hill_cry_cb, hill_cry_pc, ...
        hill_cry_rev, hill_rev_cb, hill_rev_pc, hill_ror_cb, ...
        hill_ror_pc, hill_bmal_ror, hill_bmal_rev] = deal(par_clock5{:});
    
    % translation rates (in molecules per hour per mRNA)
    par_clock6 = num2cell(par_clock(45:49));
    [kp_per, kp_cry, kp_rev, kp_ror, kp_bmal] = deal(par_clock6{:});
    
    % complexation kinetic rates
    par_clock7 = num2cell(par_clock(50:53));
    [kass_cb, kass_pc, kdiss_cb, kdiss_pc] = deal(par_clock7{:});
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % equations of clock model
    dydt(1) = -1 * dm_per * Per + vmax_per * ( ...
        1 + fold_per * power(CLOCK_BMAL1 / Ka_per_cb, hill_per_cb)) / ( ...
            1 + power(CLOCK_BMAL1 / Ka_per_cb, hill_per_cb) * ...
            (1 + power(PER_CRY / Ki_per_pc, hill_per_pc)));

    dydt(2) = -1 * dm_cry * Cry + 1 / ( ...
        1 + power(REV / Ki_cry_rev, hill_cry_rev)) * ( ...
            vmax_cry * ...
            (1 + fold_cry * power(CLOCK_BMAL1 / Ka_cry_cb, hill_cry_cb))) / ( ...
                1 + power(CLOCK_BMAL1 / Ka_cry_cb, hill_cry_cb) * ...
                (1 + power(PER_CRY / Ki_cry_pc, hill_cry_pc)));

    dydt(3) = -1 * dm_rev * Rev + vmax_rev * ( ...
        1 + fold_rev * power(CLOCK_BMAL1 / Ka_rev_cb, hill_rev_cb)) / ( ...
            1 + power(CLOCK_BMAL1 / Ka_rev_cb, hill_rev_cb) * ...
            (1 + power(PER_CRY / Ki_rev_pc, hill_rev_pc)));

    dydt(4) = -1 * dm_ror * Ror + vmax_ror * ( ...
        1 + fold_ror * power(CLOCK_BMAL1 / Ka_ror_cb, hill_ror_cb)) / ( ...
            1 + power(CLOCK_BMAL1 / Ka_ror_cb, hill_ror_cb) * ...
            (1 + power(PER_CRY / Ki_ror_pc, hill_ror_pc)));
    
    dydt(5) = -1 * dm_bmal * Bmal1 + vmax_bmal * ( ...
        1 + fold_bmal * power(ROR / Ka_bmal_ror, hill_bmal_ror)) / ( ...
            1 + power(REV / Ki_bmal_rev, hill_bmal_rev) + ...
            power(ROR / Ka_bmal_ror, hill_bmal_ror));

    dydt(6) = -1 * dp_per * PER + kp_per * Per - ( ...
        kass_pc * PER * CRY - kdiss_pc * PER_CRY);

    dydt(7) = -1 * dp_cry * CRY + kp_cry * Cry - ...
        (kass_pc * PER * CRY - kdiss_pc * PER_CRY);

    dydt(8) = -1 * dp_rev * REV + kp_rev * Rev;

    dydt(9) = -1 * dp_ror * ROR + kp_ror * Ror;

    dydt(10) = -1 * dp_bmal * BMAL1 + kp_bmal * Bmal1 - ...
        (kass_cb * BMAL1 - kdiss_cb * CLOCK_BMAL1);

    dydt(11) = kass_pc * PER * CRY - kdiss_pc * PER_CRY - d_pc * PER_CRY;

    dydt(12) = kass_cb * BMAL1 - kdiss_cb * CLOCK_BMAL1 - d_cb * CLOCK_BMAL1;
    
end