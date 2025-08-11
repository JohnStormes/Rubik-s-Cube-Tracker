//constants for changing the screen in other windows
public static final int WIN_WIDTH = 2000;
public static final int WIN_HEIGHT = 1000;
public static final int TIMER_SCREEN = 0;
public static final int STATS_SCREEN = 1;
public static final int SOLVER_SCREEN = 2;
public static final int ALGS_SCREEN = 3;
public static final int SETTINGS_SCREEN = 4;

//current screen
public int current_tab;

//all screen classes
public Timer timer;
public Stats stats;
public SidePanel side_panel;


//called once at start of program. initializes screen classes and whatever else is needed
void setup() {
  stats = new Stats();
  timer = new Timer(this);
  side_panel = new SidePanel(this);
  
  textSize(1000);
  
  size(2000, 1000);
  background(#E192FA);
  smooth();
  current_tab = TIMER_SCREEN;
}

//*******************************************************************************************************************************************************************

//called on a frame by frame basis, determines which screen to draw from depending on the current screen state determined by the side panel
void draw() {
  background(#E192FA);
  switch (current_tab) 
  {
    case TIMER_SCREEN:
      timer.draw();
      break;
    case STATS_SCREEN:
      stats.draw();
      break;
  }
  //draw the side panel after everything else so it is overlayed
  side_panel.draw();
}

//*******************************************************************************************************************************************************************

//called anytime the mouse is clicked *on release, and updates the click function of the given classes based on the current screen
void mouseClicked()
{
  side_panel.clicked();
  switch (current_tab) 
  {
    case TIMER_SCREEN:
      timer.clicked();
      break;
    case STATS_SCREEN:
      stats.clicked();
      break;
  }
}

//*******************************************************************************************************************************************************************

//same as clicked but for key presses
void keyPressed() 
{
  switch (current_tab) 
  {
    case TIMER_SCREEN:
      break;
    case STATS_SCREEN:
      stats.keyPress();
      break;
    case SOLVER_SCREEN:
      break;
    case ALGS_SCREEN:
      break;
    case SETTINGS_SCREEN:
      break;
  }
}
