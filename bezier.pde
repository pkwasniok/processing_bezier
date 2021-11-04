public class Point{
    float x, y;
    Point(float x, float y)
    {
        this.x = x;
        this.y = y;
    }
}

Point bezier_point(float t, Point anchor1, Point anchor2, Point control1){
    Point point = new Point(0,0);
    point.x = (pow((1 - t), 2) * anchor1.x) + (2 * (1 - t) * t * control1.x) + (pow(t, 2) * anchor2.x);
    point.y = (pow((1 - t), 2) * anchor1.y) + (2 * (1 - t) * t * control1.y) + (pow(t, 2) * anchor2.y);
    return point;
}

float resolution = 0.005;

void setup()
{
    size(800, 600);
    frameRate(90);
}

void draw(){
    background(0);

    //Create anchor points
    Point anchor1 = new Point(10, 300);
    Point anchor2 = new Point(790, 300);

    //Create control points
    Point control1 = new Point(mouseX, mouseY);

    stroke(255);
    strokeWeight(5);
    for(float i=0; i<1-resolution; i+=resolution)
    {
        Point P1 = bezier_point(i, anchor1, anchor2, control1);
        Point P2 = bezier_point(i+resolution, anchor1, anchor2, control1);
        colorMode(HSB);
        stroke(100 + (100 * i), 255, 255);
        line(P1.x, P1.y, P2.x, P2.y);
    }
}