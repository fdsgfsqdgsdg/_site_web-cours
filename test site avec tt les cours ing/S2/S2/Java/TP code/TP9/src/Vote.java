import java.util.Map;

public class Vote {
    private final String text;

    public Vote(String t) {
        this.text = t.toUpperCase();
    }
    public String getText(){
        return this.text;
    }

    @Override
    public String toString() {
        return getText();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj instanceof Vote) {
            Vote v = (Vote) obj;
            return v.getText().equals(this.getText()); // pas obligatoire
        }
        return false;
    }

    public static final Vote BLANC = new Vote("BLANC");
    public static final Vote NUL = new Vote("NUL");
    public static final Vote OUI = new Vote("OUI");
    public static final Vote NON = new Vote("NON");
}
