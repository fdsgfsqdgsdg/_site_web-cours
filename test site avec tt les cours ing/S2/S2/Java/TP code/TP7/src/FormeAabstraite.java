public abstract class FormeAabstraite implements Forme {
    public boolean estPlusGrand(Forme f){
        ...
    }
    private Point centreGravite;
    public void deplacerForme(double dx, double dy){
        centreGravite.deplacer(dx,dy);
    }
    public FormeAabstraite(Point centreGravite){
        this.centreGravite = centreGravite;
    }
}
