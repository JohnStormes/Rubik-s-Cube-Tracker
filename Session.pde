import java.util.LinkedList;

//constructor
public class Session {
  Solve[] solves = new Solve[1000];      //array of solves. any non-initialized solves are null
  private int num_of_solves;             //stores number of solves. num_of_solves index is always the first null reference
  private int stored_page_num;           //used only for storing the page number for reloading application
  
  //general vars (self explanatory)
  private int type;
  private double worst;
  private double best;
  private double session_avg;
  private double avg_of_5;
  private String name;
  public Session(int aType, String aName) {
    type = aType;
    System.out.println(type);
    name = aName;
    worst = 0;
    best = 100000;
    num_of_solves = 0;
    stored_page_num = 0;
  }
  
  //*******************************************************************************************************************************************************************
  //*******************************************************************************************************************************************************************
  //solves functions
  
  //adds a solve, given a scramble (in the form of an array of strings, each representing a move) and a time
  public void addSolve(String[] scramble, double time) {
    solves[num_of_solves] = new Solve(scramble, time);
    num_of_solves++;
    if (time < best)
      best = time;
    if (time > worst)
      worst = time;
    calculateSessionAverage();
    calculateAverageOf5();
  }
  
  //*******************************************************************************************************************************************************************
  
  //removes a solve, given the index of the solve. Assumes solve index is in the array, because program should not throw incorrect indexes
  public void removeSolve(int solveIndex) {
    double temp = solves[solveIndex].getTime();
    for (int i = solveIndex; i < num_of_solves - 1; i++) {
      solves[i] = solves[i+1];
    }
    solves[num_of_solves - 1] = null;
    num_of_solves--;
    
    if (temp == worst) {
      worst = 0;
      for (int i = 0; i < num_of_solves; i++) {
        if (solves[i].getTime() > worst)
          worst = solves[i].getTime();
      }
    }
    if (temp == best) {
      best = 100000;
      for (int i = 0; i < num_of_solves; i++) {
        if (solves[i].getTime() < best)
          best = solves[i].getTime();
      }
    }
    calculateSessionAverage();
    calculateAverageOf5();
  }
  
  //*******************************************************************************************************************************************************************
  //*******************************************************************************************************************************************************************
  //general use
  
  //calculates the session average. called after adding or removing a solve
  private void calculateSessionAverage() {
    if (num_of_solves == 0)
      session_avg = 0;
    double total = 0;
    for (int i = 0; i < num_of_solves; i++) {
      total += solves[i].getTime();
    }
    session_avg = total / num_of_solves;
  }
  
  //*******************************************************************************************************************************************************************
  
  //calculates the sessions's average of 5, called after adding or removing a solve
  private void calculateAverageOf5() {
    if (num_of_solves == 0)
      avg_of_5 = 0;
    double total = 0;
    int difference;
    if (num_of_solves <= 5)
      difference = num_of_solves;
    else
      difference = 5;
    for (int i = num_of_solves - difference; i < num_of_solves; i++) {
      total += solves[i].getTime();
    }
    avg_of_5 = total / difference;
  }
  
  //*******************************************************************************************************************************************************************
  //*******************************************************************************************************************************************************************
  //accessors and mutators
  
  //accessors
  public String getType() {
    switch (type) {
      case 0:
        return "2X2";
      case 1:
        return "3X3";
      case 2:
        return "4X4";
      case 3:
        return "5X5";
      case 4:
        return "6X6";
      case 5:
        return "7X7";
    }
    return "-1";
  }
  public int getTypeInt() {
    return type; 
  }
  public double getWorst() {
    return worst;
  }
  public double getBest() {
    if (num_of_solves == 0)
      return 0.0;
    return best;
  }
  public double getSessionAverage() {
    return session_avg;
  }
  public double getAverageOf5() {
    return avg_of_5;
  }
  public String getName() {
    return name;
  }
  public int getNumOfSolves() {
    return num_of_solves;
  }
  public Solve getSolve(int index) {
    return solves[index];
  }
  public int getPageNum() {
    return stored_page_num; 
  }
  
  //*******************************************************************************************************************************************************************
  
  //mutators
  public void setName(String aName) {
    name = aName;
  }
  public void storePageNum(int page) {
    stored_page_num = page;
  }
  public void setPuzzleType(int solveType) {
    type = solveType;
  }
}
