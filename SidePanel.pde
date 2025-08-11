public class SidePanel {
  Main mn;
  
  //display images for each tab
  PImage timer;
  PImage stats;
  PImage solver;
  PImage algs;
  PImage settings;
  
  //constructor, sets images
  public SidePanel(Main amn) {
    mn = amn;
    timer = loadImage("timer.png");
    stats = loadImage("stats.png");
    solver = loadImage("solver.png");
    algs = loadImage("algs.png");
    settings = loadImage("settings.png");
  }
  
  //*******************************************************************************************************************************************************************
  
  //draws each component of the side panel, and draws the selection lines
  public void draw() {
    //background
    stroke(0, 0, 0);
    strokeWeight(0);
    fill(255, 255, 255);
    rect(0, 0, 150, 400);
    
    //lines
    strokeWeight(4);
    stroke(0, 0, 0);
    fill (#E8933D);
    line(0, 0, 150, 0);
    line(0, 200, 150, 200);
    line(0, 400, 150, 400);
    line(150, 0, 150, 400);
    
    //images
    image(timer, 25, 50, 100, 100);
    image(stats, 25, 250, 100, 100);
    
    //selections
    strokeWeight(15);
    stroke(#FF7A27);
    if (mn.current_tab == Main.TIMER_SCREEN)
      line(150, 0, 150, 200);
    else if (mn.current_tab == Main.STATS_SCREEN)
      line(150, 200, 150, 400);
    else if (mn.current_tab == Main.SOLVER_SCREEN)
      line(150, 400, 150, 600);
    else if (mn.current_tab == Main.ALGS_SCREEN)
      line(150, 600, 150, 800);
    else if (mn.current_tab == Main.SETTINGS_SCREEN)
      line(150, 800, 150, 1000);
    stroke(#FFC652);
    if (mouseX > 0 && mouseX < 150) {
      if (mouseY < 200 && mouseY > 0 && mn.current_tab != Main.TIMER_SCREEN){
        line(150, 0, 150, 200);
      } else if (mouseY < 400 && mouseY > 200 && mn.current_tab != Main.STATS_SCREEN) {
        line(150, 200, 150, 400);
      }
    }
  }
  
  //*******************************************************************************************************************************************************************
  
  //called anytime user clicks, changes tab in main class if a new tab is selected
  public void clicked()
  {
    if (mouseX > 0 && mouseX < 150) {
      if (mouseY > 0) {
        if (mouseY < 200){
          mn.current_tab = Main.TIMER_SCREEN;
        } else if (mouseY < 400) {
          mn.current_tab = Main.STATS_SCREEN;
        }
      }
    }
  }
}
