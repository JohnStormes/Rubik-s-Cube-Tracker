public class Timer {
  //instance of main for class communication
  Main mn;
  
  //scramble array of strings and scramble length
  private String[] scramble;
  private int[] scramble_ints;
  private int scramble_length;
  String scramble_display;
  Button b_next_scramble;
  
  //timer vars
  private int buffer_counter;
  private boolean timing;
  private double time_elapsed;
  private int mins_elapsed;
  private double start_time;
  private int inspection_time;
  private boolean start_inspec;
  private boolean is_inspec;
  
  //*******************************************************************************************************************************************************************
  
  //constructor
  public Timer(Main amn) {
    mn = amn;
    
    //scramble
    scramble_length = 20;
    generateScramble();
    b_next_scramble = new Button(1000 - (250 / 2), 80, 250, 50, "next scramble", 30, "FFFFFFFF", "FFFFC652", "FFFF7A27", "FF000000");
    
    //timer
    buffer_counter = 0;
    mins_elapsed = 0;
    timing = false;
    start_inspec = true;
    is_inspec = false;
    inspection_time = 15;
  }
  
  //*******************************************************************************************************************************************************************
  
  //draws and does some updating stuff
  public void draw() {
    background(#E192FA);
    
    //scramble
    scramble_display = "";
    for (int i = 0; i < scramble_length; i++)
    {
       scramble_display += scramble[i] + "  "; 
    }
    textSize(40);
    fill(0, 0, 0);
    textAlign(CENTER);
    text(scramble_display, 1000, 200);
    textSize(70);
    text(mn.stats.getCurrentSession().getType(), 1000, 60);
    b_next_scramble.draw();
    
    //timer logic
    fill (#FFFFFF);
    //inspection timer
    if (keyPressed && key == ' ' && start_inspec == true) {
      buffer_counter = 1;
    } else if (start_inspec == true) {
      if (buffer_counter == 1) {
        start_time = millis();
        start_inspec = false;
        is_inspec = true;
      }
      buffer_counter = 0;
    }
    
    //actual timer
    if (keyPressed && key == ' ' && start_inspec == false) {
      if (buffer_counter < 50 && timing == false) {
        buffer_counter++;
        time_elapsed = (int)((15999 - (millis() - start_time)) / 1000);
        fill(#F71442);
      } else if (buffer_counter == 50) {
        time_elapsed = (int)((15999 - (millis() - start_time)) / 1000);
        fill(#14F75A);
      } 
      if (timing == true)
      {
        timing = false;
        time_elapsed = (millis() - start_time) / 1000;
        mn.stats.addSolve(scramble, time_elapsed + (60 * mins_elapsed));
        buffer_counter = 100;
        generateScramble();
      }
    } else if (start_inspec == false){
      if (buffer_counter == 50) {
        timing = true;
        start_time = millis();
        mins_elapsed = 0;
      } else if (buffer_counter == 100) {
        buffer_counter = 0;
        start_inspec = true;
        is_inspec = false;
      }
      if (!timing && is_inspec == true) {
        time_elapsed = (int)((15999 - (millis() - start_time)) / 1000);
        if (time_elapsed == 0) {
          timing = true;
          start_time = millis();
          mins_elapsed = 0;
        }
      }
      buffer_counter = 0;
      fill (#FFFFFF);
    }
    
    //add to mins counter if elapsed time goes over 60
    if (timing && (millis() - start_time) / 1000 > 60) {
      start_time = millis();
      mins_elapsed++;
    }
    
    //draw timer
    textSize(500);
    if (!timing) {
      if (mins_elapsed == 0)
        text(Double.toString(time_elapsed), 1000, 700);
      else
        text(mins_elapsed + ":" + Double.toString(time_elapsed), 1000, 700);
    }
    else {
      double num = millis() - start_time;
      num = num / 1000;
      num = (int)(num * 10);
      num = num / 10;
      String temp = Double.toString(num);
      if (mins_elapsed == 0)
        text(temp, 1000, 700);
      else
        text(mins_elapsed + ":" + temp, 1000, 700);
    }
  }
  
  //*******************************************************************************************************************************************************************
  
  //all buttons
  public void clicked()
  {
    if (b_next_scramble.clicked() && timing == false && is_inspec == false)
      generateScramble();
  }
  
  //*******************************************************************************************************************************************************************
  
  //generates new scramble. Avoids repeat turns and redundant turns
  private void generateScramble()
  {
    scramble = new String[scramble_length];
    scramble_ints = new int[scramble_length];
    int temp;
    for (int i = 0; i < scramble.length; i++)
    {
      temp = int(random(0, 18));
      while (scrambleValidMove(i, temp))
        temp = int(random(0, 18));
      scramble_ints[i] = temp;
      switch (temp) {
        case 0:
          scramble[i] = "U";
          break;
        case 1:
          scramble[i] = "U'";
          break;
        case 2:
          scramble[i] = "D";
          break;
        case 3:
          scramble[i] = "D'";
          break;
        case 4:
          scramble[i] = "R";
          break;
        case 5:
          scramble[i] = "R'";
          break;
        case 6:
          scramble[i] = "L";
          break;
        case 7:
          scramble[i] = "L'";
          break;
        case 8:
          scramble[i] = "F";
          break;
        case 9:
          scramble[i] = "F'";
          break;
        case 10:
          scramble[i] = "B";
          break;
        case 11:
          scramble[i] = "B'";
          break;
        case 12:
          scramble[i] = "U2";
          break;
        case 13:
          scramble[i] = "D2";
          break;
        case 14:
          scramble[i] = "R2";
          break;
        case 15:
          scramble[i] = "L2";
          break;
        case 16:
          scramble[i] = "F2";
          break;
        case 17:
          scramble[i] = "B2";
          break;
          /*
        case 0:
          scramble[i] = "top left ";
          break;
        case 1:
          scramble[i] = "top right ";
          break;
        case 2:
          scramble[i] = "bottom right ";
          break;
        case 3:
          scramble[i] = "bottom left ";
          break;
        case 4:
          scramble[i] = "right up ";
          break;
        case 5:
          scramble[i] = "right down ";
          break;
        case 6:
          scramble[i] = "left down ";
          break;
        case 7:
          scramble[i] = "left up ";
          break;
        case 8:
          scramble[i] = "face right ";
          break;
        case 9:
          scramble[i] = "face left ";
          break;
        case 10:
          scramble[i] = "back left ";
          break;
        case 11:
          scramble[i] = "back right ";
          break;
        case 12:
          scramble[i] = "top twice ";
          break;
        case 13:
          scramble[i] = "bottom twice ";
          break;
        case 14:
          scramble[i] = "right twice ";
          break;
        case 15:
          scramble[i] = "left twice ";
          break;
        case 16:
          scramble[i] = "front twice ";
          break;
        case 17:
          scramble[i] = "back twice ";
          break;
          */
      }
    }
  }
  public boolean scrambleValidMove(int i, int temp) {
    return (i > 0 && ((temp == scramble_ints[i - 1]) 
              || (temp % 2 == 0 && scramble_ints[i - 1] == temp + 1)
              || (temp % 2 == 1 && scramble_ints[i - 1] == temp - 1)
              || (temp == 12 && (scramble_ints[i - 1] == 0 || scramble_ints[i - 1] == 1))
              || (temp == 13 && (scramble_ints[i - 1] == 2 || scramble_ints[i - 1] == 3))
              || (temp == 14 && (scramble_ints[i - 1] == 4 || scramble_ints[i - 1] == 5))
              || (temp == 15 && (scramble_ints[i - 1] == 6 || scramble_ints[i - 1] == 7))
              || (temp == 16 && (scramble_ints[i - 1] == 8 || scramble_ints[i - 1] == 9))
              || (temp == 17 && (scramble_ints[i - 1] == 10 || scramble_ints[i - 1] == 11))
              || (scramble_ints[i - 1] == 12 && (temp == 0 || temp == 1))
              || (scramble_ints[i - 1] == 13 && (temp == 2 || temp == 3))
              || (scramble_ints[i - 1] == 14 && (temp == 4 || temp == 5))
              || (scramble_ints[i - 1] == 15 && (temp == 6 || temp == 7))
              || (scramble_ints[i - 1] == 16 && (temp == 8 || temp == 9))
              || (scramble_ints[i - 1] == 17 && (temp == 10 || temp == 11))));
  }
  
  public int getInspectionTime() {
    return inspection_time; 
  }
  public void setInspectionTime(int aInspection_time) {
    inspection_time = aInspection_time; 
  }
}
