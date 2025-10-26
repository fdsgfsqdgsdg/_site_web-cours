public class Main {
    public static void main(String[] args) {
        System.out.println("Hello world!");
        Point1D p1 = new Point1D(1);
        Point2D p2 = new Point2D(1,2);
        System.out.println(p1.equals(p2)); //true car p2 instance de 1D par héritage
        System.out.println(p2.equals(p1)); //false car p2 est 1D et pas 2D
    }
}