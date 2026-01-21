package org.example.tp2;

import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.stage.Stage;


public class Compteur extends Application {
    public static void main(String[] args) {
        launch(args);
    }
    public void start(Stage primaryStage) {
        Button button = new Button("0");
        button.setOnAction(new EventHandler<ActionEvent>() {
            public void handle(ActionEvent event) {
                int num = Integer.parseInt(button.getText());
                num++;
                button.setText(String.valueOf(num));
            }
        });
        Scene scene = new Scene(button);
        button.setPrefSize(200,200);
        primaryStage.setTitle("Compteur");
        primaryStage.setScene(scene);
        primaryStage.show();
    }
}
