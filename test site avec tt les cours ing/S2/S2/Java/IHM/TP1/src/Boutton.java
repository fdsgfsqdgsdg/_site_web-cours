import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.Stage;


public class Boutton extends Application {
    public void start(Stage firstStage) throws Exception {
        //String fileCSS = this.getClass().getResource("Ressources/style.css").toExternalForm();
        firstStage.setTitle("Titre");
        Button button = new Button();
        button.setPrefSize(400,100);
        //button.setStyle("-fx-background-color: red; -fx-border-color: blue; -fx-text-fill: white;");
        //button.setDisable(true);
        Scene scene = new Scene(button);
        //scene.getStylesheets().add("style.css");
        firstStage.setScene(scene);
        firstStage.show();
    }
    public static void main(String[] args) {
        launch(args);
    }
}