module org.example.tp3 {
    requires javafx.controls;
    requires javafx.fxml;


    opens org.example.tp3 to javafx.fxml;
    exports org.example.tp3;
}