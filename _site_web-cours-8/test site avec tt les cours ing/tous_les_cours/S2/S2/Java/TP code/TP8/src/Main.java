public class Main {
    public static void main(String[] args) {

        try {
            System.out.println(Suite.u(10,100,2));
            System.out.println(Suite.u(10,100,1));
        } catch (SuiteException e) {
            System.err.println("[ERROR] " + e);
        }
    }
}