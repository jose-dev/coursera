package trygui.emoticons;

import processing.core.PApplet;

public class MyEmoticons extends PApplet {
	int picWidth = 400;
	int picHeight = 400;
	int emotWidth = picWidth - 10;
	int emotHeight = picHeight - 10;
	
	public void setup() {
		size(picWidth, picHeight);
		background(200, 200, 200);
	}
	
	public void draw(){
		lol();
	}
	
	public void lol() {
		// face
		fill(255, 255, 0);
		ellipse(picWidth/2, picHeight/2, emotWidth, emotHeight);
		
		//eyes
		fill(0, 0, 0);
		ellipse(picWidth/3, picHeight/3, 50, 70);
		ellipse(2*picWidth/3, picHeight/3, 50, 70);
		
		// mouth
		fill(255, 255, 255);
		arc(picWidth/2, picHeight/2, emotWidth-80, emotHeight-80, 0, PI, CHORD);		
		
	}

}
