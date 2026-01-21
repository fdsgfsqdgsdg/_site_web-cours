// question 9
public class TestPoint {
    public static void main(String[] args){
        Point p1 = new Point(1,2);
        Point p2 = new Point();
        Point p3;
        System.out.println(p1);

        p2.translate(1,2);
        System.out.println(p1 == p2); // false car pas même références
        System.out.println(p1.equals(p2));
    }
}
