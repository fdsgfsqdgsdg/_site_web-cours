import java.util.Set;

public class PointPolaire {
    private double o;
    private double p;
    public PointPolaire(double x, double y){
        this.o = Math.atan2(y,x);
        this.p = Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
    }

    public PointPolaire(){
        this(0,0);
    }

    public double getX(){ //permet de retourner x car x en privé : Getters
        return (Math.cos(o)*p);
    }
    public double getY(){ //permet de retourner y car y en privé : Getters
        return (Math.sin(o)*p);
    }

    public double getO() {
        return o;
    }

    public double getP() {
        return p;
    }

    public void setO(double o) {
        this.o = o;
    }

    public void setP(double p) {
        this.p = p;
    }

    public void setX(double x){ // setters
        double y = getY();
        o = Math.atan2(y,x);
        p = Math.sqrt(Math.pow(x,2) + Math.pow(y,2));
    }
    public void setY(double y){ // setters
        double x = getX();
        o = Math.atan2(y,x);
        p = Math.sqrt(Math.pow(x,2) + Math.pow(y,2));
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

    public void rotation(double angle){
        setO(getO() + angle);
    }
}