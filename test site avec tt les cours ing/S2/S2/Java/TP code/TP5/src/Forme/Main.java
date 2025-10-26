package Forme;

import Forme.TestForme;

public class Main {
    public static void main(String[] args) {
        carre c = new carre(2); // on peut remplacer Forme.cercle.Forme.carre par forme mais on ne pourra pas faire c.getCote()
        cercle circle = new cercle(5);
        TestForme.compare(c, circle); // upcast
    }
}