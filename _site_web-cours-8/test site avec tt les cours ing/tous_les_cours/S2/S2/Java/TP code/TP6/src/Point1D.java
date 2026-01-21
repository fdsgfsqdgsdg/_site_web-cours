public class Point1D { // extends Object implicite
    private double x;
    // super(); implicite
    public Point1D(double x){
        this.x = x;
    }
    public double getX() {
        return x;
    }
    public void setX(double x) {
        this.x = x;
    }

    @Override
    public String toString() {
        return "x : "+getX();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Point1D){
            Point1D p = (Point1D) obj;
            if (this.x == p.getX()){
                return true;
            }
        }
        return false;
    }
}
