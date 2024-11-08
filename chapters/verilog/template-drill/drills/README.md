In here we have templates for easier project creation

# New additions
- ```build.tcl``` now adapts to the names of all the sources dynamically
    - design files have pattern ```*.v```
    - sim files have pattern ```test_*.v```
    - constraint files have pattern ```*.xdc```
    - **You need to manually set up the simulation top and the design top**
- ```make bitstream``` and ```make flash``` now added. bitstream will be generated only if something changes in the design files were made (test files are ignored)
- ```make flash``` will activate hw_server if not already active
- ```fsm_top.v``` could be used as a standard top for any fsm files (with alterations to the interface and xdc). It has a controllable clock divider (not a reliable one but for slow clocks it does not matter that much)
- All source files are hard linked at project build time, so that we do not have to clean rebuild every time we make a modification and such that the modifications made inside vivado gui will be saved in the task root as well