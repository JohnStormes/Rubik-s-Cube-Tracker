//class used in mass amounts in session class to keep track of all data

public class Solve {
  //vars, scramble is just a combined version of scrambleMoves
  private String[] scramble_moves;
  private String scramble;
  private double time;
  
  //constructor, takes a string representing the scramble (each move is a string), and a time
  public Solve(String[] aScramble_moves, double aTime) {
    scramble_moves = aScramble_moves;
    time = aTime;
    scramble = "";
    for (int i = 0; i < scramble_moves.length; i++) {
      scramble += scramble_moves[i];
      if (i != scramble_moves.length - 1)
        scramble += ", ";
    }
  }
  
  //*******************************************************************************************************************************************************************
  
  //returns the individual moves of the scramble as an array of strings
  public String[] getScrambleMoves() {
    String[] ret = new String[scramble_moves.length];
    for (int i = 0; i < scramble_moves.length; i++)
      ret[i] = scramble_moves[i];
    return ret;
  }
  
  //*******************************************************************************************************************************************************************
  
  //returns the scramble as a single combined string
  public String getScramble() {
    return scramble;
  }
  
  //*******************************************************************************************************************************************************************
  
  //returns the time
  public double getTime() {
    return time; 
  }
}
