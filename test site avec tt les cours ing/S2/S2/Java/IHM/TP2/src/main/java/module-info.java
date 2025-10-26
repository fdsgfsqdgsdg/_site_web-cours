module org.example.tp2 {
    requires javafx.controls;
    requires javafx.fxml;

    requires com.almasb.fxgl.all;
    requires java.desktop;
    requires javafx.media;

    opens org.example.tp2 to javafx.fxml;
    exports org.example.tp2;
}