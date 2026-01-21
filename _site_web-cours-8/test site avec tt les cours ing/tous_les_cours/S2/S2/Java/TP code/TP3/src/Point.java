public class Point {
    private double x;
    private double y;
    public Point(double x, double y){
        this.x = x;
        this.y = y;
    }

    public Point(){
        this(0,0);
    }

    public double getX(){ //permet de retourner x car x en privé : Getters
        return x;
    }
    public double getY(){ //permet de retourner y car y en privé : Getters
        return y;
    }
    public void setX(double x){ // setters
        this.x = x;
    }
    public void setY(double y){ // setters
        this.y = y;
    }

    // question 5
    @Override
    public String toString() {
        return "(" + getX() + "," + getY() + ")"; // pas besoin de this car comme pas de paramètres en
        // entrée la fonction va directemment chercher le x et le y de la classe au début
    }

    // question 6
    public boolean equals(Object obj){
        if (obj instanceof Point){
            Point b = (Point) obj;
            return (this.getX() == b.getX() && this.getY() == b.getY()); // voir si fonctionne (av b.x)
        }
        return false;
    }

    // question 7
    public double distance(Point a){
        return Math.sqrt(Math.pow(this.getX() - a.getX(),2) + Math.pow(this.getY() - a.getY(),2)); // voir si fonctionne (av a.x)
    }

    // question 8
    public void translate(double dx, double dy){
        setX(getX() + dx);
        setY(getY() + dy);
    }
}