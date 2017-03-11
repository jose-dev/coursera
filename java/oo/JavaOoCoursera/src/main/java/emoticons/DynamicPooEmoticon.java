package emoticons;

import processing.core.PApplet;

/**
 * Created by josejimenez on 11/03/2017.
 */
public class DynamicPooEmoticon extends PApplet {
    int picWidth = 400;
    int picHeight = 400;
    double faceWidthRatio = 0.975;
    double faceHeightRatio = 0.3;
    double eyeSizeRatio = 0.14;
    double eyePupilRatio = 0.04;
    double mouthRatio = 0.3;

    public void setup() {
        size(picWidth, picHeight);
        background(200, 200, 200);
    }

    public void draw(){
        // body
        fill(153, 76, 0);
        ellipse(width/2, (int)(height * 0.3), (int)(width * faceWidthRatio * 0.2), (int)(height * faceHeightRatio));
        ellipse(width/2, (int)(height * 0.4), (int)(width * faceWidthRatio * 0.6), (int)(height * faceHeightRatio));
        ellipse(width/2, (int)(height * 0.6), (int)(width * faceWidthRatio * 0.8), (int)(height * faceHeightRatio));
        ellipse(width/2, (int)(height * 0.8), (int)(width * faceWidthRatio), (int)(height * faceHeightRatio));

        //eyes
        fill(255, 255, 255);
        ellipse((int)(width * 0.4), height / 2, (int)(width * eyeSizeRatio), (int)(height * eyeSizeRatio));
        ellipse((int)(width * 0.6), height / 2, (int)(width * eyeSizeRatio), (int)(height * eyeSizeRatio));
        fill(0, 0, 0);
        ellipse((int)(width * 0.4), height / 2, (int)(width * eyePupilRatio), (int)(height * eyePupilRatio));
        ellipse((int)(width * 0.6), height / 2, (int)(width * eyePupilRatio), (int)(height * eyePupilRatio));

        // mouth
        fill(255, 255, 255);
        arc(width/2, (int)(height * 0.60), (int)(width * mouthRatio), (int)(height * mouthRatio), 0, PI, CHORD);

    }
}
