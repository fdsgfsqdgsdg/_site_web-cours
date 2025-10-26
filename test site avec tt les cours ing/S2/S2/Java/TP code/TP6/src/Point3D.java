public class Point3D extends Point2D{
    private double z;
    public Point3D(double x, double y, double z){
        super(x, y);
        this.z = z;
    }
    public double getZ(){
        return z;
    }
    public void setZ(double z){
        this .z = z;
    }
    @Override
    public String toString() {
        return super.toString()+"z : "+getZ();
    }
    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Point3D){
            Point3D p = (Point3D) obj;
            if (super.equals(p) && this.z == p.getZ()){
                return true;
            }
        }
        return false;
    }

    public static void afficheEgaux(Point1D p, Point1D[] tab){
        for (Point1D p2:tab){
            if (p.equals(p2)) {
                System.out.println(p2);
            }
        }
    }
}
