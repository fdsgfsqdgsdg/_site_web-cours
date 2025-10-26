public class Suite {
    public static int u(int n, int u0, int u1) throws SuiteException {
        if (n == 0){
            return u0;
        }
        else if (n == 1){
            return u1;
        }
        else {
            try {
                if (n % 2 == 0){
                    return u(n-1, u0, u1)/u(n-2, u0, u1) - u(n-2, u0, u1)/u(n-1, u0, u1); // u(n-1, u1, (u1(u0-u0/u1)))
                }
                else {
                    return u(n-2, u0, u1)/u(n-1, u0, u1) - u(n-1, u0, u1)/u(n-2, u0, u1);
                }
            } catch (ArithmeticException e) {
                SuiteException suiteE = new SuiteException("division par 0");
                suiteE.ajouterTrace("dans la suite u("+n+","+u0+","+u1+")");
                //throw new SuiteException("division par 0");
                throw suiteE;
            } catch (SuiteException s) {
                s.ajouterTrace("qui est appelée dans la suite u("+n+","+u0+","+u1+")");
                throw s;
            }
        }
    }
}
