# worktimer
This is a program to help keep track of working time when you need to charge time to individual projects rather than just 'the company' in general. It consists of a number of buttons, which are generated based on the projects that are provided to it. These buttons have the following functionality:

- 'Clock in' clocks in your general work-day time, not associated with any project. Use this button if you want to clock in without jumping straight into a project.
- 'Clock out' clocks you out, disengages you from any project you may be in, and displays your total work time.
- Each project button engages you with a particular project, and clocks you in if you weren't already clocked in. When you disengage, the total time accumulated to that project so far is displayed underneath the button.
- The 'disengage all' button disengages you from all projects but leaves you clocked in. 
- The 'clear all' button resets all the values for a new day - you're clocked out with no time accumulated so far to any project or to your overall clock.

All time values are displayed as decimal hours to two decimal places - so 'an hour and fifteen minutes' is displayed as '1.25'.

This program requires a Ruby installation and the Tk GUI library (available at URL). To run it, open a command line prompt in the folder you've placed it in and run `irb worktimer.rb`.

The list of projects the program uses is found in `project_list.rb`; that's where you want to go to customise the specific list of projects you care about.
