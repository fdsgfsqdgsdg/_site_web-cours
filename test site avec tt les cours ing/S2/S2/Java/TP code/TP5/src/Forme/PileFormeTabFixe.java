package Forme;

public class PileFormeTabFixe implements PileForme {
    private Forme[] tableau;
    private int sommet;
    public PileFormeTabFixe(int taille){
        this.tableau = new Forme[taille];
        sommet = -1;
    }
    public void empiler(Forme e) {
        if (this.sommet < this.tableau.length){
            this.sommet += 1;
            this.tableau[this.sommet] = e;
        }
    }
    public boolean vide() {
        if (this.sommet == -1) {
            return true;
        }
        return false;
    }
    public Forme sommet() {
        if (vide()){
            return null;
        }
        else {
            return tableau[sommet];
        }
    }
    public void depiler() {
        if (this.vide() == false){
            this.sommet -= 1;
        }
    }
}
