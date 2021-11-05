float resolution = 0.05;

Point[] anchors = {};
Point[] controls = {};

public static class Point{
    float x, y;

    Point(float x, float y)
    {
        this.x = x;
        this.y = y;
    }

    public static Point[] append(Point[] arr, Point point)
    {
        Point[] output = new Point[arr.length+1];
        output[output.length-1] = point;
        for(int i=0; i<arr.length; i++)
        {
            output[i] = arr[i];
        }
        return output;
    }

    public static Point[] remove(Point[] arr, int index)
    {
        Point[] output = new Point[arr.length-1];
        int offset = 0;
        for(int i=0; i<arr.length; i++)
        {
            if(i == index)
            {
                i++;
                offset = -1;
                continue;
            }
            output[i+offset] = arr[i];
        }
        return output;
    }
}

Point bezier_point(float t, Point anchor1, Point anchor2, Point control1){
    Point point = new Point(0,0);
    point.x = (pow((1 - t), 2) * anchor1.x) + (2 * (1 - t) * t * control1.x) + (pow(t, 2) * anchor2.x);
    point.y = (pow((1 - t), 2) * anchor1.y) + (2 * (1 - t) * t * control1.y) + (pow(t, 2) * anchor2.y);
    return point;
}

int mouseOnPoint(Point[] points, float radius)
{
    for(int i=0; i<points.length; i++)
    {
        if(abs(points[i].x-mouseX) <= radius && abs(points[i].y-mouseY) <= radius)
            return i;
    }
    return -1;
}

void setup()
{
    size(800, 600);
    frameRate(90);
}

void draw(){
    background(255);

    if(mousePressed)
    {
        int selectedControlPoint = mouseOnPoint(controls, 15);
        if(selectedControlPoint != -1)
        {
            controls[selectedControlPoint].x = mouseX;
            controls[selectedControlPoint].y = mouseY;
        }
        else
        {
            anchors = Point.append(anchors, new Point(mouseX, mouseY));
            if(anchors.length > 1)
                controls = Point.append(controls, new Point(lerp(anchors[anchors.length-1].x, anchors[anchors.length-2].x, 0.5), lerp(anchors[anchors.length-1].y, anchors[anchors.length-2].y, 0.5)));           
            mousePressed = false;
        }
    }

    if(keyPressed)
    {
        if(key == 'c')
        {
            anchors = new Point[0];
            controls = new Point[0];
        }
        if(key=='u')
        {
            if(controls.length >= 1)
                controls = Point.remove(controls, controls.length-1);
            anchors = Point.remove(anchors, anchors.length-1);
        }
        keyPressed = false;
    }

    for(int i=0; i<controls.length; i++)
    {
        strokeWeight(7);
        stroke(255,0,0);
        point(controls[i].x, controls[i].y);
        stroke(0);
        strokeWeight(3);
        for(float j=0; j<1.0000001; j+=resolution)
        {
            Point point1 = bezier_point(j, anchors[i], anchors[i+1], controls[i]);
            Point point2 = bezier_point(j+resolution, anchors[i], anchors[i+1], controls[i]);
            line(point1.x, point1.y, point2.x, point2.y);
        }
    }
}