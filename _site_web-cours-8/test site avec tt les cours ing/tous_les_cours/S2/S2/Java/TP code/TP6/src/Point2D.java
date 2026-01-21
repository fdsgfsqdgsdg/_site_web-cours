public class Point2D extends Point1D {
    private double y;
    public Point2D(double x, double y){
        super(x); // appel le constructeur public Point1D(double x)
        this.y = y;
    }
    public double getY() {
        return y;
    }
    public void setY(double y) {
        this.y = y;
    }

    @Override
    public String toString() {
        return super.toString()+"y : "+getY();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Point2D){
            Point2D p = (Point2D) obj;
            if (super.equals(p) && this.y == p.getY()){
                return true;
            }
        }
        return false;
    }
}