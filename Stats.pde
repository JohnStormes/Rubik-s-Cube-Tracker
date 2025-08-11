import java.util.LinkedList;
import java.text.DecimalFormat;
import java.io.FileWriter;
import java.io.File;
import java.io.IOException;
import java.util.Scanner;

public static final int PUZZLE_2x2 = 0;
public static final int PUZZLE_3x3 = 1;
public static final int PUZZLE_4X4 = 2;
public static final int PUZZLE_5X5 = 3;
public static final int PUZZLE_6X6 = 4;
public static final int PUZZLE_7X7 = 5;

public class Stats {
  public DecimalFormat df = new DecimalFormat("###.###");
  
  // colors
  private int colSelectionHover;
  private int colSelect;
  private int colSelected;
  private int colBlankSpace;
  private int colListSpace;
  private int colText;
  private int colBackground;
  private int colStatsBackground;
  
  //add session button and text field
  private boolean adding_session;
  private int text_blinking_timer;
  private String temp_session_name;
  
  //edit and remove buttons
  private boolean editing_session_name;
  private int edited_session_index;
  
  //sessions
  private int removingSession;                      // -1 = not removing, any other int means currently removing that session index
  private Session[] sessions = new Session[50];
  private int current_session_index;
  private Session current_session;
  private int num_of_sessions;
  private int cur_session_page;
  private int page_sessions;
  private int current_puzzle_selection;
  
  //solves
  private int cur_solve_page;
  private int page_solves;
  private int solve_info_index;
  String scramble_temp;
  String scramble_temp1;
  String scramble_temp2;
  
  //file reading
  private boolean reading_file;
  
  //*******************************************************************************************************************************************************************
  
  //constructor
  public Stats() {
    num_of_sessions = 0;
    cur_session_page = 0;
    page_sessions = 0;
    cur_solve_page = 0;
    page_solves = 0;
    solve_info_index = -1;
    temp_session_name = "";
    adding_session = false;
    text_blinking_timer = 0;
    editing_session_name = false;
    edited_session_index = 0;
    removingSession = -1;
    
    //read data from the file
    reading_file = true;
    readFromFile();
    reading_file = false;
    
    // set colors
    colSelectionHover = #FFC652;
    colSelect = #FF7A27;
    colSelected = #1FDE37;
    colBlankSpace = #FFFFFF;
    colListSpace = #F8FFD3;
    colText = #000000;
    colBackground = #E192FA;
    colStatsBackground = #88FABE;
  }
  
  //*******************************************************************************************************************************************************************
  
  //draw. calls many methods to handle everything being drawn
  public void draw() {
    drawCurrentStats();
    drawSessionBoxes();
    drawAddSessionBox();
    drawSessionPageChangers();
    if (solve_info_index == -1) {
      drawSolveBoxes();
      drawSolvePageChangers();
    } else
      drawSolveInfo();
    if (removingSession != -1)
      drawRemovingSessionBox();
  }
  
  //*******************************************************************************************************************************************************************
  
  //called from main anytime mouse is clicked.
  public void clicked()
  {
    if (removingSession == -1) {
      //add session button
      if (mouseX > 200 && mouseX < 800 && mouseY > 100 && mouseY < 200 && !adding_session) {
        adding_session = true;
      }
      
      //session actions
      for (int i = 0; i < page_sessions; i++) {
        if (mouseX > 205 && mouseX < 245 && mouseY > 205 + (i * 50) && mouseY < 245 + (i * 50)) {
          removingSession = i;
          if (editing_session_name == true && edited_session_index == i) {
            temp_session_name = "";
            text_blinking_timer = 0;
            editing_session_name = false;
            adding_session = false;
          } else if (editing_session_name == true) {
            edited_session_index = current_session_index;
          }
        } else if (mouseX > 250 && mouseX < 290 && mouseY > 205 + (i * 50) && mouseY < 245 + (i * 50)) {
          editing_session_name = true;
          adding_session = true;
          edited_session_index = i + (cur_session_page * 12);
          current_puzzle_selection = sessions[edited_session_index].getTypeInt();
          temp_session_name = sessions[edited_session_index].getName();
        } else if (mouseX > 295 && mouseX < 800 && mouseY > 200 + (i * 50) && mouseY < 250 + (i * 50)) {
          if (i != current_session_index)
            changeSession(i + cur_session_page * 12);
        }
      }
      
      //solve box actions
      //System.out.println(page_solves);
      if (solve_info_index == -1) {
        for (int i = 0; i < page_solves; i++) {
          if (mouseX > 1450 && mouseX < 2000 && mouseY > 200 + (i * 50) && mouseY < 250 + (i * 50)) {
            solve_info_index = i + (cur_solve_page * 12);
            return;
          } if (mouseX > 1405 && mouseX < 1445 && mouseY > 205 + (i * 50) && mouseY < 245 + (i * 50)) {
            removeSolve(i);
            return;
          }
        }
      }
      if (mouseX > 1550 && mouseX < 1850 && mouseY > 750 && mouseY < 830 && solve_info_index != -1)
        solve_info_index = -1;
      
      //change session page buttons
      if (mouseX < 450 && mouseX > 400 && mouseY < 870 && mouseY > 810) {
        if ((mouseY <= 840 && (450 - mouseX) < (mouseY - 810)) || (mouseY >= 840 && (450 - mouseX) < (870 - mouseY))) {
          if (cur_session_page != 0) {
            cur_session_page--;
            page_sessions = num_of_sessions - (cur_session_page * 12);
          }
        }
      }
      if (mouseX < 600 && mouseX > 550 && mouseY < 870 && mouseY > 810) {
        if ((mouseY <= 840 && (mouseX - 550) < (mouseY - 810)) || (mouseY >= 840 && (mouseX - 550) < (870 - mouseY))) {
          if (cur_session_page != (num_of_sessions - 1) / 12) {
            cur_session_page++;
            page_sessions = num_of_sessions - (cur_session_page * 12);
          }
        }
      }
      
      //change solve page buttons
      if (mouseX < 1650 && mouseX > 1620 && mouseY < 870 && mouseY > 810) {
        if ((mouseY <= 840 && (1650 - mouseX) < (mouseY - 810)) || (mouseY >= 840 && (1650 - mouseX) < (870 - mouseY))) {
          if (cur_solve_page != 0) {
            cur_solve_page--;
            page_solves = current_session.getNumOfSolves() - (cur_solve_page * 12);
          }
        }
      }
      if (mouseX < 1780 && mouseX > 1750 && mouseY < 870 && mouseY > 810) {
        if ((mouseY <= 840 && (mouseX - 1750) < (mouseY - 810)) || (mouseY >= 840 && (mouseX - 1750) < (870 - mouseY))) {
          if (cur_solve_page != (current_session.getNumOfSolves() - 1) / 12) {
            cur_solve_page++;
            page_solves = current_session.getNumOfSolves() - (cur_solve_page * 12);
          }
        }
      }
      
      // change puzzle type for adding a session
      if (mouseY < 80 && mouseY > 30) {
        for (int i = 0; i < 6; i++) {
          if (i != current_puzzle_selection && mouseX > 200 + (i * 100) && mouseX < 300 + (i * 100)) {
            current_puzzle_selection = i;
          }
        }
      }
    }
    
    // remove or don't remove a session
    if (mouseX > 600 && mouseX < 900 && mouseY > 650 && mouseY < 750) {
      removeSession(removingSession);
      removingSession = -1;
    }
    if (mouseX > 1100 && mouseX < 1400 && mouseY > 650 && mouseY < 750) {
      removingSession = -1;
    }
  }
  
  //*******************************************************************************************************************************************************************
  
  //called from main any time a key is pressed
  public void keyPress() {
    textSize(60);
    if (adding_session) {
      if (key == '\n' && temp_session_name.length() != 0) {
        adding_session = false;
        if (editing_session_name) {
          sessions[edited_session_index].setName(temp_session_name);
          sessions[edited_session_index].setPuzzleType(current_puzzle_selection);
        } else
          addSession(current_puzzle_selection, temp_session_name);
        temp_session_name = "";
        text_blinking_timer = 0;
        editing_session_name = false;
        writeToFile();
      } else if (key == BACKSPACE) {
        if (temp_session_name.length() != 0)
          temp_session_name = temp_session_name.substring(0, temp_session_name.length() - 1);
      } else if (textWidth(temp_session_name) < 550 && keyCode != 16 && key != DELETE && key != ENTER){
        temp_session_name += key;
      }
    }
  }
  
  //*******************************************************************************************************************************************************************
  //*******************************************************************************************************************************************************************
  //methods for handling sessions
  
  //add a new session given the type of puzzle (static variables in Session class) and a name
  public boolean addSession(int puzzle_type, String name) {
    if (num_of_sessions == 50)
      return false;
    else {
      sessions[num_of_sessions] = new Session(puzzle_type, name);
      changeSession(num_of_sessions);
      num_of_sessions++;
      if (!reading_file)
        writeToFile();
      return true;
    }
  }
  
  //remove a session via its index in the array of sessions
  public boolean removeSession(int session_index) {
    if (session_index < 0 || session_index > 49 || num_of_sessions == 1)
      return false;
    else {
      for (int i = session_index; i < num_of_sessions - 1; i++) {
        sessions[i] = sessions[i + 1];
      }
      sessions[num_of_sessions - 1] = null;
      num_of_sessions--;
      if (current_session_index == num_of_sessions) {
        changeSession(num_of_sessions - 1);
      } else if (current_session_index == session_index) {
        changeSession(session_index);
      }
      cur_session_page = current_session_index / 12;
      if (!reading_file)
        writeToFile();
      return true;
    }
  }
  
  //changes the current session to the given session index
  public void changeSession(int session_index) {
    //store solve page
    if (current_session != null)
      current_session.storePageNum(cur_solve_page);
    
    //change session
    current_session_index = session_index;
    current_session = sessions[session_index];
    cur_session_page = current_session_index / 12;
    cur_solve_page = current_session.getPageNum();
    if (!reading_file)
        writeToFile();
  }
  
  //add a solve to the current session
  public void addSolve(String[] scramble, double time) {
    current_session.addSolve(scramble, time);
    cur_solve_page = current_session.getNumOfSolves() / 12;
    if (current_session.getNumOfSolves() >= 12 && current_session.getNumOfSolves() % 12 == 0)
      cur_solve_page -= 1;
    if (!reading_file)
        writeToFile();
  }
  
  //remove a solve of given index in the current session
  public void removeSolve(int solveIndex) {
    current_session.removeSolve(solveIndex);
    if (!reading_file)
        writeToFile();
  }
  
  //format time
  public String getFormattedSolve(double time) {
    int mins = (int)time / 60;
    String secs = df.format(time - (mins * 60));
    if (mins > 0)
      return mins + ":" + secs;
    else
      return secs;
  }
  
  //returns the current session
  public Session getCurrentSession() {
    return current_session; 
  }
  
  //*******************************************************************************************************************************************************************
  //*******************************************************************************************************************************************************************
  //private methods for draw()
  
  //stats for current session
  private void drawCurrentStats() {
    background(colBackground);
    fill(colStatsBackground);
    strokeWeight(0);
    stroke(0, 0, 0);
    rect(850, 100, 500, 800, 100);
    fill(colText);
    textSize(50);
    textAlign(CENTER);
    text("Best:     " + getFormattedSolve(current_session.getBest()), 1100, 200);
    text("Worst:     " + getFormattedSolve(current_session.getWorst()), 1100, 400);
    text("Average:     " + getFormattedSolve(current_session.getSessionAverage()), 1100, 600);
    text("Average of 5:     " + getFormattedSolve(current_session.getAverageOf5()), 1100, 800);
  }
  
  //*******************************************************************************************************************************************************************
  
  //session boxes
  private void drawSessionBoxes() {
    //white box for all sessions
    fill(colBlankSpace);
    rect(200, 100, 600, 800, 50);
    strokeWeight(1);
    stroke(0, 0, 0);
    textSize(40);
    textAlign(LEFT);
    page_sessions = num_of_sessions - (cur_session_page * 12);
    if (page_sessions > 12)
      page_sessions = 12;
    
    //iterate through all sessions on page and draw necessary components
    for (int i = 0; i < page_sessions; i++) {
      //session box, name, and solve type
      stroke(0, 0, 0);
      strokeWeight(0);
      fill(colListSpace);
      if (i + (cur_session_page * 12) == current_session_index)
        fill (colSelected);
      else if (mouseX > 295 && mouseX < 700 && mouseY > 200 + (i * 50) && mouseY < 250 + (i * 50) && !mousePressed)
        fill (colSelectionHover);
      else if (mouseX > 295 && mouseX < 700 && mouseY > 200 + (i * 50) && mouseY < 250 + (i * 50) && mousePressed)
        fill (colSelect);
      rect(295, 200 + (i * 50), 505, 50);
      rect(200, 200 + (i * 50), 95, 50);
      fill(colText);
      textAlign(LEFT);
      text(sessions[(cur_session_page * 12) + i].getName(), 300, 240 + (i * 50));
      textAlign(CENTER);
      text(sessions[(cur_session_page * 12) + i].getType(), 750, 240 + (i * 50));
      
      //draw delete and edit buttons backgrounds
      stroke(0, 0, 0);
      strokeWeight(1);
      if (mouseX > 205 && mouseX < 245 && mouseY > 205 + (i * 50) && mouseY < 245 + (i * 50) && mousePressed)
        fill(#FAE630);
      else 
        fill (255, 255, 255);
      rect(205, 205 + (i * 50), 40, 40, 15);
      if (mouseX > 250 && mouseX < 290 && mouseY > 205 + (i * 50) && mouseY < 245 + (i * 50) && mousePressed)
        fill(#FAE630);
      else
        fill (255, 255, 255);
      rect(250, 205 + (i * 50), 40, 40, 15);
      
      //draw actual buttons
      strokeWeight(3);
      //remove shape (X)
      if (mouseX > 205 && mouseX < 245 && mouseY > 205 + (i * 50) && mouseY < 245 + (i * 50))
        stroke(#E53838);
      else
        stroke(0, 0, 0);
      line(215, 215 + (i * 50), 235, 235 + (i * 50));
      line(215, 235 + (i * 50), 235, 215 + (i * 50));
      //edit shape (pencil)
      if (mouseX > 245 && mouseX < 285 && mouseY > 205 + (i * 50) && mouseY < 245 + (i * 50))
        stroke(#E07B14);
      else
        stroke(0, 0, 0);
      line(260, 225 + (i * 50), 260, 235 + (i * 50));
      line(260, 235 + (i * 50), 270, 235 + (i * 50));
      line(260, 225 + (i * 50), 270, 235 + (i * 50));
      line(260, 225 + (i * 50), 275, 210 + (i * 50));
      line(270, 235 + (i * 50), 285, 220 + (i * 50));
      line(275, 210 + (i * 50), 285, 220 + (i * 50));
    }
  }
  
  //*******************************************************************************************************************************************************************
  
  //add session button
  private void drawAddSessionBox() {
    stroke(0, 0, 0);
    strokeWeight(0);
    if (mouseX > 200 && mouseX < 800 && mouseY > 100 && mouseY < 200 && !adding_session && mousePressed) {
      fill (colStatsBackground);
    } else
      fill (colBlankSpace);
    rect(200, 100, 600, 100, 50);
    if (!adding_session) {
      textSize(60);
      textAlign(CENTER);
      fill (colText);
      text("add new session", 500, 170);
    } else {
      drawPuzzleSelectionBox();
      text_blinking_timer++;
      if (text_blinking_timer < 20)
        stroke(0, 0, 0);
      else if (text_blinking_timer < 40)
        stroke(colBlankSpace);
      else
        text_blinking_timer = 0;
      line(250 + (textWidth(temp_session_name)), 130, 250 + (textWidth(temp_session_name)), 180);
      fill(colText);
      textSize(40);
      textAlign(LEFT);
      text(temp_session_name, 250, 170);
      if (temp_session_name.length() == 0) {
        fill(#C6C6C6);
        text("Enter session name", 250, 170);
      }
    }
  }
  
  //*******************************************************************************************************************************************************************
  
  private void drawRemovingSessionBox() {
    fill(colBlankSpace);
    strokeWeight(2);
    stroke(#FF0F0F);
    rect(400, 200, 1200, 600, 100);
    fill(0, 0, 0);
    textSize(50);
    textAlign(CENTER);
    text("are you sure you want to remove " + sessions[removingSession].getName() + "?", 1000, 400);
    textSize(40);
    text("your session will be permanently deleted", 1000, 470);
    // buttons
    fill(255, 255, 255);
    stroke(0, 0, 0);
    if (mouseX > 600 && mouseX < 900 && mouseY > 650 && mouseY < 750) {
      if (mousePressed)
        fill(colSelect);
      else
        fill(colSelectionHover);
    }
    rect(600, 650, 300, 100);
    fill(255, 255, 255);
    if (mouseX > 1100 && mouseX < 1400 && mouseY > 650 && mouseY < 750) {
      if (mousePressed)
        fill(colSelect);
      else
        fill(colSelectionHover);
    }
    rect(1100, 650, 300, 100);
    // text in buttons
    fill(#FF0F0F);
    textSize(70);
    text("YES", 750, 725);
    fill(0, 0, 0);
    text("NO", 1250, 725);
  }
  
  //*******************************************************************************************************************************************************************
  
  // puzzle type selection
  private void drawPuzzleSelectionBox() {
    // box selection detection, color changes, and drawing
    for (int i = 0; i < 6; i++) {
      strokeWeight(1);
      fill(255, 255, 255);
      if (i == current_puzzle_selection) {
        strokeWeight(2);
        fill(colSelected);
      }
      rect(200 + (i * 100), 30, 100, 50);
    }
    if (mouseY < 80 && mouseY > 30) {
      for (int i = 0; i < 6; i++) {
        if (i != current_puzzle_selection && mouseX > 200 + (i * 100) && mouseX < 300 + (i * 100)) {
          if (mousePressed)
            fill(colSelect);
          else
            fill(colSelectionHover);
          rect(200 + (i * 100), 30, 100, 50);
        }
      }
    }

    
    // draw text
    fill(colText);
    textAlign(CENTER);
    textSize(40);
    text("2X2", 250, 70);
    text("3X3", 350, 70);
    text("4X4", 450, 70);
    text("5X5", 550, 70);
    text("6X6", 650, 70);
    text("7X7", 750, 70);
  }
  
  //*******************************************************************************************************************************************************************
  
  //draws arrows for the page changers for sessions
  private void drawSessionPageChangers() {
    //current page number
    textSize(80);
    textAlign(CENTER);
    fill(colText);
    text(cur_session_page + 1, 500, 870);
    
    //page changing triangle buttons
    stroke(0, 0, 0);
    strokeWeight(2);
    fill(255, 255, 255);
    //go back
    if (mouseX < 450 && mouseX > 420 && mouseY < 870 && mouseY > 810) {
      if ((mouseY <= 840 && (450 - mouseX) < (mouseY - 810)) || (mouseY >= 840 && (450 - mouseX) < (870 - mouseY))) {
        if (mousePressed)
          fill(colSelect);
        else
          fill (colSelectionHover);
      }
    }
    triangle(420, 840, 450, 810, 450, 870);
    fill (255, 255, 255);
    //go forwards
    if (mouseX < 580 && mouseX > 550 && mouseY < 870 && mouseY > 810) {
      if ((mouseY <= 840 && (mouseX - 550) < (mouseY - 810)) || (mouseY >= 840 && (mouseX - 550) < (870 - mouseY))) {
        if (mousePressed)
          fill(colSelect);
        else
          fill (colSelectionHover);
      }
    }
    triangle(550, 810, 550, 870, 580, 840);
  }
  
  //*******************************************************************************************************************************************************************
  
  //draws all solves on right side of screen
  private void drawSolveBoxes() {
    page_solves = current_session.getNumOfSolves() - (cur_solve_page * 12);
    if (page_solves > 12)
      page_solves = 12;
    //draw white box enclosing all solves and "solves" tag
    fill(colBlankSpace);
    stroke(0, 0, 0);
    strokeWeight(0);
    rect(1400, 100, 600, 800, 50);
    textSize(60);
    textAlign(CENTER);
    fill (colText);
    text(current_session.getName(), 1700, 170);
    strokeWeight(3);
    line(1700 - (textWidth(current_session.getName()) / 2), 180, 1700 + (textWidth(current_session.getName()) / 2), 180);
    
    textSize(40);
    textAlign(LEFT);
    //draw components for each solve
    for (int i = 0; i < page_solves; i++) {
      //boxes, times, and solve numbers
      stroke(0, 0, 0);
      strokeWeight(0);
      fill(colListSpace);
      if (mouseX > 1450 && mouseX < 2000 && mouseY > 200 + (i * 50) && mouseY < 250 + (i * 50) && !mousePressed)
        fill (colSelectionHover);
      else if (mouseX > 1450 && mouseX < 2000 && mouseY > 200 + (i * 50) && mouseY < 250 + (i * 50) && mousePressed)
        fill (colSelect);
      rect(1450, 200 + (i * 50), 550, 50);
      rect(1400, 200 + (i * 50), 50, 50);
      textAlign(CENTER);
      if (current_session.getSolve(cur_solve_page * 12 + i).getTime() == current_session.getBest() && current_session.getNumOfSolves() != 1) {
        fill(#17CE15);
        text("B", 1470, 240 + (i * 50));
      } 
      if (current_session.getSolve(cur_solve_page * 12 + i).getTime() == current_session.getWorst() && current_session.getNumOfSolves() != 1) {
        fill(#E53838);
        text("W", 1470, 240 + (i * 50));
      }
      fill(colText);
      text(getFormattedSolve(current_session.getSolve(cur_solve_page * 12 + i).getTime()), 1700, 240 + (i * 50));
      text(i + 1 + (cur_solve_page * 12), 1960, 240 + (i * 50));
      
      //draw delete button
      stroke(0, 0, 0);
      strokeWeight(1);
      if (mouseX > 1405 && mouseX < 1445 && mouseY > 205 + (i * 50) && mouseY < 245 + (i * 50) && mousePressed)
        fill(#FAE630);
      else 
        fill (255, 255, 255);
      rect(1405, 205 + (i * 50), 40, 40, 15);
      
      //remove shape (X)
      strokeWeight(3);
      if (mouseX > 1405 && mouseX < 1445 && mouseY > 205 + (i * 50) && mouseY < 245 + (i * 50))
        stroke(#E53838);
      else
        stroke(0, 0, 0);
      line(1415, 215 + (i * 50), 1435, 235 + (i * 50));
      line(1415, 235 + (i * 50), 1435, 215 + (i * 50));
    }
  }
  
  //*******************************************************************************************************************************************************************
  
  //gives info for current solve if selected
  private void drawSolveInfo() {
    //draw white box enclosing all solves
    fill(colListSpace);
    stroke(0, 0, 0);
    strokeWeight(0);
    rect(1400, 100, 600, 800, 50);
    
    //all info
    fill (colSelect);
    textSize(60);
    textAlign(CENTER);
    text("solve #" + (solve_info_index + 1), 1700, 170);
    strokeWeight(3);
    line(1700 - textWidth("solve #" + (solve_info_index + 1)) / 2, 180, 1700 + textWidth("solve #" + (solve_info_index + 1)) / 2, 180);
    fill(colText);
    text("time:", 1700, 320);
    textSize(150);
    fill(#17CE15);
    text(getFormattedSolve(current_session.getSolve(solve_info_index).getTime()) + "s", 1700, 450);
    fill(colText);
    textSize(60);
    text("scramble:", 1700, 600);
    textSize(30);
    scramble_temp = current_session.getSolve(solve_info_index).getScramble();
    scramble_temp1 = scramble_temp.substring(0, scramble_temp.length() / 2);
    scramble_temp2 = scramble_temp.substring(scramble_temp.length() / 2, scramble_temp.length());
    if (scramble_temp2.substring(0, 1).equals(","))
      scramble_temp2 = scramble_temp2.substring(2, scramble_temp2.length());
    text(scramble_temp1, 1700, 660);
    text(scramble_temp2, 1700, 700);
    
    //back button
    strokeWeight(1);
    fill(colBlankSpace);
    if (mouseX > 1550 && mouseX < 1850 && mouseY > 750 && mouseY < 830 && !mousePressed)
        fill (colSelectionHover);
    else if (mouseX > 1550 && mouseX < 1850 && mouseY > 750 && mouseY < 830 && mousePressed)
        fill (colSelect);
    rect(1550, 750, 300, 80, 50);
    textSize(60);
    fill(colText);
    text("back", 1700, 810);
    triangle(1600, 790, 1620, 770, 1620, 810);
  }
  
  //*******************************************************************************************************************************************************************
  
  //draws the arrows to change pages for sessions
  private void drawSolvePageChangers() {
    //current solve number
    textSize(80);
    textAlign(CENTER);
    fill(colText);
    text(cur_solve_page + 1, 1700, 870);
    
    //page changing triangle buttons
    stroke(0, 0, 0);
    strokeWeight(2);
    fill(255, 255, 255);
    //go back
    if (mouseX < 1650 && mouseX > 1620 && mouseY < 870 && mouseY > 810) {
      if ((mouseY <= 840 && (1650 - mouseX) < (mouseY - 810)) || (mouseY >= 840 && (1650 - mouseX) < (870 - mouseY))) {
        if (mousePressed)
          fill(colSelect);
        else
          fill (colSelectionHover);
      }
    }
    triangle(1620, 840, 1650, 810, 1650, 870);
    fill (255, 255, 255);
    //go forwards
    if (mouseX < 1780 && mouseX > 1750 && mouseY < 870 && mouseY > 810) {
      if ((mouseY <= 840 && (mouseX - 1750) < (mouseY - 810)) || (mouseY >= 840 && (mouseX - 1750) < (870 - mouseY))) {
        if (mousePressed)
          fill(colSelect);
        else
          fill (colSelectionHover);
      }
    }
    triangle(1750, 810, 1750, 870, 1780, 840);
  }
  
  //*******************************************************************************************************************************************************************
  //*******************************************************************************************************************************************************************
  //data saving (writing to file and reading from file)
  
  //writes information to file. should be called after every change in stats
  public void writeToFile() {
    try
    {
      PrintWriter fileWriter;
      fileWriter = new PrintWriter(new File("data.txt"));
      
      //add data to file
      fileWriter.println("current session:\t" + current_session_index);
      for (int i = 0; i < num_of_sessions; i++) {
        fileWriter.println("session\t" + i + "\t" + sessions[i].getName() + "\t" + sessions[i].getTypeInt());
        for (int x = 0; x < sessions[i].getNumOfSolves(); x++) {
          fileWriter.println("solve\t" + sessions[i].getSolve(x).getTime() + "\t" + sessions[i].getSolve(x).getScramble());
        }
      }
      
      fileWriter.close();
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
  }
  
  //reads from the data and initializes everything
  public boolean readFromFile() {
    try
    {
      Scanner scan = new Scanner(new File("data.txt"));
      
      //read from data file
      String[] temp = scan.nextLine().split("\t");
      int session_index = Integer.parseInt(temp[1]);
      while (scan.hasNext()) {
        temp = scan.nextLine().split("\t");
        if (temp[0].equals("session")) {
          addSession(Integer.parseInt(temp[3]), temp[2]);
        } else if (temp[0].equals("solve")) {
          String[] scramble = temp[2].split(", ");
          addSolve(scramble, Double.parseDouble(temp[1]));
        }
      }
      current_session_index = session_index;
      current_session = sessions[current_session_index];
      
      scan.close();
      return true;
    }
    catch(IOException e)
    {
      System.out.println(e);
      return false;
    }
    catch(Exception e)
    {
      System.out.println(e);
      return false;
    }
  }
}
