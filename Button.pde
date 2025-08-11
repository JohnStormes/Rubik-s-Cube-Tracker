public class Button {
   //button vars
   private int x, y, w, h, textSize, curveSize;
   private String text, back_color, hover_color, pressed_color, text_color;
   
   //*******************************************************************************************************************************************************************

   //constructor
   public Button(int ax, int ay, int aWidth, int aHeight, String aText, int aTextSize, String aback_color, String ahover_color, String apressed_color, String atext_color)
   {
     x = ax;
     y = ay;
     w = aWidth;
     h = aHeight;
     text = aText;
     textSize = aTextSize;
     back_color = aback_color;
     hover_color = ahover_color;
     pressed_color = apressed_color;
     text_color = atext_color;
     if (h < w)
       curveSize = h / 2;
     else
       curveSize = w / 2;
   }
   
   //*******************************************************************************************************************************************************************
   
   //must be called to draw the button and have its animations work
   public void draw()
   {
      if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h) {
        if (mousePressed)
          fill(unhex(pressed_color));
        else
          fill(unhex(hover_color));
      } else
        fill(unhex(back_color));
      strokeWeight(0);
      rect(x, y, w, h, curveSize);
      textAlign(CENTER);
      textSize(textSize);
      fill(unhex(text_color));
      text(text, x + (w / 2), y + (h / 2) + (textSize / 3));
   }
   
   //*******************************************************************************************************************************************************************
   
   //must be called when mouse is clicked and returns true if the button is pressed, false if not
   public boolean clicked() 
   {
     if (mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h)
       return true;
     return false;
   }
}
