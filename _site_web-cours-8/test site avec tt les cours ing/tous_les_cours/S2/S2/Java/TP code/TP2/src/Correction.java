public class Correction {

    public static String dayOfWeek(int n) {
        switch (n) {
            case 0:
                return "dimanche";
            case 1:
                return "lundi";
            case 2:
                return "mardi";
            case 3:
                return "mercredi";
            case 4:
                return "jeudi";
            case 5:
                return "vendredi";
            case 6:
                return "samedi";
            default:
                return "erreur";
        }
    }

    public static int zellerCongruence(int j, int m, int ss, int aa) {
        if (m == 1) {
            m = 11;
            aa = aa - 1;
        } else if (m == 2) {
            m = 12;
            aa = aa - 1;
        } else {
            m = m - 2;
        }
        if (aa == -1) {
            aa = 99;
            ss = ss - 1;
        }
        int z = ((13 * m - 1) / 5 + j + aa + aa / 4 + ss / 4 - 2 * ss) % 7; //'-N < X % N < N
        while (z < 0)
            z += 7;
        return z;
    }

    public static double machinFormula() {
        int k = 0;
        double s5 = 16.0 / 5.0;
        double s239 = 4.0 / 239.0;
        double diff = s5 - s239;
        double pi = diff;
        while (diff != 0) {
            k = k + 1;
            s5 = s5 / 25.0; // S5 = 16/5^(2*k+1)
            s239 = s239 / 239.0 / 239.0; // S239 = 4/239^(2*k+1)
            diff = s5 - s239;
            if (k % 2 == 1) {
                pi = pi - diff / (2 * k + 1);
            } else {
                pi = pi + diff / (2 * k + 1);
            }
        }
        return pi;
    }

    public static double machinFormula(int n) {
        double s5 = 16.0 / 5.0;
        double s239 = 4.0 / 239.0;
        double pi = s5 - s239;
        for (int k = 1; k <= n; k++) {
            s5 /= (5.0 * 5.0);
            s239 /= (239.0 * 239.0);
            double diff = s5 - s239;
            if (k % 2 == 1) {
                pi = pi - diff / (2 * k + 1);
            } else {
                pi = pi + diff / (2 * k + 1);
            }
        }
        return pi;
    }

    // public static double machinFormula(int n) {
    // double pi = 0, a = -4 * 5, b = -239;
    // for (int k = 0; k < n; k++) {
    // a /= -5 * 5;
    // b /= -239 * 239;
    // pi += (a - b) / (2 * k + 1);
    // }
    // return pi * 4;
    // }

    public static void main(String[] args) {
        for (int i = 1; i <= 7; i++) {
            System.out.println(dayOfWeek(i % 7));
        }
        System.out.println("Le 27 javier 2016 est un " + dayOfWeek(zellerCongruence(28, 1, 20, 22)));
        System.out.println("Le 1er javier 2000 est un " + dayOfWeek(zellerCongruence(1, 1, 20, 0)));
        System.out.println("Approximation de pi : " + machinFormula());
        System.out.println("Approximation de pi : " + machinFormula(15));
    }

}

