package emoticons;

import processing.core.PApplet;

public class DynamicLaughingEmoticon extends PApplet {
    int picWidth = 400;
    int picHeight = 400;
    double faceRatio = 0.975;
    double eyeWidthRatio = 0.125;
    double eyeHeightRatio = 0.175;
    double mouthRatio = 0.8;

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
        ellipse(width/2, height/2, (int)(width * faceRatio), (int)(height * faceRatio));

        //eyes
        fill(0, 0, 0);
        ellipse(width/3, height/3, (int)(width * eyeWidthRatio), (int)(height * eyeHeightRatio));
        ellipse(2*width/3, height/3, (int)(width * eyeWidthRatio), (int)(height * eyeHeightRatio));

        // mouth
        fill(255, 255, 255);
        arc(width/2, height/2, (int)(width * mouthRatio), (int)(height * mouthRatio), 0, PI, CHORD);

    }
}
