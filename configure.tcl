#
# configure.tcl - SiliconSmart parameter settings
#
# This file contains the parameters settings read by SiliconSmart
#

# 
# Global configuration parameters.  These control basic aspects of
# characterization, such as the simulator and simulator options,
# job control, and basic characterization settings.
#
define_parameters default {

    # Simulator configuration parameters.
    set simulator hspice
    set simulator_cmd {hspice <input_deck> -o <listing_file>}
#    set simulator finesim
#    set simulator_cmd {finesim <input_deck> -o <listing_file>}
#    set simulation_tmpdir /tmp

    # These parameters control whether the simulator data is archived when a simulation
    # passes or fails.  The legal values are 'yes', 'compress', and 'no', corresponding
    # saving the data, saving a compressed tar file of the data, and not preserving
    # (deleting) the results.  To save disk space, set archive_condition_on_success to 'no'
    # and the tar.Z file will not be written.
    set archive_condition_on_success no
    set archive_condition_on_failure yes

    # Default simulator options.  The recommended default simulator options are
    # below.  These are only defaults and should be checked to verify that they are
    # appropriate to your process models.
    #
    # Each line must have a category ('common', 'op', 'power', 'trans', or
    # 'optimize') and an optional simulator name.  If no simulator name is
    # specified the options are applied to all simulator types.
    set simulator_options {
        "common,finesim: post=1 finesim_output=tr0 finesim_mode=spice3"
	
	"common,hspice: post=1 runlvl=5 numdgt=7 measdgt=7 acct=1 nopage"
	
	"common,spectre: compression=yes step=10ps maxstep=1ns relref=allglobal"
	"common,spectre: method=trap lteratio=4 gmin=1e-18"

	"common,msim: probe=1 accurate=1"
	
	"common,eldo: gmindc=1n gmin=1p"
	"common,eldo: itl1=500 ingold=1 numdgt=4"
	"common,eldo: measout=0 cptime=18000"
	"common,eldo: relvar=0.01"
	"op,eldo: dv=0.5 method=gear"
	"tran,eldo: brief=0 relvar=0.001"
	"optimize,eldo: lvltim=3 relvar=0.001"
	"power,eldo: method=gear"
    }

#
# Create one or more operation conditions here.  Example:
#
    create_operating_condition op_cond
    set_opc_process op_cond {
        {.include "/proj/cad/library/mosis/GF65_LPe/cmos10lpe_CDS_oa_dl064_11_20160415/models/YI-SM00030/Hspice/models/design.inc"
 }
    }
    add_opc_supplies op_cond VSS 0.0  VDD 1.2
    set_opc_temperature op_cond 0
#

    # List each of the operating conditions to be characterized here. If you are
    # characterizing for IBIS models, one operating condition must be specified
    # in ibis_typ_pvt, which will used as the nominal case for determining
    # voltage ranges.
    set active_pvts { op_cond }
    # set ibis_typ_pvt op_cond

    # Constraint settings:
    #  - constraint_mode can be one of independent, dependent,
    #    dependent-setup, or dependent-hold.
    #  - smc_degrade is only relevant when
    #  - smc_constraint_style is set to relative-degradation
    #  - smc_constraint_style can also be set to pass-fail.
    #  - path_constraint_mode controls the path-based constraint
    #    analysis and can be set to off, polish, or verify.
    #    polish will yield the same results as 'off' but
    #    faster; verify will be the same or pessimistic.
    set constraint_mode independent
    set smc_constraint_style relative-degradation
    set smc_degrade 0.1
    set path_constraint_mode off

    # Simulation resolution.
    set time_res_high 1e-12
    set time_res_low 100e-12

    # NO_CHANGE constraint control.  'nochange_variance' absolute time
    # variation in seconds. 'nochange_threshold' is a ratio of the rail
    # swing of a pin.  The default of 0.1 corresponds to a 10% change in
    # the signal level of an output pin.
    set nochange_variance [expr $time_res_high * 4.0]
    set nochange_threshold 0.1

    # Controls which supplies are measured for power consumption.
    set power_meas_supplies { VDD }

    # Switching power is computed by integrating the total current and
    # then subtracting the leakage power over the duration.  Since some
    # simulators do not produce smooth current waveforms, I/O averages
    # the current over two periods and computes two resulting power values
    # This parameter specifies a tolerance for the difference between
    # the two final values.  Larger differences mean that the calculation
    # may be inaccurate. (Default is 5%) power_stabilization_threshold_absolute
    # specifies a minimim power difference that should be considered
    # significant.  Differences below this value are ignored.  The value is
    # in Watts.
    set power_stabilization_threshold 0.05
    set power_stabilization_threshold_absolute 1e-12

    # Model publishing options.  These allow for stylistic control over the
    # resulting library, such as number of signficant digits, units, and
    # clipping of negative values.  The two parameters
    # liberty_increasing_delay_with_slew/_load control the filtering of
    # non-monotonic data.  By default, no filtering is done.  If set to a
    # floating point value, this value is the minimum delta between entries
    # in the delay tables.  Typical non-off value is 1e-15.
    set model_negative_constraints true
    set model_negative_delays true
    set model_significant_digits 4
    set model_ecsm_cin false
    set liberty_cap_unit "1pf"
    set liberty_time_unit "1ns"
    set liberty_increasing_delay_with_load off
    set liberty_increasing_delay_with_slew off
    set liberty_flavor "2003.12"


    # Load sharing parameters.  'job_scheduler' can be 'lsf' for
    # Platform Computing's Load Sharing Facility or 'standalone' to
    # run the simulations on the local machine.
    set job_scheduler standalone
    set submit_list_maxsize unlimited
    set run_list_maxsize 1
    set normal_queue lsf_queue
    set scheduler_poll_time 10    
}



#
# LIBERTY MODEL GENERATION PARAMETERS
#

# Parameters that appear in the generated Liberty model.
define_parameters liberty_model {

    # SiliconSmart IO currently only generates non-linear delay
    # lookup models (NLDM).
    set delay_model "table_lookup"

    # Other default values.
    set default_fanout_load 1.0
    set default_inout_pin_cap 1.0
    set default_input_pin_cap 1.0
    set default_output_pin_cap 0.0
    set default_cell_leakage_power 0.0
    set default_leakage_power_density  0.0
    
    # Slew Thresholds -
    #
    # These parameters specify the lower and upper slew measurement
    # points in percentage of the rail voltages.  The values are
    # copied into the generated Liberty model.
    #
    # NOTE: These parameters do NOT affect the actual measurement
    # points used in characterization.  In general, these thresholds
    # should match  the parameters "logic_low_threshold" and
    # "logic_high_threshold" in the appropriate pintype block.
    set slew_lower_threshold_pct_rise  10.0
    set slew_lower_threshold_pct_fall  10.0
    set slew_upper_threshold_pct_rise  90.0
    set slew_upper_threshold_pct_fall  90.0

    # Input/output Delay Thresholds -
    #
    # These parameters specify the thresholds used for delay
    # measurements in percentage of the rail voltages.  The values
    # are copied into the generated Liberty model.
    #
    # NOTE: These parameters do NOT affect the actual measurement
    # points used in characterization.  In general, these thresholds
    # should match the parameter "prop_delay_level" specified in
    # the appropriate pintype block.
    set input_threshold_pct_fall        50.0
    set output_threshold_pct_fall       50.0 
    set input_threshold_pct_rise        50.0 
    set output_threshold_pct_rise       50.0 
    
    # Add any other parameters you would like to appear in the
    # Liberty model.
}



# Validation parameter.  This parameter block provides control over the
# validiation tools.
define_parameters validation {
    # Liberty comparison tolerances.  These parameters control the tolerances
    # used by the compare_liberty command.  For each data type there are three
    # parameters: absolute_tolerance, relative_tolerance, and product_tolerance.
    # product_tolerance is the product of the absolute and relative differences.
    # The parameter absolute_tolerance, relative_tolerance, and
    # product_tolerance are defaults for any unspecified data-specific
    # parameters. Setting a parameter to 0 disables that comparison.
    set absolute_tolerance 0
    set relative_tolerance 0
    set product_tolerance 0

    # Basic timing data. Default corresponds to 5ps and 5%.
    set delay_absolute_tolerance 0.005
    set delay_relative_tolerance 0.05
    set slew_absolute_tolerance 0.005
    set slew_relative_tolerance 0.05
    set zen_absolute_tolerance 0.005
    set zen_relative_tolerance 0.05
    set zdis_absolute_tolerance 0.005
    set zdis_relative_tolerance 0.05

    # Constraints.  The absolute variation allowed should be
    # 2*constraint_resolution (20ps here).
    set setup_absolute_tolerance 0.020
    set setup_relative_tolerance 0.05
    set hold_absolute_tolerance 0.020
    set hold_relative_tolerance 0.05
    set recovery_absolute_tolerance 0.020
    set recovery_relative_tolerance 0.05
    set removal_absolute_tolerance 0.020
    set removal_relative_tolerance 0.05
    set mpw_absolute_tolerance 0.020
    set mpw_relative_tolerance 0.05

    # Power.
    set energy_absolute_tolerance 0.00005
    set energy_relative_tolerance 0.02
    set leakage_absolute_tolerance 0.002
    set leakage_relative_tolerance 0.02

    
    # SPICE comparison parameters.  These control the function of the
    # compare_spice command. path_cell_list is a list of cell names to
    # use on the timing path itself.  If there are more stages than
    # cells in the list, the list repeats.  path_fanout_cells is a
    # list of cells to use as fanout loads.
    set path_cell_list { }
    set path_fanout_cells { }

    # path_num_stages controlls the number of stages in the timing
    # path.  path_num_fanouts is a list of integers indicating how
    # many fanouts to use for each stage.
    set path_num_stages 5
    set path_num_fanouts { 1 2 4 6 8 }

    # Specifies the loading model, lumped or pi, and the load to
    # use.  For lumped this is a single capacitor value in Farads.
    # For pi models the value is a list of capacitance, resistor
    # value, and capacitance.
    set path_interconnect_model lumped
    set path_fanout_load 0.02e-12
    set path_input_slew 0.3e-9

    set delay_calculation_method nldm
    set timer_command mantle
}



#
# DEFAULT PIN CONFIGURATION PARAMETERS
#
pintype default {

    set logic_high_name VDD
    set logic_high_threshold 0.8

    set logic_low_name VSS
    set logic_low_threshold 0.2

    set prop_delay_level 0.5
    set prop_delay_current 0.1

    set driver_rise_time 10e-12
    set driver_fall_time 10e-12

    # Input transition time. Constraints (setup, hold, etc) default
    # to 3x3 tables.
    set numsteps_slew 5
    set constraint_numsteps_slew 3
    set smallest_slew 10e-12
    set default_slew 15e-12
    set largest_slew 5.7e-9

    # Output capacitive loading.
    set autorange_load 0
    set numsteps_load 5
    set smallest_load 10e-15
    set default_load 40e-15
    set largest_load 90e-15

    # Input noise hight. smallest_height is commented out because it gets set
    # automatically when autorange_height is '1'.  largest_height defaults to
    # the pins rail voltage and should normally not be set.
    set autorange_height 1
    set numsteps_height 8
    set smallest_height 0.48

    # Input noise width. smallest_width and largest_width are set by default
    # based on the input transition times.
    set numsteps_width 5

    
    set constraint_resolution 10e-12
    set maxload_tout_resolution 10e-12
    set max_tout 1.5e-9
    set opt_load_low 1e-17
    set opt_load_high 10e-12
    set smc_degrade_absolute 10e-12

    # driver_mode selects the type of driver used: pwl, ccs-predriver, or
    # active.  pwl generates a linear ramp.  ccs-predriver is a non-linear
    # driver as specified by the CCS Characterization Guidelines.  active
    # selects an active driver which is instantiated into the circuit.  If
    # driver_mode is set to active, then the parameter driver is used to specify
    # the name of an imported driver to be used.
    #
    # For backward compatibility, driver_mode defaults to 'active' and driver
    # can be set to 'pwl'.
    set driver_mode pwl
    set driver pwl
}


# 
# OPERATING CONDITIONS - populate the simulation environment object
#                        with best, typ, & worst operating conditions.
#

