require 'tk'
require 'tkextlib/tile'

# APP LOGIC

root = TkRoot.new {title "Work Time Allocator"}
content = Tk::Tile::Frame.new(root)
$content = content

$lastswitchtime = 0 #variable holds the last time projects were switched
$totaltime = 0 #total time worked for the day

class Project

  @@projects = []

  def initialize(name)
    @name = name
    @timeworked = 0
    @@projects << self # adds new project to a hash of all projects
  end

  def button(col) 
    name = @name
    thisproject = self # if you just put 'self' inside the button command it pulls the button, not the project the button is in
    tkbutton = Tk::Tile::Button.new($content) {text name; command {thisproject.engage}}
    tkbutton.grid :column => col, :row => 1
  end

  def timedisplay(col)
    timeworked = @timeworked
    tkfield = Tk::Tile::Label.new($content) {text timeworked}
    tkfield.grid :column=> col, :row => 2
    @fieldtimeworked = tkfield
  end

  def updatetime
    @timeworked += (Time.now - $lastswitchtime)
    @fieldtimeworked['text']=@timeworked.hourise
  end

  def engage
    disengage #disengage from any other project
    $engaged = self
    $lastswitchtime = Time.now
    clockin if !$clockintime
  end

  def self.all
    @@projects
  end

  def cleartime
    @timeworked = 0
    @fieldtimeworked['text']=@timeworked
  end

end

#extend the Float class to allow for making any time number a decimal hour to 2 places
class Float

  def hourise
    (self / 3600).truncate(2)
  end

end

require "./project_list" # separate file with a list of projects
nonproj = Project.new('non-project time')

def putprojs
  currentcolumn = 0
  Project.all.each do |proj|
   proj.button(currentcolumn)
   proj.timedisplay(currentcolumn)
   currentcolumn += 1
  end
  $totalcolumn = currentcolumn -1
end

putprojs

# --- NON-VARIABLE UI ELEMENTS ---
buttclockin = Tk::Tile::Button.new(content) {text "clock in"; command {clockin}}
buttclockout = Tk::Tile::Button.new(content) {text "clock out"; command {clockout}}
$viewclock = Tk::Tile::Label.new(content) {text 'clocked out'}
buttclear = Tk::Tile::Button.new(content) {text 'clear all'; command {clearall}}
buttdisengage = Tk::Tile::Button.new(content) {text 'disengage all'; command {disengage}}

content.grid :column => 0, :row => 0 
buttclockin.grid :column => ($totalcolumn / 2)-1, :row => 0
buttclockout.grid :column => ($totalcolumn / 2)+1, :row => 0
$viewclock.grid :column => ($totalcolumn / 2), :row => 0
buttclear.grid :column => $totalcolumn, :row => 0
buttdisengage.grid :column => $totalcolumn, :row => 3
# --- END NON-VARIABLE ---

def clockin
  $clockintime = Time.now
  $viewclock['text']='clocked in'
end
def clockout
  if $clockintime
    disengage
    clockouttime = Time.now
    $totaltime = clockouttime - $clockintime + $totaltime
    $viewclock['text'] = $totaltime.hourise
    $clockintime = nil
  else
    return nil
  end
end
def clearall
  $clockintime = nil
  $totaltime = 0
  $viewclock['text'] = 'clocked out'
  disengage
  Project.all.each do |proj|
    proj.cleartime
  end
end
def disengage
  $engaged.updatetime if $engaged
  $engaged = nil
end

Tk.mainloop