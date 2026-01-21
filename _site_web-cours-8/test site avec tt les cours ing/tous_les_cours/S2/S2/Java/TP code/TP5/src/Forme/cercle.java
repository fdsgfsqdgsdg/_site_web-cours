package Forme;

public class cercle implements Forme {
    double rayon;
    public cercle(double r){
        rayon = r;
    }
    public double getRayon(){
        return rayon;
    }
    public void setRayon(double r) {
        rayon = r;
    }
    @Override
    public double calculerSurface() {
        return getRayon()*getRayon()*Math.PI;
    }
    @Override
    public String toString() {
        return ("C'est un Forme.cercle.Forme.cercle de rayon : " + rayon);
    }
    public boolean equals(Object c){ // car définit dans la classe Object car forme fait référence a un objet
        if (c instanceof cercle){
            if (this.rayon == ((cercle) c).rayon){
                return true;
            }
        }
        return false;
    }

    public static interface Forme {
        double calculerSurface();
    }
}
