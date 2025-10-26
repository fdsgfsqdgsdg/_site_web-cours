// Press Shift twice to open the Search Everywhere dialog and type `show whitespaces`,
// then press Enter. You can now see whitespace characters in your code.


public class Main {
    public static void main(String[] args){
        System.out.println(zeller(2024, 1, 1));

    }

    public static String zeller(int year, int month, int day) {
        int mm = month;
        mm = mm-2;
        if (mm < 1) {
            mm += 12;
            year -= 1;
        }
        int aa = year % 100;
        int ss = year / 100;
        System.out.println(mm);
        int dayOfWeek = ((13*mm-1)/5 + day + aa + aa/4 + ss/4 - 2 * ss) % 7;
        System.out.println(dayOfWeek);
        return day(dayOfWeek);
    }


    public static String day(int day) {
        return switch (day) {
            case 0 -> "Dimanche";
            case 1 -> "Lundi";
            case 2 -> "Mardi";
            case 3 -> "Mercredi";
            case 4 -> "Jeudi";
            case 5 -> "Vendredi";
            case 6 -> "Samedi";
            default -> "Error Bad Day";
        };
    }
}

