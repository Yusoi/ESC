c CLASS = F
c  
c  
c  This file is generated automatically by the setparams utility.
c  It sets the number of processors and the class of the NPB
c  in this directory. Do not modify it by hand.
c  
        character class
        parameter (class='F')
        integer x_zones, y_zones
        parameter (x_zones=128, y_zones=128)
        integer gx_size, gy_size, gz_size, niter_default
        parameter (gx_size=12032, gy_size=8960, gz_size=250)
        parameter (niter_default=500)
        integer problem_size
        parameter (problem_size = 250)
        integer*8 max_xysize
        integer*8 proc_max_size, proc_max_size5, proc_max_bcsize
        parameter (max_xysize=108953600)
        parameter (proc_max_size=max_xysize*gz_size)
        parameter (proc_max_size5=proc_max_size*5)
        parameter (proc_max_bcsize=max_xysize*20)
        double precision dt_default, ratio
        parameter (dt_default = 0.0001d0, ratio = 1.d0)
        integer*8 start1, start5, qstart_west, qstart_east
        integer*8 qstart_south, qstart_north
        logical  convertdouble
        parameter (convertdouble = .false.)
        character compiletime*11
        parameter (compiletime='21 Apr 2020')
        character npbversion*5
        parameter (npbversion='3.3.1')
        character cs1*8
        parameter (cs1='gfortran')
        character cs2*6
        parameter (cs2='$(F77)')
        character cs3*6
        parameter (cs3='(none)')
        character cs4*6
        parameter (cs4='(none)')
        character cs5*3
        parameter (cs5='-O3')
        character cs6*3
        parameter (cs6='-O3')
        character cs7*6
        parameter (cs7='randi8')