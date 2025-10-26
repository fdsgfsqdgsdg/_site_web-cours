package Forme;

public class carre implements Forme {
    double cote;
    public carre(double c){
        cote = c;
    }
    public double getCote() {
        return cote;
    }
    public void setCote(double c){
        cote = c;
    }
    @Override
    public double calculerSurface() {
        return cote * cote;
    }
    @Override
    public String toString() {
        return ("C'est un carré de côté : " + cote);
    }

    public boolean equals(Object c){ // car définit dans la classe Object car forme fait référence a un objet
        if (c instanceof carre){
            if (this.cote == ((carre) c).cote){
                return true;
            }
        }
        return false;
    }
}