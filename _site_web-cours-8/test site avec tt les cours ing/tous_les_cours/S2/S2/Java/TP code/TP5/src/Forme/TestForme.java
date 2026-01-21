package Forme;

public class TestForme {
    public static void compare(Forme a, Forme b){
        if (a.calculerSurface() >= b.calculerSurface()){
            System.out.println(a + " >= " + b);
        }
        else {
            System.out.println(a + " < " + b);
        }
    }
}
