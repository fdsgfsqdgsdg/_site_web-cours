public class Segment {
    private Point a;
    private Point b;

    public Point getA() {
        return a;
    }

    public Point getB() {
        return b;
    }

    public void setA(Point a) {
        this.a = a;
    }

    public void setB(Point b) {
        this.b = b;
    }

    public Segment(Point x, Point y){
        a = x;
        b = y;
    }

    // recopie superficielle
    public Segment(Segment s){
        // recopie superficielle
        a = s.getA();
        b = s.getB();
        // recopie profonde
        a = new Point(s.a.getX(), s.a.getY());
        b = new Point(s.b.getX(), s.b.getY());
    }

    public static void main(String[] args){
        Segment s1 = new Segment(new Point(), new Point());
        Segment s2 = new Segment(s1);
        System.out.println(s1);
        System.out.println(s2);
        System.out.println(s1 == s2);
        s1.setA(new Point(10,2));
        System.out.println(s1);
        System.out.println(s2);
    }
}
